// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'auth_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$AuthState {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AuthState);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'AuthState()';
}


}

/// @nodoc
class $AuthStateCopyWith<$Res>  {
$AuthStateCopyWith(AuthState _, $Res Function(AuthState) __);
}


/// Adds pattern-matching-related methods to [AuthState].
extension AuthStatePatterns on AuthState {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( Unauthenticated value)?  unauthenticated,TResult Function( Authenticated value)?  authenticated,required TResult orElse(),}){
final _that = this;
switch (_that) {
case Unauthenticated() when unauthenticated != null:
return unauthenticated(_that);case Authenticated() when authenticated != null:
return authenticated(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( Unauthenticated value)  unauthenticated,required TResult Function( Authenticated value)  authenticated,}){
final _that = this;
switch (_that) {
case Unauthenticated():
return unauthenticated(_that);case Authenticated():
return authenticated(_that);}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( Unauthenticated value)?  unauthenticated,TResult? Function( Authenticated value)?  authenticated,}){
final _that = this;
switch (_that) {
case Unauthenticated() when unauthenticated != null:
return unauthenticated(_that);case Authenticated() when authenticated != null:
return authenticated(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function( String? message)?  unauthenticated,TResult Function( String authToken,  SecureKey encryptionKey)?  authenticated,required TResult orElse(),}) {final _that = this;
switch (_that) {
case Unauthenticated() when unauthenticated != null:
return unauthenticated(_that.message);case Authenticated() when authenticated != null:
return authenticated(_that.authToken,_that.encryptionKey);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function( String? message)  unauthenticated,required TResult Function( String authToken,  SecureKey encryptionKey)  authenticated,}) {final _that = this;
switch (_that) {
case Unauthenticated():
return unauthenticated(_that.message);case Authenticated():
return authenticated(_that.authToken,_that.encryptionKey);}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function( String? message)?  unauthenticated,TResult? Function( String authToken,  SecureKey encryptionKey)?  authenticated,}) {final _that = this;
switch (_that) {
case Unauthenticated() when unauthenticated != null:
return unauthenticated(_that.message);case Authenticated() when authenticated != null:
return authenticated(_that.authToken,_that.encryptionKey);case _:
  return null;

}
}

}

/// @nodoc


class Unauthenticated extends AuthState {
  const Unauthenticated({this.message}): super._();
  

 final  String? message;

/// Create a copy of AuthState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$UnauthenticatedCopyWith<Unauthenticated> get copyWith => _$UnauthenticatedCopyWithImpl<Unauthenticated>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Unauthenticated&&(identical(other.message, message) || other.message == message));
}


@override
int get hashCode => Object.hash(runtimeType,message);

@override
String toString() {
  return 'AuthState.unauthenticated(message: $message)';
}


}

/// @nodoc
abstract mixin class $UnauthenticatedCopyWith<$Res> implements $AuthStateCopyWith<$Res> {
  factory $UnauthenticatedCopyWith(Unauthenticated value, $Res Function(Unauthenticated) _then) = _$UnauthenticatedCopyWithImpl;
@useResult
$Res call({
 String? message
});




}
/// @nodoc
class _$UnauthenticatedCopyWithImpl<$Res>
    implements $UnauthenticatedCopyWith<$Res> {
  _$UnauthenticatedCopyWithImpl(this._self, this._then);

  final Unauthenticated _self;
  final $Res Function(Unauthenticated) _then;

/// Create a copy of AuthState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? message = freezed,}) {
  return _then(Unauthenticated(
message: freezed == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}


/// @nodoc
mixin _$Authenticated {

 String get authToken; SecureKey get encryptionKey;
/// Create a copy of Authenticated
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AuthenticatedCopyWith<Authenticated> get copyWith => _$AuthenticatedCopyWithImpl<Authenticated>(this as Authenticated, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Authenticated&&(identical(other.authToken, authToken) || other.authToken == authToken)&&(identical(other.encryptionKey, encryptionKey) || other.encryptionKey == encryptionKey));
}


@override
int get hashCode => Object.hash(runtimeType,authToken,encryptionKey);

@override
String toString() {
  return 'Authenticated(authToken: $authToken, encryptionKey: $encryptionKey)';
}


}

/// @nodoc
abstract mixin class $AuthenticatedCopyWith<$Res> implements $AuthStateCopyWith<$Res> {
  factory $AuthenticatedCopyWith(Authenticated value, $Res Function(Authenticated) _then) = _$AuthenticatedCopyWithImpl;
@useResult
$Res call({
 String authToken, SecureKey encryptionKey
});




}
/// @nodoc
class _$AuthenticatedCopyWithImpl<$Res>
    implements $AuthenticatedCopyWith<$Res> {
  _$AuthenticatedCopyWithImpl(this._self, this._then);

  final Authenticated _self;
  final $Res Function(Authenticated) _then;

/// Create a copy of Authenticated
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? authToken = null,Object? encryptionKey = null,}) {
  return _then(_self.copyWith(
authToken: null == authToken ? _self.authToken : authToken // ignore: cast_nullable_to_non_nullable
as String,encryptionKey: null == encryptionKey ? _self.encryptionKey : encryptionKey // ignore: cast_nullable_to_non_nullable
as SecureKey,
  ));
}

}


