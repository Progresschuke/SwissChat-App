import 'package:flutter/material.dart';

import 'package:swiss_chat_app/views/auth/widgets/body.dart';

class AuthScreen extends StatelessWidget {
  const AuthScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primaryContainer,
      body: const AuthBody(),
    );
  }
}
