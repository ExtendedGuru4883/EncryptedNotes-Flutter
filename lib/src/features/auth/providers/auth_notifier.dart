import 'dart:convert';
import 'dart:typed_data';

import 'package:encrypted_notes/src/features/auth/models/auth_state.dart';
import 'package:encrypted_notes/src/features/auth/providers/auth_service_provider.dart';
import 'package:encrypted_notes/src/features/auth/services/auth_service.dart';
import 'package:encrypted_notes/src/shared/cryptography/providers/crypto_provider.dart';
import 'package:encrypted_notes/src/shared/exceptions/unauthorized_exception.dart';
import 'package:encrypted_notes/src/shared/storage/secure_storage/providers/secure_storage_provider.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:sodium_libs/sodium_libs_sumo.dart';

part "auth_notifier.g.dart";

@Riverpod(keepAlive: true)
class AuthNotifier extends _$AuthNotifier {
  late final FlutterSecureStorage _secureStorage;
  late final SodiumSumo _sodium;
  late final AuthService _authService;

  @override
  Future<AuthState> build() async {
    _secureStorage = ref.read(secureStorageProvider);
    _sodium = await ref.read(sodiumSumoProvider.future);
    _authService = await ref.read(authServiceProvider.future);

    listenSelf((previous, next) {
      SecureKey? previousKey;
      SecureKey? nextKey;
      if (previous?.value case Authenticated(:final encryptionKey)) {
        previousKey = encryptionKey;
      }
      if (next.value case Authenticated(:final encryptionKey)) {
        nextKey = encryptionKey;
      }
      if (previousKey != null && (nextKey == null || nextKey != previousKey)) {
        previousKey.dispose();
      }
    });

    ref.onDispose(() {
      if (state.value case Authenticated(:final encryptionKey)) {
        encryptionKey.dispose();
      }
    });

    final (authToken, encryptionKey) = await _retrieveCredentials();

    if (authToken == null || encryptionKey == null) {
      if (encryptionKey != null) {
        encryptionKey.dispose();
      }
      return AuthState.unauthenticated();
    }

    return AuthState.authenticated(
      authToken: authToken,
      encryptionKey: encryptionKey,
    );
  }

  Future<void> login(String username, Int8List passwordBytes) async {
    state = const AsyncValue.loading();
    SecureKey? encryptionKey;

    try {
      final (authToken, derivedEncryptionKey) = await _authService.loginAsync(
        username,
        passwordBytes,
      );

      encryptionKey = derivedEncryptionKey;

      await _persistCredentials(authToken, encryptionKey);

      state = AsyncValue.data(
        AuthState.authenticated(
          authToken: authToken,
          encryptionKey: encryptionKey,
        ),
      );
    } catch (ex) {
      if (encryptionKey != null) {
        encryptionKey.dispose();
      }
      state = AsyncValue.data(Unauthenticated(message: ex.toString()));
      rethrow;
    } finally {
      passwordBytes.fillRange(0, passwordBytes.length, 0);
    }
  }

  Future<void> signup(String username, Int8List passwordBytes) async {
    state = const AsyncValue.loading();

    try {
      await _authService.signupAsync(username, passwordBytes);
      await login(username, passwordBytes);
    } catch (ex) {
      passwordBytes.fillRange(0, passwordBytes.length, 0);
      state = AsyncValue.data(
        AuthState.unauthenticated(message: ex.toString()),
      );
      rethrow;
    }
  }

  Future<void> logout({String? message}) async {
    state = const AsyncValue.loading();
    await _wipeCredentials();
    state = AsyncValue.data(AuthState.unauthenticated(message: message));
  }

  Future<void> deleteUser() async {
    state = const AsyncValue.loading();

    if (state.value case Authenticated(:final authToken)) {
      try {
        await _authService.deleteUserAsync(authToken);
        await logout(message: 'User deleted successfully');
      } on UnauthorizedException catch (ex) {
        if (!ref.mounted) return;
        await logout(message: ex.message);
        rethrow;
      } catch (ex) {
        if (!ref.mounted) return;
        state = AsyncValue.error(ex, StackTrace.current);
        rethrow;
      }
    }
  }

  Future<(String? authToken, SecureKey? encryptionKey)>
  _retrieveCredentials() async {
    try {
    final authToken = await _secureStorage.read(key: 'authToken');

    final encryptionKeyBase64 = await _secureStorage.read(
      key: 'encryptionKeyBase64',
    );

    if (authToken == null || encryptionKeyBase64 == null) return (null, null);

    final encryptionKeyBytes = base64Decode(encryptionKeyBase64);
    final encryptionKey = _sodium.secureCopy(encryptionKeyBytes);
    encryptionKeyBytes.fillRange(0, encryptionKeyBytes.length, 0);

    return (authToken, encryptionKey);
    } catch (ex) {
      await _secureStorage.deleteAll();
      return (null, null);
    }
  }

  Future<void> _persistCredentials(
    String token,
    SecureKey encryptionKey,
  ) async {
    await _secureStorage.write(key: 'authToken', value: token);

    final encryptionKeyBytes = encryptionKey.extractBytes();
    try {
      await _secureStorage.write(
        key: 'encryptionKeyBase64',
        value: base64Encode(encryptionKeyBytes),
      );
    } finally {
      encryptionKeyBytes.fillRange(0, encryptionKeyBytes.length, 0);
    }
  }

  Future<void> _wipeCredentials() async {
    await _secureStorage.delete(key: 'authToken');
    await _secureStorage.delete(key: 'encryptionKeyBase64');
  }
}
