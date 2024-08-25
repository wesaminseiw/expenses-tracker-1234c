import 'package:expenses_tracker/app/utils/extensions.dart';
import 'package:expenses_tracker/presentation/widgets/expense_builder.dart';
import 'package:expenses_tracker/presentation/widgets/sized_boxes.dart';
import 'package:flutter/material.dart';
import 'package:expense_repository/expense_repository.dart';

class ViewAllExpenses extends StatefulWidget {

  final List<Expense> expenses;
  const ViewAllExpenses(this.expenses, {super.key});

  @override
  State<ViewAllExpenses> createState() => _ViewAllExpensesState();
}

class _ViewAllExpensesState extends State<ViewAllExpenses> {

  int index = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.colorScheme.surface,
      body: widget.expenses.isNotEmpty
        ? SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              children: [
                height(16),
                Row(
                  children: [
                    IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: const Icon(Icons.arrow_back_ios_new_rounded),
                    ),
                    width(8),
                    Text(
                      'All Expenses (${widget.expenses.length})',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w500,
                        color: context.colorScheme.onSurface,
                      ),
                    ),
                    const Spacer(),
                    IconButton(
                      onPressed: () {},
                      icon: const Icon(Icons.search_rounded),
                    ),
                  ],
                ),
                height(36),
                Expanded(
                  child: expenseBuilder(expenses: widget.expenses),
                ),
              ],
            ),
          ),
        )
        : Center(
          child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'No Expenses yet!',
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey[600],
                          ),
                        ),
                        height(8),
                        Text(
                          'Click on + to create one.',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
        ),
    );
  }
}