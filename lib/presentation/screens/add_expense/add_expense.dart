import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expenses_tracker/app/utils/extensions.dart';
import 'package:expense_repository/expense_repository.dart';
import 'package:expenses_tracker/logic/bloc/create_expense_bloc/create_expense_bloc.dart';
import 'package:expenses_tracker/logic/bloc/get_categories_bloc/get_categories_bloc.dart';
import 'package:expenses_tracker/presentation/screens/add_expense/category_creation.dart';
import 'package:expenses_tracker/presentation/screens/home/main_screen.dart';
import 'package:expenses_tracker/presentation/widgets/default_button.dart';
import 'package:expenses_tracker/presentation/widgets/loading.dart';
import 'package:expenses_tracker/presentation/widgets/show_date_picker.dart';
import 'package:expenses_tracker/presentation/widgets/delete_dialogs.dart';
import 'package:expenses_tracker/presentation/widgets/show_error_dialog.dart';
import 'package:expenses_tracker/presentation/widgets/sized_boxes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';

class AddExpenseScreen extends StatefulWidget {
  const AddExpenseScreen({super.key});

  @override
  State<AddExpenseScreen> createState() => _AddExpenseScreenState();
}

class _AddExpenseScreenState extends State<AddExpenseScreen> {

  TextEditingController expenseController = TextEditingController();
  TextEditingController titleController = TextEditingController();
  TextEditingController categoryController = TextEditingController();
  TextEditingController dateController = TextEditingController();
  TextEditingController detailsController = TextEditingController();
  // DateTime selectDate = DateTime.now();
  bool isExtended = false;
  late Expense expense;
  String categoryFieldIcon = '';
  int categoryFieldColor = 0;
  Category categoryIsSelected = Category.empty;
  bool isLoading = false;

  // & ===> TODO: 
  // DocumentSnapshot doc = await FirebaseFirestore.instance
  //     .collection('expenses')
  //     .doc(expenseId)
  //     .get();

  @override
  void initState() {
    dateController.text = DateFormat('dd/MM/yyyy').format(DateTime.now());
    expense = Expense.empty;
    expense.expenseId = const Uuid().v1();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<CreateExpenseBloc, CreateExpenseState>(
      listener: (context, state) {
        if (state is CreateExpenseSuccess) {
          Navigator.pop(context, expense);
        } else if (state is CreateExpenseLoading) {
          isLoading = true;
        }
      },
      child: GestureDetector(
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
          ),
          body: BlocBuilder<GetCategoriesBloc, GetCategoriesState>(
            builder: (context, state) {
              if (state is GetCategoriesSuccess) {
                return Padding(
                  padding: const EdgeInsets.all(16),
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        height(MediaQuery.of(context).size.height * 0.1),
                        const Text(
                          'Add Expense',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        height(36),
                        TextFormField(
                          controller: titleController,
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
                        TextFormField(
                          controller: expenseController,
                          keyboardType: TextInputType.number,
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
                        TextFormField(
                          onTap: () {
                            // context.read<GetCategoriesBloc>().add(GetCategories());
                            setState(() {
                              isExtended = !isExtended;
                            });
                          },
                          readOnly: true,
                          controller: categoryController,
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: categoryFieldColor == 0
                                ? Colors.white
                                : Color(categoryFieldColor),
                            prefixIcon: categoryFieldIcon == ''
                                ? const Icon(
                                    Icons.format_list_bulleted_rounded,
                                    color: Colors.grey,
                                  )
                                : Image.asset(
                                    expense.category.icon,
                                    scale: 5,
                                  ),
                            suffixIcon: IconButton(
                              onPressed: () {
                                getCategoryCreation(context);
                              },
                              icon: Icon(
                                Icons.add_rounded,
                                color: expense.category == Category.empty
                                    ? Colors.grey
                                    : Colors.black,
                              ),
                            ),
                            hintText: 'Category',
                            border: OutlineInputBorder(
                              borderRadius: isExtended == false
                                  ? BorderRadius.circular(12)
                                  : const BorderRadius.vertical(
                                      top: Radius.circular(12),
                                    ),
                              borderSide: BorderSide.none,
                            ),
                          ),
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
                                                    expense.category =
                                                        state.categories[index];
                                                    categoryFieldIcon = state
                                                        .categories[index].icon;
                                                    categoryFieldColor = state
                                                        .categories[index]
                                                        .color;
                                                    categoryController.text =
                                                        expense.category.name;
                                                    categoryIsSelected = expense.category;
                                                  });
                                                },
                                                onLongPress: () {
                                                  myCategoryDeletetionDialog(
                                                    context,
                                                    categoryId: state.categories[index].categoryId,
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
                        TextFormField(
                          controller: dateController,
                          readOnly: true,
                          onTap: () async {
                            DateTime? newDate = await myDatePicker(context, initialDate: expense.date);
                            if (newDate != null) {
                              setState(() {
                                dateController.text =
                                    DateFormat('dd/MM/yyyy').format(newDate);
                                // selectDate = newDate;
                                expense.date = newDate;
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
                        TextFormField(
                          maxLines: null,
                          maxLength: 2000,
                          controller: detailsController,
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
                        height(36),
                        isLoading == false
                          ? defaultButton(
                            width: double.infinity,
                            height: kToolbarHeight,
                            onPressed: () {
                              if (categoryIsSelected == Category.empty) {
                                return showErrorDialog(context: context);
                              } else if (titleController.text == '') {
                                return showErrorDialog(context: context);
                              } else {
                                setState(() {
                                    expense.amount = int.parse(expenseController.text);
                                    expense.title = titleController.text;
                                    expense.details = detailsController.text;
                                });
                                context
                                  .read<CreateExpenseBloc>()
                                  .add(CreateExpense(expense));
                              }
                            },
                          )
                          : dotsLoading(),
                      ],
                    ),
                  ),
                );
              } else {
                return dotsLoading();
              }
            },
          ),
        ),
      ),
    );
  }
}
