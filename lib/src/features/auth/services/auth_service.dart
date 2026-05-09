import 'dart:convert';
import 'dart:typed_data';
import 'package:encrypted_notes/src/features/auth/models/login/challenge_response.dart';
import 'package:encrypted_notes/src/features/auth/models/login/login_request.dart';
import 'package:encrypted_notes/src/features/auth/models/login/login_response.dart';
import 'package:encrypted_notes/src/features/auth/models/signup/signup_request.dart';
import 'package:encrypted_notes/src/shared/clients/http/services/http_service.dart';
import 'package:encrypted_notes/src/shared/cryptography/services/crypto_service.dart';
import 'package:sodium_libs/sodium_libs_sumo.dart';

class AuthService {
  final CryptoService _cryptoService;
  final HttpService _httpService;

  AuthService(this._cryptoService, this._httpService);

  //-- LOGIN --

  Future<(String authToken, SecureKey encryptionKey)> loginAsync(
      String username,
      Int8List passwordBytes,) async {
    final challenge = await _httpService.getJson<ChallengeResponse>(
      path: '/auth/Challenge',
      fromJsonT: (j) => ChallengeResponse.fromJson(j),
      queryParameters: {'username': username},
    );

    final loginRequestData = await _generateLoginRequestData(
      challenge,
      username,
      passwordBytes,
    );
    final loginResponse = await _httpService.postJson<LoginResponse>(
      path: "/auth/login",
      data: loginRequestData,
      fromJsonT: (j) => LoginResponse.fromJson(j),
    );

    final keyEncryptionKey = await _cryptoService.deriveEncryptionKey(
      passwordBytes,
      base64Decode(loginResponse.encryptionSaltBase64),
    );
    final masterEncryptionKeyBytes = await _cryptoService.decrypt(
        base64Decode(loginResponse.encryptedEncryptionKeyBase64),
        keyEncryptionKey);
    final masterEncryptionKey = _cryptoService.secureKeyFromBytes(
        masterEncryptionKeyBytes);
    try {
      return (loginResponse.token, masterEncryptionKey);
    } finally {
      keyEncryptionKey.dispose();
      masterEncryptionKeyBytes.fillRange(0, masterEncryptionKeyBytes.length, 0);
    }
  }

  Future<Map<String, dynamic>> _generateLoginRequestData(
    ChallengeResponse challenge,
    String username,
    Int8List passwordBytes,
  ) async {
    Uint8List nonceSignatureBytes = await _signChallengeDetached(
      challenge,
      passwordBytes,
    );
    return LoginRequest(
      username,
      challenge.nonceBase64,
      base64Encode(nonceSignatureBytes),
    ).toJson();
  }

  Future<Uint8List> _signChallengeDetached(
    ChallengeResponse challengeResponse,
    Int8List passwordBytes,
  ) async {
    Uint8List nonceBytes = base64Decode(challengeResponse.nonceBase64);
    Uint8List signatureSaltBytes = base64Decode(
      challengeResponse.signatureSaltBase64,
    );
    final keyPair = await _cryptoService.generateKeyPair(
      passwordBytes,
      signatureSaltBytes,
    );
    final detachedSignature = await _cryptoService.signDetached(
      nonceBytes,
      keyPair.secretKey,
    );
    keyPair.dispose();
    return detachedSignature;
  }

  //-- SIGNUP --

  Future<void> signupAsync(String username, Int8List passwordBytes) async {
    final signupRequestData = await _generateSignupRequestData(
      username,
      passwordBytes,
    );
    await _httpService.postVoid(path: '/auth/signup', data: signupRequestData);
    return;
  }

  Future<Map<String, dynamic>> _generateSignupRequestData(
    String username,
    Int8List passwordBytes,
  ) async {
    final signatureSaltBytes = _cryptoService.generateSalt();
    final encryptionSaltBytes = _cryptoService.generateSalt();
    final keyPair = await _cryptoService.generateKeyPair(
      passwordBytes,
      signatureSaltBytes,
    );
    final publicKeyBytes = keyPair.publicKey;
    keyPair.dispose();

    final keyEncryptionKey = await _cryptoService.deriveEncryptionKey(passwordBytes, encryptionSaltBytes);
    final masterEncryptionKey = await _cryptoService.generateRandomEncryptionKey();
    final masterEncryptionKeyBytes = masterEncryptionKey.extractBytes();

    final encryptedEncryptionKeyBytes = await _cryptoService.encrypt(masterEncryptionKeyBytes, keyEncryptionKey);
    masterEncryptionKey.dispose();
    keyEncryptionKey.dispose();
    masterEncryptionKeyBytes.fillRange(0, masterEncryptionKeyBytes.length, 0);

    return SignupRequest(
      username,
      base64Encode(signatureSaltBytes),
      base64Encode(encryptionSaltBytes),
      base64Encode(publicKeyBytes),
      base64Encode(encryptedEncryptionKeyBytes)
    ).toJson();
  }

  //-- DELETE --
  Future<void> deleteUserAsync(String authToken) async {
    await _httpService.delete(path: '/user/me', authToken: authToken);
  }
}
