import 'package:expenses_tracker/app/utils/extensions.dart';
import 'package:expense_repository/expense_repository.dart';
import 'package:expenses_tracker/logic/bloc/get_expense_bloc/get_expense_bloc.dart';
import 'package:expenses_tracker/presentation/screens/edit_expense/edit_expense.dart';
import 'package:expenses_tracker/presentation/widgets/sized_boxes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

Widget expenseBuilder({
  required List<Expense> expenses,
}) =>
    ListView.builder(
      itemCount: expenses.length,
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) {
                    return ViewExpenseScreen(
                      expenses,
                      expenses[index],
                      expenses[index].category,
                    );
                  },
                ),
              );
            },
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    Stack(
                      alignment: Alignment.center,
                      children: [
                        Container(
                          width: 50,
                          height: 50,
                          decoration: BoxDecoration(
                            color: Color(expenses[index].category.color),
                            shape: BoxShape.circle,
                          ),
                        ),
                        Image.asset(
                          expenses[index].category.icon,
                          scale: 5,
                          color: Colors.white,
                        ),
                      ],
                    ),
                    width(12),
                    Expanded(
                      flex: 100000,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            expenses[index].title,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: context.colorScheme.onSurface,
                            ),
                          ),
                          Text(
                            expenses[index].category.name,
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: context.colorScheme.outline,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Spacer(),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          '\$ ${expenses[index].amount}',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Theme.of(context).colorScheme.onSurface,
                          ),
                        ),
                        Text(
                          DateFormat('dd/MM/yyyy')
                              .format(expenses[index].date),
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: context.colorScheme.outline,
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
