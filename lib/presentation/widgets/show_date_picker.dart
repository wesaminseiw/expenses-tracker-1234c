import 'package:flutter/material.dart';

Future<DateTime?> myDatePicker(
  BuildContext context,
  {
    required DateTime initialDate,
  }
) => showDatePicker(
  context: context,
  firstDate: DateTime(2020),
  lastDate: DateTime.now(),
  initialDate: initialDate,
);