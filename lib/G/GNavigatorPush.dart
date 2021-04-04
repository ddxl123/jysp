import 'package:flutter/material.dart';
import 'package:jysp/MVC/Controllers/LoginPageController.dart';
import 'package:jysp/MVC/Views/LoginPage.dart';
import 'package:jysp/Plugin/SheetPage/SheetPage.dart';
import 'package:jysp/Plugin/SheetPage/SheetPageController.dart';
import 'package:provider/provider.dart';

class GNavigatorPush {
  ///

  static void pushLoginPage(BuildContext context) {
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

  static void pushSheetPage(BuildContext context) {
    Navigator.push(
      context,
      SheetPage(
        bodyDataFuture: (List<Map> bodyData) async {
          await Future.delayed(Duration(seconds: 2));

          return BodyDataFutureResult.success;
        },
        slivers: ({required sheetPageController, required header, required body, required loadArea}) {
          return [
            header(
              SliverToBoxAdapter(
                child: Container(
                  height: 50,
                  color: Colors.orange,
                  child: Text("data"),
                ),
              ),
            ),
            body(
              SliverList(
                delegate: SliverChildBuilderDelegate(
                  (_, index) {
                    bool isCheck = false;
                    return Row(
                      children: [
                        Expanded(
                          child: TextButton(
                            style: TextButton.styleFrom(
                              padding: EdgeInsets.all(0),
                              backgroundColor: Colors.purple,
                              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                            ),
                            onPressed: () {},
                            child: Text(sheetPageController.bodyData[index].toString()),
                          ),
                        ),
                        StatefulBuilder(
                          builder: (BuildContext context, rebuild) {
                            return Checkbox(
                              value: isCheck,
                              onChanged: (check) {
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

  ///
}
