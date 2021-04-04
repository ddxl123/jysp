import 'package:flutter/material.dart';
import 'package:jysp/Database/models/MDownloadModule.dart';
import 'package:jysp/G/G.dart';
import 'package:jysp/G/GDownloadQueue.dart';
import 'package:jysp/G/GSqlite/GSqlite.dart';
import 'package:jysp/Tools/TDebug.dart';

class DownloadQueuePage extends OverlayRoute {
  ///

  @override
  Iterable<OverlayEntry> createOverlayEntries() {
    return [
      OverlayEntry(
        builder: (_) {
          return Material(
            type: MaterialType.transparency,
            child: Stack(
              children: [
                _background(),
                _body(),
              ],
            ),
          );
        },
      )
    ];
  }

  Widget _background() {
    return Opacity(
      opacity: 0.5,
      child: Container(
        alignment: Alignment.center,
        color: Colors.black,
      ),
    );
  }

  Widget _body() {
    return Positioned(
      child: Center(
        child: Container(
          width: 300,
          decoration: BoxDecoration(
            color: Colors.yellow,
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(offset: Offset(10, 10), blurRadius: 10, spreadRadius: -10),
            ],
          ),
          child: _content(),
        ),
      ),
    );
  }

  Widget _content() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        // 这里的占比是根据父容器大小的占比
        Flexible(child: _title()),
        Flexible(child: _downList()),
        _allDown(),
      ],
    );
  }

  Widget _title() {
    return Container(
      padding: EdgeInsets.fromLTRB(20, 10, 0, 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            child: Text(
              "下载队列：",
              style: TextStyle(fontSize: 16),
            ),
          ),
          TextButton.icon(
            style: TextButton.styleFrom(
              padding: EdgeInsets.all(0),
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
            icon: Icon(Icons.close),
            label: Text(""),
            onPressed: () {
              Navigator.pop(G.globalKey.currentContext!);
            },
          ),
        ],
      ),
    );
  }

  Widget _downList() {
    return DownList();
  }

  Widget _allDown() {
    return Flexible(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Expanded(child: TextButton(onPressed: () {}, child: Text("全选"))),
          Expanded(child: TextButton(onPressed: () {}, child: Text("下载已选"))),
        ],
      ),
    );
  }

  @override
  // ignore: must_call_super
  // bool didPop(result) {
  //   return true;
  // }

  @override
  void dispose() {
    super.dispose();
  }

  ///
}

class DownList extends StatefulWidget {
  @override
  _DownListState createState() => _DownListState();
}

class _DownListState extends State<DownList> {
  ///

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _future(),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.waiting:
            return Center(child: Text("加载中..."));
          case ConnectionState.done:
            dLog(() => GDownloadQueue.downloadModules);
            return ListView(
              physics: BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
              padding: EdgeInsets.fromLTRB(30, 0, 30, 0),
              children: [
                for (int i = 0; i < GDownloadQueue.downloadModules.length; i++)
                  //
                  () {
                    return (GDownloadQueue.downloadModules.values.toList().asMap()[i]!["widget"] as Widget);
                  }(),
              ],
            );
          default:
            return Center(child: Text("unknown connectionState"));
        }
      },
    );
  }

  Future<void> _future() async {
    await Future.delayed(Duration(seconds: 2));

    List<Map<String, Object?>> sqliteDownloadModules = await GSqlite.db.query(MDownloadModule.getTableName);

    sqliteDownloadModules.forEach(
      (sqliteModule) {
        // 若模块未被列在【下载队列】 Widget 上，则先检查是否已完成过下载。
        if (!GDownloadQueue.downloadModules.containsKey(sqliteModule[MDownloadModule.module_name])) {
          String moduleName = sqliteModule[MDownloadModule.module_name] as String;
          GDownloadQueue.downloadModules[moduleName] = {}; // 赋给模型一个 key 为 moduleName 的对象
          Map<String, dynamic> moduleObj = GDownloadQueue.downloadModules[moduleName]!;
          // 未被下载完成过
          if (sqliteModule[MDownloadModule.download_is_ok] == 0) {
            moduleObj["progress"] = -1;
            moduleObj["widget"] = _queueWidget(moduleObj, moduleName);
          }
          // 已被下载完成过
          else if (sqliteModule[MDownloadModule.download_is_ok] == 1) {
            moduleObj["progress"] = -2;
            moduleObj["widget"] = _queueWidget(moduleObj, moduleName);
          }
          // TODO: [download_is_ok] 字段值异常
          else {}
        }
      },
    );
  }

  Widget _queueWidget(Map<String, dynamic> moduleObj, String moduleName) {
    return StatefulBuilder(
      builder: (BuildContext context, setState) {
        moduleObj["setState"] = setState;
        Widget downloadStatusWidget;

        switch (moduleObj["progress"]) {
          // 未被下载完成过
          case -1:
            downloadStatusWidget = TextButton(onPressed: () {}, child: Text("↓"));
            break;
          // 已被下载完成过
          case -2:
            downloadStatusWidget = TextButton(onPressed: () {}, child: Text("√"));
            break;
          // 进度
          default:
            downloadStatusWidget = TextButton(onPressed: () {}, child: Text(moduleObj["progress"].toString()));
        }
        return Row(
          children: [
            Text(moduleName),
            downloadStatusWidget,
          ],
        );
      },
    );
  }

  ///
}
