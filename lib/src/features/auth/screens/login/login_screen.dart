import 'package:encrypted_notes/src/features/auth/widgets/login/login_form.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.surface,
        title: Text('Login'),
        centerTitle: true,
      ),
      body: Center(child: LoginForm()),
    );
  }
}
