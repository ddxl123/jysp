import 'package:flutter/material.dart';
import 'package:jysp/MVC/Controllers/HomePageController.dart';
import 'package:jysp/MVC/Controllers/InitDownloadController/InitDownloadController.dart';
import 'package:jysp/MVC/Controllers/LoginPageController.dart';
import 'package:jysp/MVC/Views/CreateFragmentPage/CreateFragmentPage.dart';
import 'package:jysp/MVC/Views/HomePage/HomePage.dart';
import 'package:jysp/MVC/Views/InitDownloadPage/InitDownloadPage.dart';
import 'package:jysp/MVC/Views/LoginPage.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

class GNavigatorPush {
  ///

  GNavigatorPush.pushLoginPage(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute<void>(
        builder: (_) => ChangeNotifierProvider<LoginPageController>(
          create: (_) => LoginPageController(),
          child: Builder(builder: (_) => LoginPage()),
        ),
      ),
    );
  }

  GNavigatorPush.pushInitDownloadPage(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute<void>(
        builder: (_) => ChangeNotifierProvider<InitDownloadController>(
          create: (_) => InitDownloadController(),
          child: Builder(builder: (_) => InitDownloadPage()),
        ),
      ),
    );
  }

  GNavigatorPush.pushHomePage(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute<void>(
        builder: (_) => MultiProvider(
          providers: <SingleChildWidget>[
            ChangeNotifierProvider<HomePageController>(create: (_) => HomePageController()),
          ],
          child: HomePage(),
        ),
      ),
    );
  }

  GNavigatorPush.pushCreateFragmentPage(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute<void>(
        builder: (BuildContext context) => CreateFragmentPage(),
      ),
    );
  }

  ///
}
