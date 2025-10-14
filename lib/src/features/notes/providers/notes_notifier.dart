import 'package:encrypted_notes/src/features/auth/models/auth_state.dart';
import 'package:encrypted_notes/src/features/auth/providers/auth_notifier.dart';
import 'package:encrypted_notes/src/features/notes/models/note_model.dart';
import 'package:encrypted_notes/src/features/notes/models/notes_state.dart';
import 'package:encrypted_notes/src/features/notes/providers/note_service_provider.dart';
import 'package:encrypted_notes/src/shared/exceptions/unauthorized_exception.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part "notes_notifier.g.dart";

@Riverpod(keepAlive: false)
class NotesNotifier extends _$NotesNotifier {
  @override
  Future<NotesState> build() async {
    final initialNotes = await _getInitialNotes();
    return NotesState(notesList: initialNotes);
  }

  Future<void> getNotes(int pageSize) async {
    if (state.isLoading) return;
    state = AsyncValue.loading();
    final noteService = await ref.read(noteServiceProvider.future);
    if (!ref.mounted) return;

    try {
      final credentials = _getCredentialsOrThrow();

      final previousState = state.value;
      final notesList = previousState?.notesList;

      final cursor = (notesList != null && notesList.isNotEmpty)
          ? notesList.last.timeStamp
          : DateTime.utc(9999, 12, 31, 23, 59, 59, 999);

      final paginatedNotesResponse = await noteService.getNotesPageAsync(
        cursor,
        pageSize,
        credentials.authToken,
        credentials.encryptionKey,
      );
      if (!ref.mounted) return;

      final notesPage = paginatedNotesResponse.items;

      if (previousState != null && notesList != null) {
        state = AsyncValue.data(
          previousState.copyWith(notesList: [...notesList, ...notesPage]),
        );
      }
    } on UnauthorizedException {
      if (!ref.mounted) return;
      ref.read(authNotifierProvider.notifier).logout();
      rethrow;
    } catch (ex) {
      if (!ref.mounted) return;
      state = AsyncValue.error(ex, StackTrace.current);
      rethrow;
    }
  }

  Future<void> addNote(String title, String content) async {
    state = AsyncValue.loading();
    final noteService = await ref.read(noteServiceProvider.future);
    if (!ref.mounted) return;

    try {
      final credentials = _getCredentialsOrThrow();

      final newNote = await noteService.addNoteAsync(
        title,
        content,
        credentials.authToken,
        credentials.encryptionKey,
      );
      if (!ref.mounted) return;

      final previousState = state.value;
      final notesList = previousState?.notesList;
      if (previousState != null && notesList != null) {
        state = AsyncValue.data(
          previousState.copyWith(notesList: [newNote, ...notesList]),
        );
      }
    } on UnauthorizedException catch (ex) {
      if (!ref.mounted) return;
      ref.read(authNotifierProvider.notifier).logout();
      state = AsyncValue.error(ex, StackTrace.current);
      rethrow;
    } catch (ex) {
      if (!ref.mounted) return;
      state = AsyncValue.error(ex, StackTrace.current);
      rethrow;
    }
  }

  Future<void> updateNote(
    NoteModel oldNote,
    String newTitle,
    String newContent,
  ) async {
    state = AsyncValue.loading();
    final noteService = await ref.read(noteServiceProvider.future);
    if (!ref.mounted) return;

    try {
      final credentials = _getCredentialsOrThrow();

      final updatedNote = await noteService.updateNoteAsync(
        oldNote.id,
        newTitle,
        newContent,
        credentials.authToken,
        credentials.encryptionKey,
      );
      if (!ref.mounted) return;

      final previousState = state.value;
      final notesList = previousState?.notesList;
      if (previousState != null && notesList != null) {
        state = AsyncValue.data(
          previousState.copyWith(
            notesList: [updatedNote, ...(notesList.where((n) => n != oldNote))],
          ),
        );
      }
    } on UnauthorizedException catch (ex) {
      if (!ref.mounted) return;
      ref.read(authNotifierProvider.notifier).logout();
      state = AsyncValue.error(ex, StackTrace.current);
      rethrow;
    } catch (ex) {
      if (!ref.mounted) return;
      state = AsyncValue.error(ex, StackTrace.current);
      rethrow;
    }
  }

  Future<void> deleteNote(NoteModel note) async {
    final previousState = state.value;
    if (previousState == null || previousState.awaitingDeletionNoteId != null) {
      return;
    }
    state = AsyncValue.data(
      previousState.copyWith(awaitingDeletionNoteId: () => note.id),
    );
    final noteService = await ref.read(noteServiceProvider.future);
    if (!ref.mounted) return;

    try {
      final credentials = _getCredentialsOrThrow();
      await noteService.deleteNoteAsync(note.id, credentials.authToken);
      if (!ref.mounted) return;

      final previousState = state.value;
      final notesList = previousState?.notesList;
      if (previousState != null && notesList != null) {
        state = AsyncValue.data(
          previousState.copyWith(
            notesList: [...(notesList.where((n) => n != note))],
            awaitingDeletionNoteId: () => null,
          ),
        );
      }
    } on UnauthorizedException {
      if (!ref.mounted) return;
      ref.read(authNotifierProvider.notifier).logout();
      rethrow;
    } catch (ex) {
      if (!ref.mounted) return;
      final previousState = state.value;
      if (previousState == null) return;
      state = AsyncValue.data(
        previousState.copyWith(awaitingDeletionNoteId: () => null),
      );
      state = AsyncValue.error(ex, StackTrace.current);
      rethrow;
    }
  }

  Authenticated _getCredentialsOrThrow() {
    final authState = ref.read(authNotifierProvider).unwrapPrevious().value;
    switch (authState) {
      case Authenticated():
        return authState;
      default:
        throw UnauthorizedException('Unauthenticated');
    }
  }

  Future<List<NoteModel>> _getInitialNotes() async {
    final noteService = await ref.read(noteServiceProvider.future);
    if (!ref.mounted) return [];

    try {
      final credentials = _getCredentialsOrThrow();

      final cursor = DateTime.utc(9999, 12, 31, 23, 59, 59, 999);

      final paginatedNotesResponse = await noteService.getNotesPageAsync(
        cursor,
        10,
        credentials.authToken,
        credentials.encryptionKey,
      );
      if (!ref.mounted) return [];

      return paginatedNotesResponse.items;
    } on UnauthorizedException {
      if (!ref.mounted) return [];
      ref.read(authNotifierProvider.notifier).logout();
      rethrow;
    } catch (ex) {
      if (!ref.mounted) return [];
      rethrow;
    }
  }
}
