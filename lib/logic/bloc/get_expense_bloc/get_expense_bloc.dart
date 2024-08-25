import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:expense_repository/expense_repository.dart';

part 'get_expense_event.dart';
part 'get_expense_state.dart';

class GetExpenseBloc extends Bloc<GetExpenseEvent, GetExpenseState> {

  ExpenseRepository expenseRepository;

  GetExpenseBloc(this.expenseRepository) : super(GetExpenseInitial()) {
    on<GetExpense>(
      (event, emit) async {
        emit(GetExpenseLoading());
        try {
          List<Expense> expenses = await expenseRepository.getExpenses();
          emit(GetExpenseSuccess(expenses));
        } catch (e) {
          emit(GetExpenseFailure());
        }
      },
    );
  }
}
