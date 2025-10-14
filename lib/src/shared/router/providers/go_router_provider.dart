import 'package:encrypted_notes/src/features/auth/models/auth_state.dart';
import 'package:encrypted_notes/src/features/auth/providers/auth_notifier.dart';
import 'package:encrypted_notes/src/features/auth/screens/login/login_screen.dart';
import 'package:encrypted_notes/src/features/auth/screens/signup/signup_screen.dart';
import 'package:encrypted_notes/src/features/notes/models/note_model.dart';
import 'package:encrypted_notes/src/features/notes/screens/add_note_screen.dart';
import 'package:encrypted_notes/src/features/notes/screens/notes_list_screen.dart';
import 'package:encrypted_notes/src/features/notes/screens/update_note_screen.dart';
import 'package:encrypted_notes/src/features/settings/screens/settings_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'go_router_provider.g.dart';

@Riverpod(keepAlive: true)
GoRouter goRouter(Ref ref) {
  final authStateNotifier = ValueNotifier(false);

  ref.listen(authNotifierProvider, (previous, next) {
    next.whenOrNull(
      data: (authState) {
        authStateNotifier.value = authState is Authenticated;
      },
    );
  });

  return GoRouter(
    refreshListenable: authStateNotifier,
    routes: [
      GoRoute(path: '/', builder: (_, _) => const NotesListScreen()),
      GoRoute(path: '/add', builder: (_, _) => const AddNoteScreen()),
      GoRoute(
        path: '/edit',
        builder: (_, state) {
          final note = state.extra as NoteModel;
          return UpdateNoteScreen(note: note);
        },
      ),
      GoRoute(path: '/login', builder: (_, _) => const LoginScreen()),
      GoRoute(path: '/signup', builder: (_, _) => const SignupScreen()),
      GoRoute(path: '/settings', builder: (_, _) => const SettingsScreen()),
    ],
    redirect: (context, state) {
      final isAuthenticated = authStateNotifier.value;
      final path = state.matchedLocation;
      if (!isAuthenticated && path != '/login' && path != '/signup') {
        return '/login';
      } else if (isAuthenticated && (path == '/login' || path == '/signup')) {
        return '/';
      }
      return null;
    },
  );
}
