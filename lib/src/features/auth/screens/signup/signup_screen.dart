import 'package:encrypted_notes/src/features/auth/widgets/signup/signup_form.dart';
import 'package:flutter/material.dart';

class SignupScreen extends StatelessWidget {
  const SignupScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.surface,
        title: Text('Signup'),
        centerTitle: true,
      ),
      body: Center(child: SignupForm()),
    );
  }
}
