import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

//created to select user's image on chatscreen

class ChatCameraImageNotifier extends StateNotifier<File?> {
  ChatCameraImageNotifier() : super(null);

  void selectImage() async {
    final imagePicker = ImagePicker();
    final pickedImage = await imagePicker.pickImage(
        source: ImageSource.camera, imageQuality: 10);

    if (pickedImage == null) {
      return;
    }

    state = File(pickedImage.path);
  }

  void resetImage() {
    state = null;
  }
}

final chatCameraImageProvider =
    StateNotifierProvider<ChatCameraImageNotifier, File?>((ref) {
  return ChatCameraImageNotifier();
});

//created to select user's gallery image on chatscreen

class ChatGalleryImageNotifier extends StateNotifier<File?> {
  ChatGalleryImageNotifier() : super(null);

  void selectImage() async {
    final imagePicker = ImagePicker();
    final pickedImage = await imagePicker.pickImage(
        source: ImageSource.gallery, imageQuality: 10);

    if (pickedImage == null) {
      return;
    }

    state = File(pickedImage.path);
  }

  void resetImage() {
    state = null;
  }
}

final chatGalleryImageProvider =
    StateNotifierProvider<ChatGalleryImageNotifier, File?>((ref) {
  return ChatGalleryImageNotifier();
});

//created to control uploading state of chat images

class UploadingImageNotifier extends StateNotifier<bool> {
  UploadingImageNotifier() : super(false);

  void isUploadingTrue() {
    state = true;
  }

  void isUploadingFalse() {
    state = false;
  }

  void onUpload() {
    state = !state;
  }
}

final uploadingImageProvider =
    StateNotifierProvider<UploadingImageNotifier, bool>((ref) {
  return UploadingImageNotifier();
});
