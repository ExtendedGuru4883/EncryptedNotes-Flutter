import 'dart:isolate';
import 'dart:typed_data';
import 'package:sodium_libs/sodium_libs_sumo.dart';

class CryptoService {
  final SodiumSumo _sodium;
  late final Isolate _isolate;
  late final SendPort _workerSendPort;

  CryptoService._(this._sodium, this._isolate, this._workerSendPort);

  static Future<CryptoService> initialize(SodiumSumo sodium) async {
    final sodiumFactory = sodium.isolateFactory;
    final receivePort = ReceivePort();
    final isolate = await Isolate.spawn(_worker, (
      sodiumFactory,
      receivePort.sendPort,
    ));
    final sendPort = await receivePort.first as SendPort;
    receivePort.close();
    return CryptoService._(sodium, isolate, sendPort);
  }

  static void _worker((SodiumSumoFactory, SendPort) initialMessage) async {
    final (sodiumFactory, sendPort) = initialMessage;
    final sodium = await sodiumFactory();
    final receivePort = ReceivePort();
    sendPort.send(receivePort.sendPort);

    await for (final msg in receivePort) {
      final sendPort = msg[0] as SendPort;
      final cmd = msg[1];
      final args = msg[2] as List<dynamic>;
      switch (cmd) {
        case 'deriveEncryptionKey':
          sendPort.send(_deriveEncryptionKey(args[0], args[1], sodium));
          break;
        case 'decrypt':
          sendPort.send(_decrypt(args[0], args[1], sodium));
          break;
        case 'encrypt':
          sendPort.send(_encrypt(args[0], args[1], sodium));
          break;
        case 'generateKeyPair':
          sendPort.send(_generateKeyPair(args[0], args[1], sodium));
          break;
        case 'signDetached':
          sendPort.send(_signDetached(args[0], args[1], sodium));
          break;
      }
    }
  }

  Uint8List generateSalt() {
    return _sodium.randombytes.buf(_sodium.crypto.pwhash.saltBytes);
  }

  Future<SecureKey> deriveEncryptionKey(
    Int8List passwordBytes,
    Uint8List saltBytes,
  ) async {
    final transferrableSecureKey =
        await _sendCommand('deriveEncryptionKey', [passwordBytes, saltBytes])
            as TransferrableSecureKey;
    return _sodium.materializeTransferrableSecureKey(transferrableSecureKey);
  }

  Future<Uint8List> decrypt(
    Uint8List encryptedTextBytes,
    SecureKey encryptionKey,
  ) async {
    final transferrableSecureKey = _sodium.createTransferrableSecureKey(encryptionKey);
    return await _sendCommand('decrypt', [
      encryptedTextBytes,
      transferrableSecureKey,
    ]);
  }

  Future<Uint8List> encrypt(
    Uint8List textBytes,
    SecureKey encryptionKey,
  ) async {
    final transferrableSecureKey = _sodium.createTransferrableSecureKey(encryptionKey);
    return await _sendCommand('encrypt', [textBytes, transferrableSecureKey]);
  }

  Future<KeyPair> generateKeyPair(
    Int8List passwordBytes,
    Uint8List saltBytes,
  ) async {
    final transferrableKeyPair =
        await _sendCommand('generateKeyPair', [passwordBytes, saltBytes])
            as TransferrableKeyPair;

    return _sodium.materializeTransferrableKeyPair(transferrableKeyPair);
  }

  Future<Uint8List> signDetached(
    Uint8List messageBytes,
    SecureKey privateKey,
  ) async {
    final transferrableSecureKey = _sodium.createTransferrableSecureKey(
      privateKey,
    );
    return await _sendCommand('signDetached', [
      messageBytes,
      transferrableSecureKey,
    ]);
  }

  static TransferrableSecureKey _deriveEncryptionKey(
    Int8List passwordBytes,
    Uint8List saltBytes,
    SodiumSumo sodium,
  ) {
    final secureKey = sodium.crypto.pwhash.call(
      outLen: sodium.crypto.secretBox.keyBytes,
      password: passwordBytes,
      salt: saltBytes,
      opsLimit: sodium.crypto.pwhash.opsLimitModerate,
      memLimit: sodium.crypto.pwhash.memLimitModerate,
      alg: CryptoPwhashAlgorithm.argon2id13,
    );

    final transferrableSecureKey = sodium.createTransferrableSecureKey(
      secureKey,
    );
    secureKey.dispose();
    return transferrableSecureKey;
  }

  static Uint8List _decrypt(
    Uint8List encryptedTextBytes,
    TransferrableSecureKey encryptionKey,
    SodiumSumo sodium,
  ) {
    Uint8List nonce = encryptedTextBytes.sublist(
      0,
      sodium.crypto.secretBox.nonceBytes,
    );
    Uint8List ciphertext = encryptedTextBytes.sublist(
      sodium.crypto.secretBox.nonceBytes,
    );

    final secureKey = sodium.materializeTransferrableSecureKey(encryptionKey);
    final plainText = sodium.crypto.secretBox.openEasy(
      cipherText: ciphertext,
      nonce: nonce,
      key: secureKey,
    );
    secureKey.dispose();
    return plainText;
  }

  static Uint8List _encrypt(
    Uint8List textBytes,
    TransferrableSecureKey encryptionKey,
    SodiumSumo sodium,
  ) {
    Uint8List nonce = sodium.randombytes.buf(
      sodium.crypto.secretBox.nonceBytes,
    );

    final secureKey = sodium.materializeTransferrableSecureKey(encryptionKey);
    Uint8List ciphertext = sodium.crypto.secretBox.easy(
      message: textBytes,
      nonce: nonce,
      key: secureKey,
    );
    secureKey.dispose();

    Uint8List output = Uint8List(nonce.length + ciphertext.length);
    output.setRange(0, nonce.length, nonce);
    output.setRange(nonce.length, output.length, ciphertext);

    return output;
  }

  static TransferrableKeyPair _generateKeyPair(
    Int8List passwordBytes,
    Uint8List saltBytes,
    SodiumSumo sodium,
  ) {
    final seed = sodium.crypto.pwhash.call(
      outLen: sodium.crypto.sign.publicKeyBytes,
      password: passwordBytes,
      salt: saltBytes,
      opsLimit: sodium.crypto.pwhash.opsLimitModerate,
      memLimit: sodium.crypto.pwhash.memLimitModerate,
      alg: CryptoPwhashAlgorithm.argon2id13,
    );

    final keyPair = sodium.crypto.sign.seedKeyPair(seed);
    final transferrableKeyPair = sodium.createTransferrableKeyPair(keyPair);
    seed.dispose();
    keyPair.dispose();
    return transferrableKeyPair;
  }

  static Uint8List _signDetached(
    Uint8List messageBytes,
    TransferrableSecureKey transferrableSecureKey,
    SodiumSumo sodium,
  ) {
    final secureKey = sodium.materializeTransferrableSecureKey(
      transferrableSecureKey,
    );
    final detachedSignature = sodium.crypto.sign.detached(
      message: messageBytes,
      secretKey: secureKey,
    );
    secureKey.dispose();
    return detachedSignature;
  }

  Future<T> _sendCommand<T>(String cmd, List<dynamic> args) async {
    final receivePort = ReceivePort();
    _workerSendPort.send([receivePort.sendPort, cmd, args]);
    final response = await receivePort.first as T;
    receivePort.close();
    return response;
  }

  void dispose() {
    _isolate.kill(priority: Isolate.immediate);
  }
}
