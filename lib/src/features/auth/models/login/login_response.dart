class LoginResponse {
  final String token;
  final String encryptionSaltBase64;

  LoginResponse(this.token, this.encryptionSaltBase64);

  Map<String, dynamic> toJson() => {
    'token': token,
    'encryptionSaltBase64': encryptionSaltBase64,
  };

  LoginResponse.fromJson(Map<String, dynamic> json)
    : token = json['token'] as String,
      encryptionSaltBase64 = json['encryptionSaltBase64'] as String;
}
