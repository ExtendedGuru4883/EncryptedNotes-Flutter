class LoginRequest {
  final String username;

  final String nonceBase64;

  final String nonceSignatureBase64;

  LoginRequest(this.username, this.nonceBase64, this.nonceSignatureBase64);

  Map<String, dynamic> toJson() => {
    'username': username,
    'nonceBase64': nonceBase64,
    'nonceSignatureBase64': nonceSignatureBase64,
  };
}
