import 'package:admin_panel/features/main/screen/main_screen.dart';
import 'package:get/get_navigation/src/routes/get_route.dart';

class AppPages {
  static const HOME = '/';

  static final routes = [
    GetPage(name: HOME, fullscreenDialog: true, page: () => MainScreen()),
  ];
}
