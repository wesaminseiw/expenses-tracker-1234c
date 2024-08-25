import 'package:expense_repository/expense_repository.dart';

class Expense {
  String expenseId;
  Category category;
  DateTime date;
  int amount;
  String title;
  String? details;

  Expense({
    required this.expenseId,
    required this.category,
    required this.date,
    required this.amount,
    required this.title,
    required this.details,
  });

  static final empty = Expense(
    expenseId: '',
    category: Category.empty,
    date: DateTime.now(),
    amount: 0,
    title: '',
    details: '',
  );

  ExpenseEntity toEntity() {
    return ExpenseEntity(
      expenseId: expenseId,
      category: category,
      date: date,
      amount: amount as int,
      title: title,
      details: details ?? '',
    );
  }

  static Expense formEntity(ExpenseEntity entity) {
    return Expense(
      expenseId: entity.expenseId,
      category: entity.category,
      date: entity.date,
      amount: entity.amount as int,
      title: entity.title,
      details: entity.details ?? '',
    );
  }
}