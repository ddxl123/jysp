import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:jysp/database/g_sqlite/SqliteTools.dart';
import 'package:jysp/database/merge_models/MMBase.dart';
import 'package:jysp/database/models/MBase.dart';
import 'package:jysp/global_floating_ball/FloatingBallBase.dart';
import 'package:jysp/tools/Helper.dart';
import 'package:jysp/tools/RoundedBox..dart';
import 'package:jysp/tools/TDebug.dart';
import 'package:jysp/tools/free_box/FreeBox.dart';
import 'package:jysp/tools/free_box/FreeBoxController.dart';
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
                                  Navigator.push(context, Second(context, allTableNames[i]));
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
  void init() {}

  @override
  void rebuild() {}

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

/// TODO: 需要实现 N 条 N 条获取数据
class Second extends ToastRoute {
  Second(BuildContext fatherContext, this.currentTableName) : super(fatherContext);

  @override
  Color get backgroundColor => Colors.transparent;

  @override
  double get backgroundOpacity => 0;

  String currentTableName;

  final FreeBoxController _freeBoxController = FreeBoxController();

  @override
  List<Widget> body() {
    return <Positioned>[
      Positioned(
        child: Center(
          child: RoundedBox(
            width: MediaQuery.of(context).size.width * 2 / 3,
            height: MediaQuery.of(context).size.height * 2 / 3,
            isScrollale: false,
            children: <Widget>[
              FreeBox(
                freeBoxController: _freeBoxController,
                boxWidth: MediaQuery.of(context).size.width * 2 / 3,
                boxHeight: MediaQuery.of(context).size.height * 2 / 3,
                freeMoveScaleLayerBuilder: FreeBoxStack(
                  builder: (BuildContext context, SetState setState) {
                    return <FreeBoxPositioned>[
                      FreeBoxPositioned(
                        child: TableForTableData(tableName: currentTableName),
                        boxPosition: Offset.zero,
                      ),
                    ];
                  },
                ),
                fixedLayerBuilder: (SetState setState) {
                  return Stack(
                    children: <Widget>[
                      Positioned(
                        top: 0,
                        left: 0,
                        child: Container(
                          color: Colors.blue,
                          child: Text(currentTableName),
                        ),
                      ),
                    ],
                  );
                },
              )
            ],
          ),
        ),
      ),
    ];
  }

  @override
  void init() {}

  @override
  void rebuild() {}

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

/// 对应表数据的表格
class TableForTableData extends StatefulWidget {
  const TableForTableData({required this.tableName});
  final String tableName;

  @override
  _TableForTableDataState createState() => _TableForTableDataState();
}

class _TableForTableDataState extends State<TableForTableData> {
  ///

  /// 表头数据
  List<String> columnNames = <String>[];

  /// 表体数据
  List<MBase> data = <MBase>[];

  late final Future<void> _future = Future<void>(
    () async {
      await SqliteTools().getTableInfo(widget.tableName).then(
        (List<Map<String, Object?>> tableInfo) async {
          for (int i = 0; i < tableInfo.length; i++) {
            columnNames.add(tableInfo[i]['name']! as String);
          }
          await MBase.queryRowsAsModels<MBase, MMBase, MBase>(
            tableName: widget.tableName,
            where: null,
            whereArgs: null,
            connectTransaction: null,
            returnMWhere: (MBase model) => model,
            returnMMWhere: null,
          ).then(
            (List<MBase> value) {
              data.addAll(value);
            },
          );
        },
      );
    },
  );

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<void>(
      future: _future,
      builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
        if (snapshot.hasError) {
          return const Text('err');
        }
        switch (snapshot.connectionState) {
          case ConnectionState.waiting:
            return const Text('正在获取中...');
          case ConnectionState.done:
            return _table();
          default:
            return Text('unknown：${snapshot.connectionState}');
        }
      },
    );
  }

  Table _table() {
    return Table(
      border: TableBorder.all(),
      defaultColumnWidth: const IntrinsicColumnWidth(),
      children: <TableRow>[
        TableRow(
          children: <Widget>[
            for (int i = 0; i < columnNames.length; i++)
              Container(
                padding: const EdgeInsets.all(10),
                child: Text(
                  columnNames[i],
                  style: const TextStyle(color: Colors.cyanAccent),
                ),
              ),
          ],
        ),
        for (int x = 0; x < data.length; x++)
          TableRow(
            children: <Widget>[
              for (int y = 0; y < data[x].getRowJson.values.length; y++)
                Container(
                  padding: const EdgeInsets.all(10),
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 200),
                    child: Text(
                      data[x].getRowJson.values.elementAt(y).toString(),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 5,
                      style: const TextStyle(color: Colors.black),
                    ),
                  ),
                ),
            ],
          ),
      ],
    );
  }
}
