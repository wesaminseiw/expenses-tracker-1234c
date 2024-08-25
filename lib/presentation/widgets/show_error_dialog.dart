import 'package:flutter/material.dart';

Future<void> showErrorDialog({
  required BuildContext context,
  String? title,
}) => showDialog(
  context: context,
  builder: (context) {
    return AlertDialog(
      title: Text(title ?? 'Some fields are empty!'),
      titleTextStyle: const TextStyle(
        fontSize: 20,
        color: Colors.black,
        fontFamily: 'Montserrat',
        fontWeight: FontWeight.w500,
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: const Text('OK'),
        ),
      ],
    );
  },
);