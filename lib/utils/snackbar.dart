import 'package:flutter/material.dart';

void showSnackBar(BuildContext context, String message) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    behavior: SnackBarBehavior.floating,
    shape: const RoundedRectangleBorder(),
    duration: const Duration(milliseconds: 1000),
    content: Text(
      message,
      textAlign: TextAlign.center,
    ),
    dismissDirection: DismissDirection.none,
  ));
}
