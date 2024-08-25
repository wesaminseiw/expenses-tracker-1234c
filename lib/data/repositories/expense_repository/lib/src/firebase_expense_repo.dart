import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expense_repository/expense_repository.dart';

class FirebaseExpenseRepo implements ExpenseRepository {
  final categoryCollection = FirebaseFirestore.instance.collection(
    'categories',
  );
  final expenseCollection = FirebaseFirestore.instance.collection(
    'expenses',
  );

  @override
  Future<void> createCategory(Category category) async {
    try {
      await categoryCollection
          .doc(category.categoryId)
          .set(category.toEntity().toDocument());
    } catch (e) {
      print(e.toString());
      rethrow;
    }
  }

  @override
  Future<List<Category>> getCategory() async {
    try {
      return await categoryCollection.get().then(
            (value) => value.docs.map((e) {
              return Category.formEntity(CategoryEntity.formDocument(e.data()));
            }).toList(),
          );
    } catch (e) {
      print(e.toString());
      rethrow;
    }
  }
  
  @override
  Future<void> createExpense(Expense expense) async {
    try {
      await expenseCollection
          .doc(expense.expenseId)
          .set(expense.toEntity().toDocument());
    } catch (e) {
      print(e.toString());
      rethrow;
    }
  }

  @override
  Future<List<Expense>> getExpenses() async {
    try {
      return await expenseCollection.get().then(
            (value) => value.docs.map((e) {
              return Expense.formEntity(ExpenseEntity.formDocument(e.data()));
            }).toList(),
          );
    } catch (e) {
      print(e.toString());
      rethrow;
    }
  }
}
