import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

//created to select user's profile image

class ProfileImageStateNotifier extends StateNotifier<File?> {
  ProfileImageStateNotifier() : super(null);

  void selectImage() async {
    final imagePicker = ImagePicker();
    final pickedImage = await imagePicker.pickImage(
      source: ImageSource.gallery,
    );

    if (pickedImage == null) {
      return;
    }

    state = File(pickedImage.path);
  }

  void resetImage() {
    state = null;
  }
}

final profileImageStateProvider =
    StateNotifierProvider<ProfileImageStateNotifier, File?>((ref) {
  return ProfileImageStateNotifier();
});

//created to reset user's profile image

class ResetProfileImageNotifier extends StateNotifier<File?> {
  ResetProfileImageNotifier() : super(null);

  void selectImage() async {
    final imagePicker = ImagePicker();
    final pickedImage = await imagePicker.pickImage(
      source: ImageSource.gallery,
    );

    if (pickedImage == null) {
      return;
    }

    state = File(pickedImage.path);
  }

  void resetImage() {
    state = null;
  }
}

final resetProfileImageProvider =
    StateNotifierProvider<ResetProfileImageNotifier, File?>((ref) {
  return ResetProfileImageNotifier();
});
