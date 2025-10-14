class UpsertNoteRequest {
  final String encryptedTitleBase64;
  final String encryptedContentBase64;

  UpsertNoteRequest(this.encryptedTitleBase64, this.encryptedContentBase64);

  Map<String, dynamic> toJson() => {
    'encryptedTitleBase64': encryptedTitleBase64,
    'encryptedContentBase64': encryptedContentBase64
  };
}
