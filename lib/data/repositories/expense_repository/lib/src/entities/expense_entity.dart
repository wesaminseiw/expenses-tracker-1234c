import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expense_repository/expense_repository.dart';


class ExpenseEntity {
  String expenseId;
  Category category;
  DateTime date;
  int amount;
  String title;
  String? details;

  ExpenseEntity({
    required this.expenseId,
    required this.category,
    required this.date,
    required this.amount,
    required this.title,
    required this.details,
  });

  // FROM Expense TO Map<String, Object?> "TO MAKE FIREBASE UNDERSTAND".
  Map<String, Object?> toDocument() {
    return {
      'expenseId': expenseId,
      'category': category.toEntity().toDocument(),
      'date': date,
      'amount': amount as int,
      'title': title,
      'details': details ?? '',
    };
  }

  // FROM Map<String, dynamic> TO Expense "TO MAKE THE APP UNDERSTAND".
  static ExpenseEntity formDocument(Map<String, dynamic> doc) {
    return ExpenseEntity(
      expenseId: doc['expenseId'],
      category: Category.formEntity(CategoryEntity.formDocument(doc['category'])),
      date: (doc['date'] as Timestamp).toDate(),
      amount: doc['amount'] as int,
      title: doc['title'],
      details: doc['details'] ?? '',
    );
  }
}