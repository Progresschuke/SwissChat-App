import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:swiss_chat_app/views/profile/widgets/body.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        elevation: 3,
        backgroundColor: Theme.of(context).colorScheme.secondaryContainer,
        automaticallyImplyLeading: true,
        leading: IconButton(
          icon: const Icon(CupertinoIcons.back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        centerTitle: true,
        title: const Text('Profile'),
      ),
      body: const ProfileBody(),
    );
  }
}
