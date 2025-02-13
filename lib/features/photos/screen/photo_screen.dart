import 'package:admin_panel/features/categories/components/add_category_form.dart';
import 'package:admin_panel/features/categories/components/category_list_section.dart';
import 'package:admin_panel/features/photos/components/photo_list_section.dart';
import 'package:admin_panel/utility/constants.dart';
import 'package:admin_panel/utility/extensions.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class PhotoScreen extends StatefulWidget {
  const PhotoScreen({super.key});

  @override
  State<PhotoScreen> createState() => _PhotoScreenState();
}

class _PhotoScreenState extends State<PhotoScreen> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        primary: false,
        padding: EdgeInsets.all(defaultPadding),
        child: Column(
          children: [
            SizedBox(height: defaultPadding),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 5,
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Expanded(
                            child: Text(
                              "My Photos",
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
                              showAddCategoryForm(context, null);
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
                                    .getAllPhotos(showSnack: true);
                              },
                              icon: Icon(Icons.refresh)),
                        ],
                      ),
                      Gap(defaultPadding),
                      PhotoListSection(),
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
