import 'package:encrypted_notes/src/shared/utils/jwt_helper.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:sodium_libs/sodium_libs_sumo.dart';

part 'auth_state.freezed.dart';

@freezed
sealed class AuthState with _$AuthState {
  const AuthState._();

  const factory AuthState.unauthenticated({String? message}) = Unauthenticated;

  const factory AuthState.authenticated({
    required String authToken,
    required SecureKey encryptionKey,
  }) = Authenticated;
}

@freezed
abstract class Authenticated extends AuthState with _$Authenticated {
  const Authenticated._() : super._();

  const factory Authenticated({
    required String authToken,
    required SecureKey encryptionKey,
  }) = _Authenticated;

  String get username => JwtHelper.parseUsername(authToken);
}
