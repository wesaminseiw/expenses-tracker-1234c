import 'package:expense_repository/expense_repository.dart';
import 'package:expenses_tracker/logic/bloc/get_expense_bloc/get_expense_bloc.dart';
import 'package:expenses_tracker/presentation/screens/home_page.dart';
import 'package:expenses_tracker/presentation/styles/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Expense Tracker',
      theme: ThemeData(
        colorScheme: ColorScheme.light(
          surface: Colors.grey.shade100,
          onSurface: Colors.black,
          primary: primaryColor,
          secondary: secondaryColor,
          tertiary: tertiaryColor,
          outline: outlineColor,
        ),
        fontFamily: 'Montserrat',
      ),
      home: BlocProvider(
        create: (context) => GetExpenseBloc(
          FirebaseExpenseRepo(),
        )
        ..add(GetExpense()),
        child: HomePage(hasUpdated: false),
      ),
    );
  }
}
