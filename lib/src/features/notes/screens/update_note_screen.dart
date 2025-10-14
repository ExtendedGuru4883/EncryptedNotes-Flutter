import 'package:encrypted_notes/src/features/notes/providers/notes_notifier.dart';
import 'package:encrypted_notes/src/shared/exceptions/unauthorized_exception.dart';
import 'package:encrypted_notes/src/features/notes/models/note_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class UpdateNoteScreen extends ConsumerStatefulWidget {
  final NoteModel note;
  const UpdateNoteScreen({super.key, required this.note});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _UpdateNoteScreenState();
}

class _UpdateNoteScreenState extends ConsumerState<UpdateNoteScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleTextController = TextEditingController();
  final _contentTextController = TextEditingController();
  @override
  void initState() {
    super.initState();
    _titleTextController.text = widget.note.title;
    _contentTextController.text = widget.note.content;
  }

  @override
  Widget build(BuildContext context) {
    final notesStateAsync = ref.watch(notesNotifierProvider);

    return Scaffold(
      appBar: AppBar(
        scrolledUnderElevation: 0,
        backgroundColor: Colors.transparent,
        title: Text('Edit note'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsetsGeometry.directional(
          start: 15,
          end: 15,
          bottom: 15,
        ),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              ConstrainedBox(
                constraints: BoxConstraints(maxHeight: 120),
                child: TextFormField(
                  style: Theme.of(context).textTheme.headlineSmall,
                  controller: _titleTextController,
                  maxLines: null,
                  keyboardType: TextInputType.multiline,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'The title can\'t be empty';
                    }
                    if (value.length > 100) {
                      return 'The title can\'t exceed 100 characters';
                    }
                    return null;
                  },
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    label: Text('Title'),
                    floatingLabelBehavior: FloatingLabelBehavior.never,
                    alignLabelWithHint: true,
                  ),
                ),
              ),
              Divider(),
              Expanded(
                child: TextFormField(
                  style: Theme.of(context).textTheme.bodyLarge,
                  controller: _contentTextController,
                  keyboardType: TextInputType.multiline,
                  maxLines: null,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'The content can\'t be empty';
                    }
                    if (value.length > 1000) {
                      return 'The content can\'t exceed 1000 characters';
                    }
                    return null;
                  },
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    labelText: 'Your note\'s content',
                    floatingLabelBehavior: FloatingLabelBehavior.never,
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  ElevatedButton(
                    onPressed: notesStateAsync.isLoading ? null : _handleSubmit,
                    child: notesStateAsync.isLoading
                        ? const CircularProgressIndicator()
                        : const Text('Edit'),
                  ),
                  FilledButton(
                    onPressed:
                        notesStateAsync.value?.awaitingDeletionNoteId == null
                        ? () => _handleDelete(widget.note)
                        : null,
                    child:
                        notesStateAsync.value?.awaitingDeletionNoteId ==
                            widget.note.id
                        ? CircularProgressIndicator()
                        : Text('Delete'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _handleSubmit() async {
    if (!_formKey.currentState!.validate()) return;
    try {
      await ref
          .read(notesNotifierProvider.notifier)
          .updateNote(
            widget.note,
            _titleTextController.text,
            _contentTextController.text,
          );
      if (mounted) {
        context.pop();
      }
    } catch (ex) {
      if (mounted && ex is! UnauthorizedException) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(ex.toString())));
        return;
      }
    }
  }

  Future<void> _handleDelete(NoteModel note) async {
    try {
      await ref.read(notesNotifierProvider.notifier).deleteNote(note);
      if (mounted) {
        context.pop();
      }
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
    _titleTextController.dispose();
    _contentTextController.dispose();
    super.dispose();
  }
}
