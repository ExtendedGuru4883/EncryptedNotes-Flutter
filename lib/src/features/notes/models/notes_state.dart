import 'package:encrypted_notes/src/features/notes/models/note_model.dart';
import 'package:flutter/widgets.dart';

@immutable
class NotesState {
  final List<NoteModel>? notesList;
  final String? message;
  final String? awaitingDeletionNoteId;

  const NotesState({this.notesList, this.message, this.awaitingDeletionNoteId});

  NotesState copyWith({
    List<NoteModel>? notesList,
    String? message,
    ValueGetter<String?>? awaitingDeletionNoteId,
  }) => NotesState(
    notesList: notesList ?? this.notesList,
    message: message ?? this.message,
    awaitingDeletionNoteId: awaitingDeletionNoteId != null
        ? awaitingDeletionNoteId()
        : this.awaitingDeletionNoteId,
  );
}
