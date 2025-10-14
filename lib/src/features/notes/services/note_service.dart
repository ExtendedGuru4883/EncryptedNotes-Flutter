import 'dart:convert';

import 'package:encrypted_notes/src/shared/clients/http/services/http_service.dart';
import 'package:encrypted_notes/src/shared/cryptography/services/crypto_service.dart';
import 'package:encrypted_notes/src/features/notes/models/note_dto.dart';
import 'package:encrypted_notes/src/features/notes/models/note_model.dart';
import 'package:encrypted_notes/src/features/notes/models/upsert_note_request.dart';
import 'package:encrypted_notes/src/shared/models/paginated_response.dart';
import 'package:sodium_libs/sodium_libs_sumo.dart';

class NoteService {
  final CryptoService _cryptoService;
  final HttpService _httpService;

  NoteService(this._cryptoService, this._httpService);

  Future<NoteModel> addNoteAsync(
    String title,
    String content,
    String authToken,
    SecureKey encryptionKey,
  ) async {
    final addNoteRequestData = await _createUpsertNoteRequestData(
      title,
      content,
      encryptionKey,
    );

    final noteDto = await _httpService.postJson<NoteDto>(
      path: '/notes',
      authToken: authToken,
      data: addNoteRequestData,
      fromJsonT: (j) => NoteDto.fromJson(j),
    );

    return await _decryptDtoToModel(noteDto, encryptionKey);
  }

  Future<NoteModel> updateNoteAsync(
    String id,
    String title,
    String content,
    String authToken,
    SecureKey encryptionKey,
  ) async {
    final updateNoteRequestData = await _createUpsertNoteRequestData(
      title,
      content,
      encryptionKey,
    );

    final noteDto = await _httpService.putJson(
      path: "/notes/$id",
      authToken: authToken,
      data: updateNoteRequestData,
      fromJsonT: (j) => NoteDto.fromJson(j),
    );

    return await _decryptDtoToModel(noteDto, encryptionKey);
  }

  Future<void> deleteNoteAsync(String id, String authToken) async {
    await _httpService.delete(path: '/notes/$id', authToken: authToken);
  }

  Future<PaginatedResponse<NoteModel>> getNotesPageAsync(
    DateTime cursor,
    int pageSize,
    String authToken,
    SecureKey encryptionKey,
  ) async {
    final paginatedResponse = await _httpService
        .getJson<PaginatedResponse<NoteDto>>(
          path: '/notes/byCursor',
          authToken: authToken,
          queryParameters: {
            'pageSize': pageSize,
            'dateTimeCursor': cursor,
          },
          fromJsonT: (j) =>
              PaginatedResponse.fromJson(j, (js) => NoteDto.fromJson(js)),
        );

    final noteModels = await Future.wait(
      paginatedResponse.items.map((dto) => _decryptDtoToModel(dto, encryptionKey)),
    );
    return PaginatedResponse(
      noteModels,
      paginatedResponse.pageSize,
      paginatedResponse.totalCount,
    );
  }

  Future<NoteModel> _decryptDtoToModel(NoteDto dto, SecureKey encryptionKey) async {
    final plainTextTitle = utf8.decode(
      await _cryptoService.decrypt(
        base64Decode(dto.encryptedTitleBase64),
        encryptionKey,
      ),
    );
    final plainTextContent = utf8.decode(
      await _cryptoService.decrypt(
        base64Decode(dto.encryptedContentBase64),
        encryptionKey,
      ),
    );

    return NoteModel(dto.id, plainTextTitle, plainTextContent, dto.timeStamp);
  }

  Future<Map<String, dynamic>> _createUpsertNoteRequestData(
    String title,
    String content,
    SecureKey encryptionKey,
  ) async {
    final encryptedTitleBytes = await _cryptoService.encrypt(
      utf8.encode(title),
      encryptionKey,
    );
    final encryptedContentBytes = await _cryptoService.encrypt(
      utf8.encode(content),
      encryptionKey,
    );

    final encryptedTitleBase64 = base64Encode(encryptedTitleBytes);
    final encryptedContentBase64 = base64Encode(encryptedContentBytes);

    return UpsertNoteRequest(
      encryptedTitleBase64,
      encryptedContentBase64,
    ).toJson();
  }
}
