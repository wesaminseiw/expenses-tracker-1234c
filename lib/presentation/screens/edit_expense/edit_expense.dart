import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expense_repository/expense_repository.dart';
import 'package:expenses_tracker/app/utils/extensions.dart';
import 'package:expenses_tracker/logic/bloc/create_expense_bloc/create_expense_bloc.dart';
import 'package:expenses_tracker/logic/bloc/get_categories_bloc/get_categories_bloc.dart';
import 'package:expenses_tracker/logic/bloc/get_expense_bloc/get_expense_bloc.dart';
import 'package:expenses_tracker/presentation/screens/add_expense/category_creation.dart';
import 'package:expenses_tracker/presentation/screens/home/main_screen.dart';
import 'package:expenses_tracker/presentation/screens/home_page.dart';
import 'package:expenses_tracker/presentation/widgets/default_button.dart';
import 'package:expenses_tracker/presentation/widgets/loading.dart';
import 'package:expenses_tracker/presentation/widgets/show_date_picker.dart';
import 'package:expenses_tracker/presentation/widgets/delete_dialogs.dart';
import 'package:expenses_tracker/presentation/widgets/show_error_dialog.dart';
import 'package:expenses_tracker/presentation/widgets/sized_boxes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

class ViewExpenseScreen extends StatefulWidget {
  final List<Expense> expenses;
  Expense expense;
  final Category category;
  ViewExpenseScreen(this.expenses, this.expense, this.category, {super.key});

  @override
  State<ViewExpenseScreen> createState() => _ViewExpenseScreenState();
}

class _ViewExpenseScreenState extends State<ViewExpenseScreen> {
  TextEditingController newTitleController = TextEditingController();
  TextEditingController newAmountController = TextEditingController();
  TextEditingController newCategoryController = TextEditingController();
  TextEditingController newDateController = TextEditingController();
  TextEditingController newDetailsController = TextEditingController();
  bool isExtended = false;
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    newTitleController.text = widget.expense.title;
    newAmountController.text = widget.expense.amount.toString();
    newCategoryController.text = widget.expense.category.name;
    newDateController.text =
        DateFormat('dd/MM/yyyy').format(widget.expense.date);
    newDetailsController.text = widget.expense.details ?? '';

