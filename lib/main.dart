import 'package:expenses_tracker/app/app.dart';
import 'package:expense_repository/expense_repository.dart';
import 'package:expenses_tracker/firebase_options.dart';
import 'package:expenses_tracker/logic/bloc/create_category_bloc/create_category_bloc.dart';
import 'package:expenses_tracker/logic/bloc/create_expense_bloc/create_expense_bloc.dart';
import 'package:expenses_tracker/logic/bloc/get_categories_bloc/get_categories_bloc.dart';
import 'package:expenses_tracker/logic/bloc/get_expense_bloc/get_expense_bloc.dart';
import 'package:expenses_tracker/logic/bloc/simple_bloc_observer.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  Bloc.observer = const SimpleBlocObserver();
  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => CreateCategoryBloc(
            FirebaseExpenseRepo(),
          ),
        ),
        BlocProvider(
          create: (context) => GetCategoriesBloc(
            FirebaseExpenseRepo(),
          )..add(
              GetCategories(),
          ),
        ),
        BlocProvider(
          create: (context) => CreateExpenseBloc(
            FirebaseExpenseRepo(),
          ),
        ),
        BlocProvider(
          create: (context) => GetExpenseBloc(
            FirebaseExpenseRepo(),
          )..add(
              GetExpense(),
          ),
        ),
      ],
      child: const MyApp(),
    ),
  );
}
