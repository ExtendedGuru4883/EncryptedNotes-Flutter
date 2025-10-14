/* import 'package:encrypted_notes/src/features/notes/screens/notes_list_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class NotesScreen extends ConsumerWidget {
  const NotesScreen({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.surface,
        title: Text('Notes'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Row(
            children: [
              IconButton(
                icon: Icon(Icons.settings),
                onPressed: () => context.push('/settings'),
              ),
            ],
          ),
          NotesList(),
        ],
      ),
    );
  }
}
 */