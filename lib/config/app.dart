import 'package:admin_panel/core/data_provider.dart';
import 'package:admin_panel/features/categories/data/category_provider.dart';
import 'package:admin_panel/features/categories/screen/category_screen.dart';
import 'package:admin_panel/theme/color_scheme.dart';
import 'package:admin_panel/utility/extensions.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart'; // Import Provider

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => DataProvider()),
        ChangeNotifierProvider(
            create: (context) => CategoryProvider(context.dataProvider)),
      ],
      child: MaterialApp(
        title: 'Portfolio Admin Panel',
        theme: lightMode,
        home: CategoryScreen(),
      ),
    );
  }
}
