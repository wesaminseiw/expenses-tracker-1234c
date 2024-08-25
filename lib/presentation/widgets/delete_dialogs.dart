import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expenses_tracker/logic/bloc/get_categories_bloc/get_categories_bloc.dart';
import 'package:expenses_tracker/presentation/screens/home_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

Future myExpenseDeletetionDialog(
  BuildContext context,
  {
    required String expenseId,
  }
) => showDialog(
  context: context,
  builder: (context) {
    return AlertDialog(
      title: const Text(
        'Delete expense',
        style: TextStyle(
          fontWeight: FontWeight.w500,
        ),
      ),
      content: const Text('Are you sure that you want to delete this expense?'),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: const Text(
            'No',
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        TextButton(
          onPressed: () async {
            await FirebaseFirestore
              .instance
              .collection('expenses')
              .doc(expenseId)
              .delete();
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                builder: (context) => HomePage(
                  hasUpdated: true,
                ),
              ),
              (route) => false,
            );
          },
          child: const Text(
            'Yes',
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  },
);

Future myCategoryDeletetionDialog(
  BuildContext context,
  {
    required String categoryId,
  }
) => showDialog(
  context: context,
  builder: (context) {
    return AlertDialog(
      title: const Text(
        'Delete category',
        style: TextStyle(
          fontWeight: FontWeight.w500,
        ),
      ),
      content: const Text('Are you sure that you want to delete this category?'),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: const Text(
            'No',
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        TextButton(
          onPressed: () async {
            await FirebaseFirestore
              .instance
              .collection('categories')
              .doc(categoryId)
              .delete();
            context.read<GetCategoriesBloc>().add(GetCategories());
            Navigator.pop(context);
          },
          child: const Text(
            'Yes',
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  },
);