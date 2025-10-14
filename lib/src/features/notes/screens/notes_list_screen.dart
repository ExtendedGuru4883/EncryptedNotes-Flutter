import 'package:encrypted_notes/src/features/notes/providers/notes_notifier.dart';
import 'package:encrypted_notes/src/features/notes/widgets/note_card.dart';
import 'package:encrypted_notes/src/shared/exceptions/unauthorized_exception.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class NotesListScreen extends ConsumerStatefulWidget {
  const NotesListScreen({super.key});

  @override
  ConsumerState<NotesListScreen> createState() => _NotesListScreenState();
}

class _NotesListScreenState extends ConsumerState<NotesListScreen> {
  final _pageSize = 5;
  final _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    final notesStateAsync = ref.watch(notesNotifierProvider);
    final currentList = notesStateAsync.value?.notesList;

    _scrollController.addListener(() async {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        _handleFetch();
      }
    });

    return Scaffold(
      appBar: AppBar(
        scrolledUnderElevation: 0,
        backgroundColor: Colors.transparent,
        title: Text('Notes'),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.settings),
          onPressed: () => context.push('/settings'),
          color: Theme.of(context).colorScheme.primary,
        ),
        actions: [
          IconButton(
            onPressed: () => context.push('/add'),
            icon: Icon(Icons.add_box),
            color: Theme.of(context).colorScheme.primary,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsetsGeometry.directional(top: 20),
        child: Center(
          child: currentList == null
              ? notesStateAsync.when(
                  data: (_) => Text('Unexpected error'),
                  error: (ex, _) => Text(ex.toString()),
                  loading: () => CircularProgressIndicator(),
                )
              : currentList.isEmpty
              ? Text('You don\'t have any notes yet')
              : ListView.separated(
                  separatorBuilder: (_, _) => SizedBox(height: 12),
                  controller: _scrollController,
                  itemBuilder: (context, index) {
                    if (notesStateAsync.isLoading &&
                        index == currentList.length) {
                      return Center(child: CircularProgressIndicator());
                    }
                    final note = currentList[index];
                    return NoteCard(note: note);
                  },
                  itemCount: notesStateAsync.isLoading
                      ? notesStateAsync.value!.notesList!.length + 1
                      : notesStateAsync.value!.notesList!.length,
                ),
        ),
      ),
    );
  }

  Future<void> _handleFetch() async {
    try {
      await ref.read(notesNotifierProvider.notifier).getNotes(_pageSize);
    } catch (ex) {
      if (mounted && ex is! UnauthorizedException) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(ex.toString())));
        return;
      }
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }
}
