import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:jysp/database/g_sqlite/SqliteTools.dart';
import 'package:jysp/global_floating_ball/FloatingBallBase.dart';
import 'package:jysp/global_floating_ball/common_page/DataTableCommon.dart';
import 'package:jysp/tools/RoundedBox..dart';
import 'package:jysp/tools/TDebug.dart';
import 'package:jysp/tools/toast/ShowToast.dart';
import 'package:jysp/tools/toast/ToastRoute.dart';

class SqliteDataFloatingBall extends FloatingBallBase {
  @override
  String get floatingBallName => 'sqlite';

  @override
  Offset get initPosition => const Offset(100, 100);

  @override
  double get radius => 50;

  @override
  ToastRoute firstRoutes(BuildContext floatingBallContext) {
    return First(floatingBallContext);
  }
}

class First extends ToastRoute {
  First(BuildContext fatherContext) : super(fatherContext);

  @override
  Color get backgroundColor => Colors.transparent;

  @override
  double get backgroundOpacity => 0;

  /// 全部 sqlite 表名
  List<String> allTableNames = <String>[];

  late final Future<bool> _future = Future<bool>(() async {
    try {
      await SqliteTools().getAllTableNames().then(
        (List<String> value) {
          allTableNames.clear(); // 因为 remove 其他的浮动 widget 会把所有其他浮动的 widget 全部 setState
          allTableNames.addAll(value);
        },
      );
      return true;
    } catch (e) {
      dLog(() => e);
      return false;
    }
  });

  @override
  List<Widget> body() {
    return <Positioned>[
      Positioned(
        child: Center(
          child: FutureBuilder<bool>(
            future: _future,
            builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
              if (snapshot.data == null || !snapshot.data!) {
                return RoundedBox(
                  width: MediaQueryData.fromWindow(window).size.width * 2 / 3,
                  height: MediaQueryData.fromWindow(window).size.height * 2 / 3,
                  children: const <Widget>[
                    Text('获取失败'),
                  ],
                );
              }
              switch (snapshot.connectionState) {
                case ConnectionState.waiting:
                  return RoundedBox(
                    width: MediaQueryData.fromWindow(window).size.width * 2 / 3,
                    height: MediaQueryData.fromWindow(window).size.height * 2 / 3,
                    children: const <Widget>[
                      Text('正在获取中...'),
                    ],
                  );
                case ConnectionState.done:
                  return RoundedBox(
                    width: MediaQueryData.fromWindow(window).size.width * 2 / 3,
                    height: MediaQueryData.fromWindow(window).size.height * 2 / 3,
                    children: <Widget>[
                      for (int i = 0; i < allTableNames.length; i++)
                        //
                        Row(
                          children: <Widget>[
                            Expanded(
                              child: TextButton(
                                child: Text(allTableNames[i]),
                                onPressed: () {
                                  Navigator.push(context, DataTableCommon(context, allTableNames[i]));
                                },
                              ),
                            ),
                          ],
                        ),
                    ],
                  );
                default:
                  return RoundedBox(
                    width: MediaQueryData.fromWindow(window).size.width * 2 / 3,
                    height: MediaQueryData.fromWindow(window).size.height * 2 / 3,
                    children: const <Widget>[
                      Text('unknown snapshot'),
                    ],
                  );
              }
            },
          ),
        ),
      ),
    ];
  }

  @override
  Future<Toast<bool>> whenPop(PopResult? popResult) async {
    try {
      if (popResult == null || popResult.popResultSelect == PopResultSelect.clickBackground) {
        return showToast<bool>(text: '已返回', returnValue: true);
      } else {
        throw 'unknown popResult: $popResult';
      }
    } catch (e, r) {
      dLog(() => '$e---$r');
      return showToast<bool>(text: 'err', returnValue: false);
    }
  }
}
