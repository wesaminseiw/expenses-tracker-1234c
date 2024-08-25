import 'dart:math';
import 'package:flutter/material.dart';

const primaryColor = Color(0xFF00B2E7);
const secondaryColor = Color(0xFFE064F7);
const tertiaryColor = Color(0xFFFF8D6C);
const outlineColor = Colors.grey;

LinearGradient defaultGradient = const LinearGradient(
  colors: [
    primaryColor,
    secondaryColor,
    tertiaryColor,
  ],
  transform: GradientRotation(pi / 4),
);

LinearGradient defaultGradientForChart = const LinearGradient(
  colors: [
    primaryColor,
    secondaryColor,
    tertiaryColor,
  ],
  transform: GradientRotation(pi / 40),
);
