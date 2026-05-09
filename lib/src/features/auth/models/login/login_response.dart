class LoginResponse {
  final String token;
  final String encryptionSaltBase64;
  final String encryptedEncryptionKeyBase64;

  LoginResponse(
    this.token,
    this.encryptionSaltBase64,
    this.encryptedEncryptionKeyBase64,
  );

  Map<String, dynamic> toJson() => {
    'token': token,
    'encryptionSaltBase64': encryptionSaltBase64,
    'encryptedEncryptionKeyBase64': encryptedEncryptionKeyBase64,
  };

  LoginResponse.fromJson(Map<String, dynamic> json)
    : token = json['token'] as String,
      encryptionSaltBase64 = json['encryptionSaltBase64'] as String,
      encryptedEncryptionKeyBase64 =
          json['encryptedEncryptionKeyBase64'] as String;
}
