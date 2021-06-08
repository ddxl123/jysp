import 'package:flutter/material.dart';
import 'package:jysp/database/merge_models/MMPoolNode.dart';
import 'package:jysp/mvc/controllers/HomePageController.dart';
import 'package:jysp/mvc/controllers/LoginPageController.dart';
import 'package:jysp/mvc/controllers/init_download_controller/InitDownloadController.dart';
import 'package:jysp/mvc/views/LoginPage.dart';
import 'package:jysp/mvc/views/create_fragment_page/CreateFragmentPage.dart';
import 'package:jysp/mvc/views/home_page/HomePage.dart';
import 'package:jysp/mvc/views/init_download_page/InitDownloadPage.dart';
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
    Navigator.pushReplacement(
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
    Navigator.pushReplacement(
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

  GNavigatorPush.pushCreateFragmentPage(BuildContext context, MMPoolNode mmodel) {
    Navigator.push(
      context,
      MaterialPageRoute<void>(
        builder: (BuildContext context) => CreateFragmentPage(mmodel: mmodel),
      ),
    );
  }

  ///
}
