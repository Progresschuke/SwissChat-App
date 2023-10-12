import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:swiss_chat_app/api/api.dart';

import '../../../../controllers/image_picker_provider.dart';
import '../../../../helpers/dialogs.dart';

class ProfileImageReset extends ConsumerStatefulWidget {
  const ProfileImageReset({
    super.key,
  });

  @override
  ConsumerState<ProfileImageReset> createState() => _ProfileImageResetState();
}

class _ProfileImageResetState extends ConsumerState<ProfileImageReset> {
  // final userImage = sharedPreferences!.getString('imageUrl');

  @override
  void initState() {
    getSavedData();
    super.initState();
  }

  getSavedData() async {
    sharedPreferences = await SharedPreferences.getInstance();

    setState(() {});
  }

  bool isAuthenticating = false;

  void updateProfile() async {
    ref.read(resetProfileImageProvider.notifier).selectImage();
    final selectedImage = ref.watch(resetProfileImageProvider);

    if (selectedImage != null) {
      try {
        setState(() {
          isAuthenticating = true;
          APIs.updateProfilePicture(selectedImage);
        });
      } on FirebaseAuthException catch (error) {
        setState(() {
          isAuthenticating = false;
        });
        Dialogs.showSnackbar(context, error.message ?? 'Update failed');
      }
    }
  }

  @override
  Widget build(
    BuildContext context,
  ) {
    Size size = MediaQuery.of(context).size;
    final selectedImage = ref.watch(resetProfileImageProvider);

    return SizedBox(
      height: 0.4 * size.height,
      child: Stack(
        children: [
          Container(
            height: 0.4 * size.height,
            alignment: Alignment.center,
            child: CircleAvatar(
              radius: 0.25 * size.width,
              backgroundColor: Theme.of(context).colorScheme.secondary,
              foregroundImage:
                  selectedImage != null ? FileImage(selectedImage) : null,
              child: isAuthenticating
                  ? Dialogs.circularProgress(context)
                  : const Icon(CupertinoIcons.camera),
            ),
          ),
          Positioned(
              top: 0.22 * size.height,
              right: 0.2 * size.width,
              child: InkWell(
                onTap: updateProfile,
                child: CircleAvatar(
                  radius: 0.08 * size.width,
                  backgroundColor:
                      Theme.of(context).colorScheme.secondaryContainer,
                  child: const Icon(
                    CupertinoIcons.camera,
                    size: 30,
                  ),
                ),
              )),
        ],
      ),
    );
  }
}
