import 'package:flutter/material.dart';

class Dialogs {
  static void showSnackbar(BuildContext context, String msg) {
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(msg),
        backgroundColor: Colors.blue.withOpacity(.8),
        behavior: SnackBarBehavior.floating));
  }

  static void showProgressBar(BuildContext context) {
    showDialog(
        context: context,
        builder: (_) => const Center(child: CircularProgressIndicator()));
  }

  static circularProgress(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    Container(
      alignment: Alignment.center,
      padding: EdgeInsets.only(top: .0 * size.height),
      child: CircularProgressIndicator(
        valueColor: AlwaysStoppedAnimation(
          Theme.of(context).colorScheme.primary,
        ),
      ),
    );
  }
}
