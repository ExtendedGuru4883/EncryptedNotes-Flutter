import 'dart:convert';
import 'dart:typed_data';

import 'package:encrypted_notes/src/features/auth/providers/auth_notifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class LoginForm extends ConsumerStatefulWidget {
  const LoginForm({super.key});

  @override
  ConsumerState<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends ConsumerState<LoginForm> {
  final _formKey = GlobalKey<FormState>();
  final _usernameTextController = TextEditingController();
  final _passwordTextController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authNotifierProvider);

    return Form(
      key: _formKey,
      child: Padding(
        padding: const EdgeInsetsGeometry.directional(start: 20, end: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          spacing: 40,
          children: [
            TextFormField(
              controller: _usernameTextController,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'The username can\'t be empty';
                }
                return null;
              },
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Username',
              ),
            ),
            TextFormField(
              controller: _passwordTextController,
              obscureText: true,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'The password can\'t be empty';
                }
                return null;
              },
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Password',
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                ElevatedButton(
                  onPressed: authState.isLoading ? null : () => _handleSubmit(),
                  child: authState.isLoading
                      ? const CircularProgressIndicator()
                      : const Text('Login'),
                ),
                TextButton(
                  onPressed: () => context.go('/signup'),
                  child: Text('Go to Signup'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _handleSubmit() async {
    if (!_formKey.currentState!.validate()) return;

    final passwordBytes = Int8List.fromList(
      utf8.encode(_passwordTextController.text),
    );
    _passwordTextController.clear();

    try {
      await ref
          .read(authNotifierProvider.notifier)
          .login(_usernameTextController.text, passwordBytes);
    } catch (ex) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(ex.toString())));
      }
    }
  }

  @override
  void dispose() {
    _usernameTextController.dispose();
    _passwordTextController.dispose();
    super.dispose();
  }
}
