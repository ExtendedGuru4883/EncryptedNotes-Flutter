import 'package:encrypted_notes/src/shared/cryptography/services/crypto_service.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:sodium_libs/sodium_libs_sumo.dart';

part 'crypto_provider.g.dart';

@Riverpod(keepAlive: true)
Future<SodiumSumo> sodiumSumo(Ref ref) async {
  return await SodiumSumoInit.init();
}

@Riverpod(keepAlive: true)
Future<CryptoService> cryptoService(Ref ref) async {
  final sodiumSumo = await ref.read(sodiumSumoProvider.future);

  final cryptoService = await CryptoService.initialize(sodiumSumo);

  ref.onDispose(cryptoService.dispose);
  
  return cryptoService;
}