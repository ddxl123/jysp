import 'package:flutter/material.dart';
import 'package:jysp/Database/models/MDownloadModule.dart';
import 'package:jysp/G/GNavigatorPush.dart';
import 'package:jysp/MVC/Controllers/InitDownloadController/InitDownloadController.dart';
import 'package:jysp/MVC/Views/InitDownloadPage/DownloadModule.dart';
import 'package:jysp/MVC/Views/InitDownloadPage/Extension.dart';
import 'package:provider/provider.dart';

class InitDownloadPage extends StatefulWidget {
  @override
  _InitDownloadPageState createState() => _InitDownloadPageState();
}

class _InitDownloadPageState extends State<InitDownloadPage> {
  ///

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: context.read<InitDownloadController>().getListFuture(),
      builder: (context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.waiting:
            return Material(
              child: Stack(
                children: [
                  _background(),
                  _body(true),
                ],
              ),
            );
          case ConnectionState.done:
            return Material(
              child: Stack(
                children: [
                  _background(),
                  _body(false),
                ],
              ),
            );
          default:
            return Material(child: Center(child: Text("snapshot unknown")));
        }
      },
    );
  }

  Widget _background() {
    return Container(
      alignment: Alignment.center,
      color: Colors.green,
    );
  }

  Widget _body(bool isGetList) {
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
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              // 这里的占比是根据父容器大小的占比
              Flexible(child: _title(isGetList ? "获取中..." : "正在下载中...")),
              Flexible(child: isGetList ? Container() : DownloadList()),
            ],
          ),
        ),
      ),
    );
  }

  Widget _title(String title) {
    return Container(
      padding: EdgeInsets.fromLTRB(20, 10, 0, 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            child: Text(
              title,
              style: TextStyle(fontSize: 16),
            ),
          ),
        ],
      ),
    );
  }

  ///
}

class DownloadList extends StatefulWidget {
  @override
  _DownloadListState createState() => _DownloadListState();
}

class _DownloadListState extends State<DownloadList> {
  ///

  @override
  void initState() {
    super.initState();
    getData();
  }

  void getData() async {
    bool isAllDownloaded = true;
    for (var i = 0; i < context.read<InitDownloadController>().baseDownloadModuleGroupUse.length; i++) {
      GetDataResultType resultType = GetDataResultType.fail;
      for (var repeat = 0; repeat < 5; repeat++) {
        context.read<InitDownloadController>().baseDownloadModuleGroupUse[i].setDownloadStatus(DownloadStatus.downloading);
        resultType = await context.read<InitDownloadController>().baseDownloadModuleGroupUse[i].getData();
        if (resultType == GetDataResultType.fail) {
          context.read<InitDownloadController>().baseDownloadModuleGroupUse[i].setDownloadStatus(DownloadStatus.repeat);
          await Future.delayed(Duration(seconds: 1));
          context.read<InitDownloadController>().baseDownloadModuleGroupUse[i].setDownloadStatus(DownloadStatus.downloading);
        } else {
          break;
        }
      }
      if (resultType == GetDataResultType.ok) {
        /// TODO: 需要修改 SqliteDownloadStatus
        context.read<InitDownloadController>().baseDownloadModuleGroupUse[i].setDownloadStatus(DownloadStatus.success);
      } else {
        context.read<InitDownloadController>().baseDownloadModuleGroupUse[i].setDownloadStatus(DownloadStatus.fail);
        isAllDownloaded = false;
        break;
      }
    }
    if (isAllDownloaded) {
      GNavigatorPush.pushHomePage(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
      physics: BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
      itemCount: context.read<InitDownloadController>().baseDownloadModuleGroupUse.length,
      itemBuilder: (_, index) {
        return context.read<InitDownloadController>().baseDownloadModuleGroupUse[index].widget;
      },
    );
  }

  ///
}
