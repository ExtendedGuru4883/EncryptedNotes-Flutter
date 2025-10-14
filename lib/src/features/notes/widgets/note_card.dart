import 'package:encrypted_notes/src/features/notes/models/note_model.dart';
import 'package:encrypted_notes/src/features/notes/providers/notes_notifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class NoteCard extends ConsumerWidget {
  final NoteModel note;

  const NoteCard({super.key, required this.note});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notesStateAsync = ref.watch(notesNotifierProvider);

    return GestureDetector(
      onTap: () => notesStateAsync.value?.awaitingDeletionNoteId == note.id
          ? null
          : context.push('/edit', extra: note),
      child: Card(
        child: Padding(
          padding: const EdgeInsetsGeometry.directional(
            top: 5,
            bottom: 5,
            end: 10,
            start: 10,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: 10,
            children: [
              Text(
                '${note.timeStamp.day}-${note.timeStamp.month}-${note.timeStamp.year}',
              ),
              Text(
                note.title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              Text(
                note.content,
                maxLines: 10,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.bodyLarge,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
