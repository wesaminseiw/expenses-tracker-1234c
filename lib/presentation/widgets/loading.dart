import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

Widget dotsLoading() => Center(
  child: SizedBox(
    width: 1000,
    height: 100,
    child: Lottie.asset('assets/animations/dots_loading.json'),
  ),
);