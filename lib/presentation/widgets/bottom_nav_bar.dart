import 'package:expenses_tracker/app/utils/extensions.dart';
import 'package:flutter/material.dart';

Widget bottomNavBar({
  required BuildContext context,
  required int index,
}) => StatefulBuilder(
  builder: (context, setState) => ClipRRect(
    borderRadius: const BorderRadius.only(
      topLeft: Radius.circular(30),
      topRight: Radius.circular(30),
    ),
    child: BottomNavigationBar(
      showSelectedLabels: false,
      showUnselectedLabels: false,
      backgroundColor: Colors.white,
      selectedItemColor: context.colorScheme.primary,
      currentIndex: index == 0 ? 0 : 1,
      elevation: 3,
      onTap: (value) {
        setState(() {
          index = value;
        });
      },
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.home_rounded),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.insert_chart_rounded),
          label: 'Stats',
        ),
      ],
    ),
  ),
);