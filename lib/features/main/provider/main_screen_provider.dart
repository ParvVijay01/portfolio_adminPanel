import 'package:admin_panel/features/categories/screen/category_screen.dart';
import 'package:admin_panel/features/photos/screen/photo_screen.dart';
import 'package:admin_panel/features/subCategory/sub_category.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MainScreenProvider extends ChangeNotifier {
  Widget selectedScreen = CategoryScreen();

  navigateToScreen(String screenName) {
    switch (screenName) {
      // Break statement needed here
      case 'Category':
        selectedScreen = CategoryScreen();
        break;
      case 'Photos':
        selectedScreen = PhotoScreen();
        break;
      case 'SubCategory':
        selectedScreen = SubCategoryScreen();
        break;

      default:
        selectedScreen = CategoryScreen();
    }
    notifyListeners();
  }
}
