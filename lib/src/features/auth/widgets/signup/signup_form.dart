import 'dart:convert';
import 'dart:typed_data';

import 'package:encrypted_notes/src/features/auth/providers/auth_notifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class SignupForm extends ConsumerStatefulWidget {
  const SignupForm({super.key});

  @override
  ConsumerState<SignupForm> createState() => _SignupFormState();
}

class _SignupFormState extends ConsumerState<SignupForm> {
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
          spacing: 40,
          mainAxisAlignment: MainAxisAlignment.center,
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
                      : const Text('Signup'),
                ),
                TextButton(
                  onPressed: () => context.go('/login'),
                  child: Text('Go to Login'),
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
          .signup(_usernameTextController.text, passwordBytes);
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
