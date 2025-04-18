import 'package:admin_panel/utility/constants.dart';

import '../provider/main_screen_provider.dart';
import '../../../utility/extensions.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../components/side_menu.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    context.dataProvider;
    return Scaffold(
      body: SafeArea(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: SideMenu(),
            ),
            VerticalDivider(
              thickness: 1,
              color: primaryColor,
            ),
            Consumer<MainScreenProvider>(
              builder: (context, provider, child) {
                return Expanded(
                  flex: 5,
                  child: provider.selectedScreen,
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
