import 'package:expense_repository/expense_repository.dart';
import 'package:expenses_tracker/app/utils/extensions.dart';
import 'package:expenses_tracker/logic/bloc/create_category_bloc/create_category_bloc.dart';
import 'package:expenses_tracker/logic/bloc/get_categories_bloc/get_categories_bloc.dart';
import 'package:expenses_tracker/presentation/widgets/default_button.dart';
import 'package:expenses_tracker/presentation/widgets/loading.dart';
import 'package:expenses_tracker/presentation/widgets/sized_boxes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:uuid/uuid.dart';

getCategoryCreation(BuildContext context) {
  List<String> categoryIcons = [
    'assets/images/entertainment.png',
    'assets/images/food.png',
    'assets/images/home.png',
    'assets/images/pet.png',
    'assets/images/shopping.png',
    'assets/images/tech.png',
    'assets/images/travel.png',
    'assets/images/games.png',
  ];

  return showDialog(
    context: context,
    builder: (ctx) {
      bool isExpanded = false;
      bool isLoading = false;
      String iconSelected = '';
      Color categoryColor = Color(4294967295);
      TextEditingController categoryNameController = TextEditingController();

      return StatefulBuilder(builder: (ctx, setState) {
        return BlocProvider.value(
          value: context.read<CreateCategoryBloc>(),
          child: BlocListener<CreateCategoryBloc, CreateCategoryState>(
            listener: (context, state) {
              if (state is CreateCategorySuccess) {
                Navigator.pop(ctx);
              } else if (state is CreateCategoryLoading) {
                setState(() {
                  isLoading = true;
                });
              }
            },
            child: AlertDialog(
              backgroundColor: context.colorScheme.surface,
              title: const Align(
                alignment: Alignment.center,
                child: Text('Create a Category'),
              ),
              titleTextStyle: TextStyle(
                fontSize: 20,
                color: context.colorScheme.onSurface,
                fontWeight: FontWeight.w600,
                fontFamily: 'Montserrat',
              ),
              content: SizedBox(
                width: MediaQuery.of(context).size.width,
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextFormField(
                        controller: categoryNameController,
                        textAlign: TextAlign.center,
                        decoration: InputDecoration(
                          isDense: true,
                          filled: true,
                          fillColor: Colors.white,
                          hintText: 'Name',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide.none,
                          ),
                        ),
                      ),
                      height(20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Column(
                            children: [
                              GestureDetector(
                                onTap: () {
                                  setState(() {
                                    isExpanded = !isExpanded;
                                  });
                                },
                                child: Container(
                                  width:
                                      MediaQuery.of(context).size.width / 3.5,
                                  height:
                                      MediaQuery.of(context).size.width / 3.5,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: isExpanded
                                        ? const BorderRadius.vertical(
                                            top: Radius.circular(12),
                                          )
                                        : BorderRadius.circular(12),
                                  ),
                                  child: Center(
                                    child: iconSelected == ''
                                        ? Text(
                                            'Icon',
                                            style: TextStyle(
                                              fontSize: 16,
                                              color: Colors.grey[700],
                                              fontWeight: FontWeight.w500,
                                            ),
                                          )
                                        : Image.asset(
                                            iconSelected,
                                            scale: 2,
                                          ),
                                  ),
                                ),
                              ),
                              if (isExpanded)
                                Container(
                                  width:
                                      MediaQuery.of(context).size.width / 3.5,
                                  height: 200,
                                  decoration: const BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.vertical(
                                      bottom: Radius.circular(12),
                                    ),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: GridView.builder(
                                      gridDelegate:
                                          const SliverGridDelegateWithFixedCrossAxisCount(
                                        crossAxisCount: 1,
                                        mainAxisSpacing: 5,
                                        crossAxisSpacing: 5,
                                      ),
                                      itemCount: categoryIcons.length,
                                      itemBuilder: (context, index) {
                                        return GestureDetector(
                                          onTap: () {
                                            setState(() {
                                              iconSelected = categoryIcons[index];
                                            });
                                          },
                                          child: Container(
                                            width: 50,
                                            height: 50,
                                            decoration: BoxDecoration(
                                              border: Border.all(
                                                color: iconSelected ==
                                                        categoryIcons[index]
                                                    ? Colors.green
                                                    : Colors.grey,
                                                width: 3,
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(12),
                                              image: DecorationImage(
                                                image: AssetImage(
                                                    categoryIcons[index]),
                                                scale: 3,
                                              ),
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                ),
                            ],
                          ),
                          width(20),
                          GestureDetector(
                            onTap: () {
                              showDialog(
                                context: context,
                                builder: (ctx2) {
                                  return AlertDialog(
                                    title: const Text('Pick a color'),
                                    content: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        ColorPicker(
                                          pickerColor: categoryColor,
                                          onColorChanged: (value) {
                                            setState(() {
                                              categoryColor = value;
                                            });
                                          },
                                        ),
                                        defaultButton(
                                          width: double.infinity,
                                          height: 50,
                                          onPressed: () {
                                            Navigator.pop(context);
                                          },
                                          label: 'OK',
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              );
                            },
                            child: Container(
                              width: MediaQuery.of(context).size.width / 3.5,
                              height: MediaQuery.of(context).size.width / 3.5,
                              decoration: BoxDecoration(
                                color: categoryColor,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Center(
                                child: Text(
                                  categoryColor == Colors.white
                                      ? 'Color'
                                      : '',
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.grey[700],
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      height(20),
                      isLoading == true
                        ? dotsLoading()
                        : defaultButton(
                            width: double.infinity,
                            height: 45,
                            onPressed: () {
                              if (iconSelected == '' || categoryNameController.text.isEmpty) {
                                showDialog(
                                  context: context,
                                  builder: (context) {
                                    return AlertDialog(
                                      title: const Text('Some fields are empty!'),
                                      titleTextStyle: const TextStyle(
                                        fontSize: 20,
                                        color: Colors.black,
                                        fontFamily: 'Montserrat',
                                        fontWeight: FontWeight.w500,
                                      ),
                                      actions: [
                                        TextButton(
                                          onPressed: () {
                                            Navigator.pop(context);
                                          },
                                          child: const Text('OK'),
                                        ),
                                      ],
                                    );
                                  },
                                );
                              } else {
                                Category category = Category.empty;
                                category.categoryId = const Uuid().v1();
                                category.name = categoryNameController.text;
                                category.icon = iconSelected;
                                category.color = categoryColor.value;
                                context
                                    .read<CreateCategoryBloc>()
                                    .add(CreateCategory(category));
                                context
                                    .read<GetCategoriesBloc>()
                                    .add(GetCategories());
                              }
                            },
                          ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      });
    },
  );
}
