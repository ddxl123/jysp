import 'package:flutter/material.dart';
import 'package:jysp/Database/models/MDownloadModule.dart';
import 'package:jysp/MVC/Views/InitDownloadPage/Extension.dart';

enum DownloadStatus { waiting, downloading, success, fail, repeat }

class DownloadModule {
  /// 因为前三个对 MDownloadQueueModule 来说可能获取为空（即使必然不为空）
  DownloadModule({required this.moduleName, required this.getData}) {
    this.widget = _setWidget();
  }

  ///
  /// 对应 [MDownloadQueueModule] 部分
  ///
  String moduleName;

  /// TODO: 待定
  SqliteDownloadStatus? sqliteDownloadStatus;

  ///
  /// 其它部分
  ///
  int downloadProgress = 0;
  Function(Function()) setState = (_) {};
  Future<GetDataResultType> Function() getData;

  DownloadStatus downloadStatus = DownloadStatus.waiting;
  void setDownloadStatus(DownloadStatus ds) {
    downloadStatus = ds;
    setState(() {});
  }

  /// 必须是一个对象，不能是一个函数调用
  late Widget widget;

  Future<void> changeSqliteDownloadStatus() async {}

  Widget _setWidget() {
    return StatefulBuilder(
      builder: (BuildContext context, rebuild) {
        if (!(this.setState == rebuild)) {
          this.setState = rebuild;
        }
        switch (downloadStatus) {
          case DownloadStatus.waiting:
            return _row(moduleName, Text("等待中..."));
          case DownloadStatus.downloading:
            return _row(moduleName, TextButton(onPressed: () {}, child: Text(downloadProgress.toString() + " %")));
          case DownloadStatus.repeat:
            return _row(moduleName, Text("重试中..."));
          case DownloadStatus.fail:
            return _row(moduleName, Text("下载失败"));
          case DownloadStatus.success:
            return _row(moduleName, Text("下载成功"));
          default:
            throw "downloadStatus${downloadStatus.toString()}";
        }
      },
    );
  }

  Widget _row(String moduleName, Widget selectWidget) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(child: Text(moduleName)),
        selectWidget,
      ],
    );
  }

  String moduleNameString() {
    return moduleName.toString();
  }

  @override
  String toString() {
    return {
      MDownloadModule.module_name: moduleName,
      MDownloadModule.download_status: sqliteDownloadStatus,
      "downloadProgress": downloadProgress,
    }.toString();
  }
}
