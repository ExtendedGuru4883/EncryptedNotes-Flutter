class NoteDto {
  final String id;
  final String encryptedTitleBase64;
  final String encryptedContentBase64;
  final DateTime timeStamp;

  NoteDto(
    this.encryptedContentBase64,
    this.encryptedTitleBase64,
    this.id,
    this.timeStamp,
  );

  NoteDto.fromJson(Map<String, dynamic> json)
    : id = json['id'] as String,
      encryptedTitleBase64 = json['encryptedTitleBase64'] as String,
      encryptedContentBase64 = json['encryptedContentBase64'] as String,
      timeStamp = DateTime.parse(json['timeStamp'] as String);
}