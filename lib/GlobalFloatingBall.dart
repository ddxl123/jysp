import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:jysp/Database/Models/MBase.dart';
import 'package:jysp/G/GSqlite/SqliteTools.dart';
import 'package:jysp/Tools/FreeBox/FreeBox.dart';
import 'package:jysp/Tools/FreeBox/FreeBoxController.dart';
import 'package:jysp/Tools/TDebug.dart';

///
///
///
/// 显示可视化 sqlite 主体内容的基础，自带点击背景关闭当前页。
class BodyBaseWidget extends StatefulWidget {
  /// [isFloatingBall] 为 true 时 为悬浮球，为 null 或 false 时不为悬浮球
  const BodyBaseWidget({required this.child, required this.overlayEntry, this.isFloatingBall});

  final Widget child;
  final OverlayEntry overlayEntry;
  final bool? isFloatingBall;

  @override
  _BodyBaseWidgetState createState() => _BodyBaseWidgetState();
}

class _BodyBaseWidgetState extends State<BodyBaseWidget> {
  @override
  Widget build(BuildContext context) {
    return Material(
      type: MaterialType.transparency,
      child: Stack(
        children: <Widget>[
          if (widget.isFloatingBall == false || widget.isFloatingBall == null)
            Positioned(
              child: GestureDetector(
                child: Opacity(
                  opacity: 0.5,
                  child: Center(
                    child: Container(
                      alignment: Alignment.center,
                      width: 1000,
                      height: 1000,
                      color: Colors.grey,
                    ),
                  ),
                ),
                onTap: () {
                  widget.overlayEntry.remove();
                },
              ),
            ),
          if (widget.isFloatingBall == false || widget.isFloatingBall == null)
            Center(
              child: Container(
                width: MediaQueryData.fromWindow(window).size.width * 2 / 3,
                height: MediaQueryData.fromWindow(window).size.height * 2 / 3,
                color: Colors.white,
                child: widget.child,
              ),
            ),
          if (widget.isFloatingBall == true) widget.child,
        ],
      ),
    );
  }
}

class InsertOverlayEntry {
  void from({required OverlayState overlayState, required Widget Function(OverlayState, OverlayEntry) builder, bool? isFloatingBall}) {
    late OverlayEntry overlayEntry;
    overlayEntry = OverlayEntry(
      builder: (BuildContext context) => BodyBaseWidget(
        child: builder(overlayState, overlayEntry),
        isFloatingBall: isFloatingBall,
        overlayEntry: overlayEntry, // 当前 overlayEntry，提供给背景点击后进行 remove
      ),
    );
    overlayState.insert(overlayEntry);
  }
}

///
///
///
/// 可视化 sqlite 数据库的按钮（悬浮球）
class FloatingBall extends StatefulWidget {
  const FloatingBall({required this.overlayState});
  final OverlayState overlayState;

  @override
  _FloatingBallState createState() => _FloatingBallState();
}

class _FloatingBallState extends State<FloatingBall> {
  Offset position = Offset.zero;

  Widget button() {
    return Material(
      child: GestureDetector(
        child: Container(
          alignment: Alignment.center,
          color: Colors.red,
          width: 80,
          height: 80,
          child: const Text('查看 sqlite'),
        ),
        onTap: () {
          InsertOverlayEntry().from(
            overlayState: widget.overlayState,
            builder: (OverlayState overlayState, OverlayEntry overlayEntry) => Index(overlayState: overlayState),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: position.dy,
      left: position.dx,
      child: Draggable<Object>(
        child: button(),
        feedback: button(),
        onDragEnd: (DraggableDetails details) {
          position = details.offset;
          setState(() {});
        },
      ),
    );
  }
}

///
///
///
/// 查看全部表的页面
class Index extends StatefulWidget {
  const Index({required this.overlayState});
  final OverlayState overlayState;

  @override
  _IndexState createState() => _IndexState();
}

class _IndexState extends State<Index> {
  /// 全部 sqlite 表
  List<String> allTableNames = <String>[];

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<dynamic>(
      future: () async {
        try {
          await SqliteTools().getAllTableNames().then(
            (List<String> value) {
              allTableNames.clear(); // 因为 remove 其他的浮动 widget 会把所有其他浮动的 widget 全部 setState
              allTableNames.addAll(value);
            },
          );
        } catch (e) {
          dLog(() => e);
        }
      }(),
      builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.waiting:
            return const Center(
              child: Text('正在获取中...'),
            );
          case ConnectionState.done:
            return ListView.builder(
              padding: const EdgeInsets.all(10),
              itemCount: allTableNames.length,
              itemBuilder: (BuildContext context, int index) {
                return TextButton(
                  child: Text(allTableNames[index]),
                  onPressed: () {
                    InsertOverlayEntry().from(
                      overlayState: widget.overlayState,
                      builder: (OverlayState overlayState, OverlayEntry overlayEntry) => TableContent(tableName: allTableNames[index]),
                    );
                  },
                );
              },
              physics: const AlwaysScrollableScrollPhysics(parent: BouncingScrollPhysics()),
            );
          default:
            return Center(
              child: Text('ConnectionState unknown: ${snapshot.connectionState}'),
            );
        }
      },
    );
  }
}

/// 查看对应表的数据
class TableContent extends StatefulWidget {
  const TableContent({required this.tableName});
  final String tableName;

  @override
  _TableContentState createState() => _TableContentState();
}

class _TableContentState extends State<TableContent> {
  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      child: FreeBox(
        freeBoxController: FreeBoxController(),
        backgroundColor: Colors.green,
        viewableWidth: null,
        viewableHeight: null,
        fixedLayerBuilder: (BuildContext freeBoxProxyContext) {
          return Stack(
            children: <Widget>[
              Positioned(
                top: 0,
                left: 0,
                child: Container(
                  color: Colors.blue,
                  child: Text(widget.tableName),
                ),
              ),
            ],
          );
        },
        freeMoveScaleLayerBuilder: (BuildContext freeBoxProxyContext) {
          return Stack(
            children: <Widget>[
              Positioned(
                top: MediaQueryData.fromWindow(window).size.height * 1 / 6,
                left: MediaQueryData.fromWindow(window).size.width * 1 / 4,
                child: TableForTableData(tableName: widget.tableName),
              ),
            ],
          );
        },
      ),
    );
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
  List<String> columnNames = <String>[];
  List<MBase> data = <MBase>[];

  @override
  void initState() {
    super.initState();

    SqliteTools().getTableInfo(widget.tableName).then(
      (List<Map<String, Object?>> tableInfo) {
        for (int i = 0; i < tableInfo.length; i++) {
          columnNames.add(tableInfo[i]['name']! as String);
        }
        MBase.queryRowsAsModels(tableName: widget.tableName, where: null, whereArgs: null, connectTransaction: null).then(
          (List<MBase> value) {
            data.addAll(value);
            setState(() {});
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    if (columnNames.isEmpty) {
      return const Text('正在获取中...');
    }
    return _table();
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

class EnableGlobalFloatingBall {
  EnableGlobalFloatingBall(BuildContext context) {
    overlayState = Overlay.of(context)!;
    InsertOverlayEntry().from(
      overlayState: overlayState,
      builder: (OverlayState overlayState, OverlayEntry overlayEntry) => FloatingBall(overlayState: overlayState),
      isFloatingBall: true,
    );
  }

  late final OverlayState overlayState;
}
