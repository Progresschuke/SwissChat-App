import 'package:flutter/material.dart';

import 'package:swiss_chat_app/views/auth/widgets/components/auth_form.dart';

class AuthBody extends StatelessWidget {
  const AuthBody({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primaryContainer,
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(
              vertical: 10,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'SwissChat',
                  style: Theme.of(context).textTheme.titleLarge!.copyWith(
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Tangerine',
                      fontSize: 90,
                      color: const Color(0xFF100D20)),
                ),
                Container(
                  margin: const EdgeInsets.fromLTRB(20, 30, 20, 20),
                  padding: const EdgeInsets.all(20),
                  child: Image.asset(
                    'assets/images/speech-bubbles.png',
                    height: 200,
                    width: 200,
                  ),
                ),
                const AuthForm(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
