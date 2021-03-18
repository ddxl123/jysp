import 'package:flutter/material.dart';
import 'package:jysp/MVC/Controllers/LoginPageController.dart';
import 'package:jysp/MVC/Views/LoginPage.dart';
import 'package:jysp/MVC/Views/HomePage/NodeSheetPage.dart';
import 'package:provider/provider.dart';

class GNavigatorPush {
  ///

  void pushLoginPage(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ChangeNotifierProvider<LoginPageController>(
          create: (_) => LoginPageController(),
          child: Builder(builder: (_) => LoginPage()),
        ),
      ),
    );
  }

  void pushSheetPage(BuildContext context) {
    Navigator.push(
      context,
      NodeSheetPage(slivers: (SheetPageController sheetPageController) {
        return [SliverAppBar()];
      }),
    );
  }

  ///
}
