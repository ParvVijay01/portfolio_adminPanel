import 'package:admin_panel/features/subCategory/components/add_subcategory_form.dart';
import 'package:admin_panel/features/subCategory/components/sub_category_list_section.dart';
import 'package:admin_panel/utility/extensions.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import '../../utility/constants.dart';

class SubCategoryScreen extends StatelessWidget {
  const SubCategoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        primary: false,
        padding: EdgeInsets.all(defaultPadding),
        child: Column(
          children: [
            Gap(defaultPadding),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 5,
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              "My Sub Categories",
                              style: Theme.of(context).textTheme.titleLarge,
                            ),
                          ),
                          ElevatedButton.icon(
                            style: TextButton.styleFrom(
                              elevation: 2,
                              side: BorderSide(color: Colors.black26),
                              padding: EdgeInsets.symmetric(
                                horizontal: defaultPadding * 1.5,
                                vertical: defaultPadding,
                              ),
                            ),
                            onPressed: () {
                              showAddSubCategoryForm(context, null);
                            },
                            icon: Icon(
                              Icons.add,
                              color: Colors.white,
                            ),
                            label: Text(
                              "Add New",
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                          Gap(20),
                          IconButton(
                              onPressed: () {
                                context.dataProvider
                                    .getAllSubCategories(showSnack: true);
                              },
                              icon: Icon(Icons.refresh)),
                        ],
                      ),
                      Gap(defaultPadding),
                      SubCategoryListSection(),
                    ],
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
