import 'package:encrypted_notes/src/features/auth/services/auth_service.dart';
import 'package:encrypted_notes/src/shared/clients/http/providers/http_service_provider.dart';
import 'package:encrypted_notes/src/shared/cryptography/providers/crypto_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'auth_service_provider.g.dart';

@Riverpod(keepAlive: true)
Future<AuthService> authService(Ref ref) async {
  final cryptoService = await ref.watch(cryptoServiceProvider.future);
  final httpService = ref.read(httpServiceProvider);

  return AuthService(cryptoService, httpService);
}
