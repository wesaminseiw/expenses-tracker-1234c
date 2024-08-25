import 'package:flutter/material.dart';

Widget defaultButton({
  required double width,
  required double height,
  required Function onPressed,
  Color? buttonColor,
  String? label,
  double? labelSize,
  Color? labelColor,
}) =>
    SizedBox(
      width: width,
      height: height,
      child: TextButton(
        onPressed: () async {
          await onPressed();
        },
        style: TextButton.styleFrom(
          backgroundColor: buttonColor ?? Colors.black,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: Text(
          label ?? 'Save',
          style: TextStyle(
            color: labelColor ?? Colors.white,
            fontSize: labelSize ?? 18,
          ),
        ),
      ),
    );
