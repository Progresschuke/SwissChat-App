import 'package:flutter/material.dart';
import 'package:swiss_chat_app/views/profile/widgets/components/image_reset.dart';
import 'package:swiss_chat_app/views/profile/widgets/components/profile_form.dart';

class ProfileBody extends StatelessWidget {
  const ProfileBody({super.key});

  @override
  Widget build(BuildContext context) {
    return const SingleChildScrollView(
      child: Column(
        children: [
          ProfileImageReset(),
          ProfileForm(),
        ],
      ),
    );
  }
}