    return BlocBuilder<GetCategoriesBloc, GetCategoriesState>(
      builder: (context, state) {
        if (state is GetCategoriesSuccess) {
          Category categoryIsSelected = widget.expense.category;
          String iconOfCategorySelected = widget.expense.category.icon;
          int colorOfCategorySelected = widget.expense.category.color;
          return GestureDetector(
            onTap: () => FocusScope.of(context).unfocus(),
            child: Scaffold(
              backgroundColor: context.colorScheme.surface,
              appBar: AppBar(
                backgroundColor: context.colorScheme.surface,
                surfaceTintColor: context.colorScheme.surface,
                leading: IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: const Icon(Icons.arrow_back_ios_new_rounded),
                ),
                actions: [
                  IconButton(
                    onPressed: () async {
                      await myExpenseDeletetionDialog(
                        context,
                        expenseId: widget.expense.expenseId,
                      );
                    },
                    icon: const Icon(Icons.delete_rounded),
                  ),
                ],
              ),
              body: SafeArea(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        height(MediaQuery.of(context).size.height * 0.1),
                        const Text(
                          'Edit Expense',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        height(36),
                        TextField(
                          controller: newTitleController,
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: Colors.white,
                            prefixIcon: const Icon(
                              Icons.title_rounded,
                              color: Colors.grey,
                            ),
                            hintText: 'Title',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide.none,
                            ),
                          ),
                        ),
                        height(16),
                        TextField(
                          controller: newAmountController,
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: Colors.white,
                            prefixIcon: const Icon(
                              Icons.attach_money_rounded,
                              color: Colors.grey,
                            ),
                            hintText: 'Amount',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide.none,
                            ),
                          ),
                        ),
                        height(16),
                        BlocBuilder<GetCategoriesBloc, GetCategoriesState>(
                          builder: (context, state) {
                            newCategoryController.text = widget.expense.category.name;
                          return TextField(
                            controller: newCategoryController,
                            readOnly: true,
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: Color(colorOfCategorySelected),
                              prefixIcon: Image.asset(
                                iconOfCategorySelected,
                                scale: 5,
                              ),
                              suffixIcon: IconButton(
                                onPressed: () {
                                  getCategoryCreation(context);
                                },
                                icon: Icon(
                                  Icons.add_rounded,
                                  color:
                                      categoryIsSelected == Category.empty
                                          ? Colors.grey
                                          : Colors.black,
                                ),
                              ),
                              border: OutlineInputBorder(
                                borderRadius: isExtended == false
                                    ? BorderRadius.circular(12)
                                    : const BorderRadius.vertical(
                                        top: Radius.circular(12),
                                      ),
                                borderSide: BorderSide.none,
                              ),
                            ),
                            onTap: () {
                              setState(() {
                                isExtended = !isExtended;
                              });
                            },
                          );
                          }
                        ),
                        isExtended == false
                            ? Container()
                            : Container(
                                width: MediaQuery.of(context).size.width,
                                height: 200,
                                decoration: const BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.vertical(
                                    bottom: Radius.circular(12),
                                  ),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: state.categories.isEmpty
                                      ? Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              'No Categories yet!',
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
                                        )
                                      : ListView.builder(
                                          itemCount: state.categories.length,
                                          itemBuilder: (context, index) {
                                            return Card(
                                              child: ListTile(
                                                onTap: () {
                                                  setState(() {
                                                    categoryIsSelected =
                                                        state.categories[index];
                                                    widget.expense.category
                                                            .icon =
                                                        state.categories[index]
                                                            .icon;
                                                    widget.expense.category
                                                            .color =
                                                        state.categories[index]
                                                            .color;
                                                    newCategoryController.text =
                                                        widget.expense.category
                                                            .name;
                                                  });
                                                },
                                                onLongPress: () {
                                                  myCategoryDeletetionDialog(
                                                    context,
                                                    categoryId: state
                                                        .categories[index]
                                                        .categoryId,
                                                  );
                                                },
                                                leading: Image.asset(
                                                  state.categories[index].icon,
                                                  scale: 4,
                                                ),
                                                title: Text(
                                                  state.categories[index].name,
                                                ),
                                                tileColor: Color(
                                                  state.categories[index].color,
                                                ),
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(12),
                                                ),
                                              ),
                                            );
                                          },
                                        ),
                                ),
                              ),
                        height(16),
                        TextField(
                          controller: newDateController,
                          readOnly: true,
                          onTap: () async {
                            DateTime? newDate = await myDatePicker(context,
                                initialDate: widget.expense.date);
                            if (newDate != null) {
                              setState(() {
                                newDateController.text =
                                    DateFormat('dd/MM/yyyy').format(newDate);
                                // selectDate = newDate;
                                widget.expense.date = newDate;
                              });
                            }
                          },
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: Colors.white,
                            prefixIcon: const Icon(
                              Icons.access_time_rounded,
                              color: Colors.grey,
                            ),
                            hintText: 'Date',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide.none,
                            ),
                          ),
                        ),
                        height(16),
                        TextField(
                          controller: newDetailsController,
                          maxLines: null,
                          decoration: InputDecoration(
                            filled: true,
                            helperStyle: TextStyle(
                              color: Colors.grey[800],
                              fontWeight: FontWeight.w600,
                            ),
                            fillColor: Colors.white,
                            prefixIcon: const Icon(
                              Icons.info_outline_rounded,
                              color: Colors.grey,
                            ),
                            hintText: 'Details (optional)',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide.none,
                            ),
                          ),
                        ),
                        height(16),
                        isLoading == false
                            ? defaultButton(
                                width: double.infinity,
                                height: kToolbarHeight,
                                onPressed: () async {
                                  if (newTitleController.text.isNotEmpty) {
                                    setState(() {
                                      isLoading = true;
                                    });
                                    int amount = int.tryParse(
                                            newAmountController.text) ??
                                        0;

                                    // Update local instance of the expense
                                    widget.expense = Expense(
                                      amount: amount,
                                      category: categoryIsSelected,
                                      date: widget.expense.date,
                                      details: newDetailsController.text,
                                      expenseId: widget.expense.expenseId,
                                      title: newTitleController.text,
                                    );

                                    // Convert to Firestore document format
                                    Map<String, Object?> expenseData =
                                        widget.expense.toEntity().toDocument();

                                    try {
                                      // Update the Firestore document
                                      await FirebaseFirestore.instance
                                          .collection('expenses')
                                          .doc(widget.expense.expenseId)
                                          .set(expenseData,
                                              SetOptions(merge: true));
                                      setState(() {
                                        isLoading = false;
                                      });
                                      Navigator.pushAndRemoveUntil(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => HomePage(
                                            hasUpdated: true,
                                          ),
                                        ),
                                        (route) => false,
                                      );
                                    } catch (e) {
                                      print('Error updating expense: $e');
                                      showErrorDialog(context: context);
                                    }
                                  } else {
                                    showErrorDialog(context: context);
                                  }
                                },
                              )
                            : dotsLoading(),
                      ],
                    ),
                  ),
                ),
              ),
            ),
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
