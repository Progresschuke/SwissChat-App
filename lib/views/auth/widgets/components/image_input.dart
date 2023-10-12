import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../controllers/image_picker_provider.dart';

class ImageInput extends ConsumerWidget {
  const ImageInput({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    Size size = MediaQuery.of(context).size;
    final selectedImage = ref.watch(profileImageStateProvider);

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        CircleAvatar(
          radius: 0.15 * size.width,
          foregroundImage:
              selectedImage != null ? FileImage(selectedImage) : null,
        ),
        TextButton.icon(
            icon: const Icon(Icons.camera),
            onPressed: () {
              ref.read(profileImageStateProvider.notifier).selectImage();
            },
            label: const Text('select image'))
      ],
    );
  }
}
