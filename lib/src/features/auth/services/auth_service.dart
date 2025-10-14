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
    Int8List passwordBytes,
  ) async {
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

    final encryptionKey = await _cryptoService.deriveEncryptionKey(
      passwordBytes,
      base64Decode(loginResponse.encryptionSaltBase64),
    );

    return (loginResponse.token, encryptionKey);
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

    return SignupRequest(
      username,
      base64Encode(signatureSaltBytes),
      base64Encode(encryptionSaltBytes),
      base64Encode(publicKeyBytes),
    ).toJson();
  }

  //-- DELETE --
  Future<void> deleteUserAsync(String authToken) async {
    await _httpService.delete(path: '/user/me', authToken: authToken);
  }
}
