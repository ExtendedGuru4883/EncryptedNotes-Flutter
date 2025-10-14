class SignupRequest {
  final String username;

  final String signatureSaltBase64;

  final String encryptionSaltBase64;

  final String publicKeyBase64;

  SignupRequest(
    this.username,
    this.signatureSaltBase64,
    this.encryptionSaltBase64,
    this.publicKeyBase64,
  );

  Map<String, dynamic> toJson() => {
    'username': username,
    'signatureSaltBase64': signatureSaltBase64,
    'encryptionSaltBase64': encryptionSaltBase64,
    'publicKeyBase64': publicKeyBase64,
  };
}
