import 'package:flutter/material.dart';
import 'package:jysp/Database/Models/MBase.dart';
import 'package:jysp/MVC/Controllers/FragmentPoolController/FragmentPoolController.dart';
import 'package:jysp/MVC/Controllers/InitDownloadController/InitDownloadController.dart';
import 'package:jysp/MVC/Controllers/LoginPageController.dart';
import 'package:jysp/MVC/Views/HomePage/HomePage.dart';
import 'package:jysp/MVC/Views/HomePage/SmallPage/NodeJustCreated.dart';
import 'package:jysp/MVC/Views/HomePage/SmallPage/NodeLongPressMenu.dart';
import 'package:jysp/MVC/Views/InitDownloadPage/InitDownloadPage.dart';
import 'package:jysp/MVC/Views/LoginPage.dart';
import 'package:jysp/Tools/SheetPage/SheetPage.dart';
import 'package:jysp/Tools/SheetPage/SheetPageController.dart';
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
            ChangeNotifierProvider<FragmentPoolController>(create: (_) => FragmentPoolController()),
          ],
          child: HomePage(),
        ),
      ),
    );
  }

  GNavigatorPush.pushSheetPage(BuildContext context) {
    Navigator.push(
      context,
      SheetPage(
        bodyDataFuture: (List<Map<String, String>> bodyData) async {
          await Future<void>.delayed(const Duration(seconds: 2));

          return BodyDataFutureResult.success;
        },
        slivers: ({
          required SheetPageController sheetPageController,
          required Widget Function(Widget) header,
          required Widget Function(Widget) body,
          required Widget Function() loadArea,
        }) {
          return <Widget>[
            header(
              SliverToBoxAdapter(
                child: Container(
                  height: 50,
                  color: Colors.orange,
                  child: const Text('data'),
                ),
              ),
            ),
            body(
              SliverList(
                delegate: SliverChildBuilderDelegate(
                  (_, int index) {
                    bool isCheck = false;
                    return Row(
                      children: <Widget>[
                        Expanded(
                          child: TextButton(
                            style: TextButton.styleFrom(
                              padding: const EdgeInsets.all(0),
                              backgroundColor: Colors.purple,
                              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                            ),
                            onPressed: () {},
                            child: Text(sheetPageController.bodyData[index].toString()),
                          ),
                        ),
                        StatefulBuilder(
                          builder: (BuildContext context, void Function(void Function()) rebuild) {
                            return Checkbox(
                              value: isCheck,
                              onChanged: (bool? check) {
                                isCheck = !isCheck;
                                rebuild(() {});
                              },
                            );
                          },
                        ),
                      ],
                    );
                  },
                  childCount: sheetPageController.bodyData.length,
                ),
              ),
            ),
            loadArea(),
          ];
        },
      ),
    );
  }

  GNavigatorPush.pushNodeJustCreated({
    required BuildContext context,
    required double left,
    required double top,
    required Future<void> Function(String) futrue,
  }) {
    Navigator.push(
      context,
      NodeJustCreated(
        left: left,
        top: top,
        future: futrue,
      ),
    );
  }

  GNavigatorPush.pushNodeLongPressMenu({required BuildContext context, required MBase baseModel}) {
    Navigator.push(context, NodeLongPressMenu(baseModel: baseModel));
  }

  ///
}