/// Adds pattern-matching-related methods to [Authenticated].
extension AuthenticatedPatterns on Authenticated {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Authenticated value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Authenticated() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Authenticated value)  $default,){
final _that = this;
switch (_that) {
case _Authenticated():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Authenticated value)?  $default,){
final _that = this;
switch (_that) {
case _Authenticated() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String authToken,  SecureKey encryptionKey)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Authenticated() when $default != null:
return $default(_that.authToken,_that.encryptionKey);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String authToken,  SecureKey encryptionKey)  $default,) {final _that = this;
switch (_that) {
case _Authenticated():
return $default(_that.authToken,_that.encryptionKey);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String authToken,  SecureKey encryptionKey)?  $default,) {final _that = this;
switch (_that) {
case _Authenticated() when $default != null:
return $default(_that.authToken,_that.encryptionKey);case _:
  return null;

}
}

}

/// @nodoc


class _Authenticated extends Authenticated {
  const _Authenticated({required this.authToken, required this.encryptionKey}): super._();
  

@override final  String authToken;
@override final  SecureKey encryptionKey;

/// Create a copy of Authenticated
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AuthenticatedCopyWith<_Authenticated> get copyWith => __$AuthenticatedCopyWithImpl<_Authenticated>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Authenticated&&(identical(other.authToken, authToken) || other.authToken == authToken)&&(identical(other.encryptionKey, encryptionKey) || other.encryptionKey == encryptionKey));
}


@override
int get hashCode => Object.hash(runtimeType,authToken,encryptionKey);

@override
String toString() {
  return 'Authenticated(authToken: $authToken, encryptionKey: $encryptionKey)';
}


}

/// @nodoc
abstract mixin class _$AuthenticatedCopyWith<$Res> implements $AuthenticatedCopyWith<$Res> {
  factory _$AuthenticatedCopyWith(_Authenticated value, $Res Function(_Authenticated) _then) = __$AuthenticatedCopyWithImpl;
@override @useResult
$Res call({
 String authToken, SecureKey encryptionKey
});




}
/// @nodoc
class __$AuthenticatedCopyWithImpl<$Res>
    implements _$AuthenticatedCopyWith<$Res> {
  __$AuthenticatedCopyWithImpl(this._self, this._then);

  final _Authenticated _self;
  final $Res Function(_Authenticated) _then;

/// Create a copy of Authenticated
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? authToken = null,Object? encryptionKey = null,}) {
  return _then(_Authenticated(
authToken: null == authToken ? _self.authToken : authToken // ignore: cast_nullable_to_non_nullable
as String,encryptionKey: null == encryptionKey ? _self.encryptionKey : encryptionKey // ignore: cast_nullable_to_non_nullable
as SecureKey,
  ));
}


}

// dart format on
