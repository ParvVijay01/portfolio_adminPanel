import 'package:admin_panel/core/data_provider.dart';
import 'package:admin_panel/features/categories/data/category_provider.dart';
import 'package:admin_panel/features/main/screen/main_screen.dart';
import 'package:admin_panel/features/main/provider/main_screen_provider.dart';
import 'package:admin_panel/features/photos/data/photo_provider.dart';
import 'package:admin_panel/features/subCategory/provider/sub_category_provider.dart';
import 'package:admin_panel/routes/app_pages.dart';
import 'package:admin_panel/theme/color_scheme.dart';
import 'package:admin_panel/utility/extensions.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart'; // Import Provider

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => DataProvider()),
        ChangeNotifierProvider(create: (context) => MainScreenProvider()),
        ChangeNotifierProvider(
            create: (context) => PhotoProvider(context.dataProvider)),
        ChangeNotifierProvider(
            create: (context) => CategoryProvider(context.dataProvider)),
        ChangeNotifierProvider(
            create: (context) => SubCategoryProvider(context.dataProvider)),
      ],
      child: GetMaterialApp(
        title: 'Portfolio Admin Panel',
        theme: lightMode,
        initialRoute: AppPages.HOME,
        unknownRoute: GetPage(name: '/notFound', page: () => MainScreen()),
        defaultTransition: Transition.cupertino,
        getPages: AppPages.routes,
      ),
    );
  }
}
