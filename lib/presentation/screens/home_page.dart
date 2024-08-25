import 'package:expenses_tracker/app/utils/extensions.dart';
import 'package:expense_repository/expense_repository.dart';
import 'package:expenses_tracker/logic/bloc/create_category_bloc/create_category_bloc.dart';
import 'package:expenses_tracker/logic/bloc/create_expense_bloc/create_expense_bloc.dart';
import 'package:expenses_tracker/logic/bloc/get_categories_bloc/get_categories_bloc.dart';
import 'package:expenses_tracker/logic/bloc/get_expense_bloc/get_expense_bloc.dart';
import 'package:expenses_tracker/presentation/screens/add_expense/add_expense.dart';
import 'package:expenses_tracker/presentation/screens/home/main_screen.dart';
import 'package:expenses_tracker/presentation/screens/stats_screen/stats_screen.dart';
import 'package:expenses_tracker/presentation/styles/colors.dart';
import 'package:expenses_tracker/presentation/widgets/loading.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomePage extends StatefulWidget {
  bool hasUpdated;
  HomePage({required this.hasUpdated, super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int index = 0;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GetExpenseBloc, GetExpenseState>(
      builder: (context, state) {
        if (widget.hasUpdated) {
          context.read<GetExpenseBloc>().add(GetExpense());
          widget.hasUpdated = false;
        }
        if (state is GetExpenseSuccess) {
          return Scaffold(
            bottomNavigationBar: ClipRRect(
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
            floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
            floatingActionButton: Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: defaultGradient,
              ),
              child: FloatingActionButton(
                onPressed: () async {
                  var newExpense = await Navigator.push(
                    context,
                    MaterialPageRoute<Expense>(
                      builder: (context) => AddExpenseScreen(),
                    ),
                  );
                  if (newExpense != null) {
                    setState(() {
                      state.expenses.add(newExpense);
                      widget.hasUpdated = true; // Mark as updated
                    });
                  }
                },
                backgroundColor: Colors.transparent,
                elevation: 0,
                focusElevation: 0,
                hoverElevation: 0,
                disabledElevation: 0,
                highlightElevation: 0,
                shape: const CircleBorder(),
                child: const Icon(Icons.add_rounded),
              ),
            ),
            body: index == 0 ? MainScreen(state.expenses, widget.hasUpdated) : const StatsScreen(),
          );
        } else {
          return Scaffold(
            body: dotsLoading(),
          );
        }
      },
    );
  }
}
