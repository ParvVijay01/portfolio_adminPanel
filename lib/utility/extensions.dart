import 'package:admin_panel/core/data_provider.dart';
import 'package:admin_panel/features/categories/data/category_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

extension Providers on BuildContext {
  CategoryProvider get categoryProvider => Provider.of<CategoryProvider>(this, listen: false);
  DataProvider get dataProvider => Provider.of<DataProvider>(this, listen: false);
}
