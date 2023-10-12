//Using StreamBuilder to display various screens based on authentication state

import 'package:flutter/material.dart';
import 'package:swiss_chat_app/api/api.dart';
import 'package:swiss_chat_app/views/auth/auth.dart';
import 'package:swiss_chat_app/views/contact/contact.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: APIs.auth.authStateChanges(),
        builder: (ctx, snapshot) {
          if (!snapshot.hasData) {
            return const AuthScreen();
          }
          return const ContactScreen();
        });
  }
}
