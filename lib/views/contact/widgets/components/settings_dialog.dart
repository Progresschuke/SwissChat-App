import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class SettingsDialog extends StatelessWidget {
  const SettingsDialog({
    super.key,
    required this.size,
  });

  final Size size;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      elevation: 4,
      shadowColor: Colors.black,
      backgroundColor: Colors.white,
      alignment: Alignment.topLeft,
      insetPadding: EdgeInsets.only(
          top: 0.05 * size.height,
          left: 0.5 * size.width,
          right: 0.05 * size.width),
      child: InkWell(
        onTap: () {
          context.push('/profile');
          Navigator.pop(context);
        },
        child: Container(
          alignment: Alignment.centerLeft,
          padding: EdgeInsets.symmetric(
              horizontal: 0.05 * size.width, vertical: 0.01 * size.height),
          width: 10,
          height: 0.05 * size.height,
          child: const Text('Settings'),
        ),
      ),
    );
  }
}
