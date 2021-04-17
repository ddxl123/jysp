import 'package:flutter/cupertino.dart';
import 'package:jysp/Database/models/MDownloadModule.dart';
import 'package:jysp/G/GSqlite/GSqlite.dart';
import 'package:jysp/MVC/Models/InitDownloadRequest/InitDownloadRequest.dart';
import 'package:jysp/MVC/Views/InitDownloadPage/DownloadModule.dart';
import 'package:jysp/MVC/Views/InitDownloadPage/Extension.dart';
import 'package:sqflite/sqflite.dart';

class InitDownloadController extends ChangeNotifier {
  ///

  List<MDownloadModule> downloadModuleModels = [];
  List<String> downloadModuleModelModuleNames = [];

  List<DownloadModule> baseDownloadModuleGroupUse = [];
  List<DownloadModule> baseDownloadModuleGroup = [
    DownloadModule(
      moduleName: "用户信息",
      getData: () async {
        return await InitDownloadRequest().getUserInfo();
      },
    ),
    DownloadModule(
      moduleName: "待定池的全部节点",
      getData: () async {
        return await InitDownloadRequest().getPendingPoolNodes();
      },
    ),
    DownloadModule(
      moduleName: "记忆池的全部节点",
      getData: () async {
        return await InitDownloadRequest().getMemoryPoolNodes();
      },
    ),
    DownloadModule(
      moduleName: "完成池的全部节点",
      getData: () async {
        return await InitDownloadRequest().getCompletePoolNodes();
      },
    ),
    DownloadModule(
      moduleName: "规则池的全部节点",
      getData: () async {
        return await InitDownloadRequest().getRulePoolNodes();
      },
    ),
    DownloadModule(
      moduleName: "待定池的全部碎片",
      getData: () async {
        return await InitDownloadRequest().getPendingPoolNodeFragments();
      },
    ),
    DownloadModule(
      moduleName: "记忆池的全部碎片",
      getData: () async {
        return await InitDownloadRequest().getMemoryPoolNodeFragments();
      },
    ),
    DownloadModule(
      moduleName: "完成池的全部碎片",
      getData: () async {
        return await InitDownloadRequest().getCompletePoolNodeFragments();
      },
    ),
    DownloadModule(
      moduleName: "规则池的全部碎片",
      getData: () async {
        return await InitDownloadRequest().getRulePoolNodeFragments();
      },
    ),
  ];

  Future<void> getListFuture() async {
    await Future.delayed(Duration(seconds: 2));
    downloadModuleModels.clear();
    downloadModuleModelModuleNames.clear();
    downloadModuleModels = await MDownloadModule.getAllRowsAsModel();
    downloadModuleModels.forEach(
      (model) {
        downloadModuleModelModuleNames.add(model.get_module_name!);
      },
    );

    await _check();
  }

  /// 检查【基础模型组】与 MDownloadQueueModule 数据表 数据是否一一对应
  Future<void> _check() async {
    // 表示如果查询到 MDownloadQueueModule 表数据为空，则表示应用被下载后第一次被打开。需将【基本模型组】进行初始化。
    if (downloadModuleModels.isEmpty) {
      Batch batch = GSqlite.db.batch();
      baseDownloadModuleGroup.forEach(
        (baseDownloadModule) {
          batch.insert(
            MDownloadModule.getTableName,
            MDownloadModule.toSqliteMap(
              module_name_v: baseDownloadModule.moduleName,
              download_status_v: baseDownloadModule.sqliteDownloadStatus,
              created_at_v: DateTime.now().millisecondsSinceEpoch,
              updated_at_v: DateTime.now().millisecondsSinceEpoch,
            ),
          );
        },
      );
      await batch.commit(continueOnError: false);
      baseDownloadModuleGroupUse.clear();
      baseDownloadModuleGroupUse.addAll(baseDownloadModuleGroup);
      return;
    }

    // 检查【基础模型组】是否与 sqlite 查询到的名称是否完全一致
    //
    // 若不一致，则表示 MDownloadModule 表数据为空(即应用被下载后第一次被打开)，或应用更新使得 baseDownloadModuleGroup 元素被修改。
    if (!(baseDownloadModuleGroup.moduleNamesString() == downloadModuleModelModuleNames.toString())) {
      // 1. 先把被标记已下载过的转移至【基础模型组】
      downloadModuleModels.forEach(
        (moduleModel) {
          baseDownloadModuleGroup.forEach(
            (baseDownloadModule) {
              if (moduleModel.get_module_name == baseDownloadModule.moduleName) {
                baseDownloadModule.sqliteDownloadStatus = moduleModel.get_download_status;
              }
            },
          );
        },
      );

      // 2. 清空 sqlite 的 MDownloadQueueModule 表
      await GSqlite.db.delete(MDownloadModule.getTableName);

      // 3. 重新写入
      Batch batch = GSqlite.db.batch();
      baseDownloadModuleGroup.forEach(
        (baseDownloadModule) {
          batch.insert(
            MDownloadModule.getTableName,
            MDownloadModule.toSqliteMap(
              module_name_v: baseDownloadModule.moduleName,
              download_status_v: baseDownloadModule.sqliteDownloadStatus,
              created_at_v: DateTime.now().millisecondsSinceEpoch,
              updated_at_v: DateTime.now().millisecondsSinceEpoch,
            ),
          );
        },
      );
      await batch.commit(continueOnError: false);
      baseDownloadModuleGroupUse.clear();
      baseDownloadModuleGroupUse.addAll(baseDownloadModuleGroup);
    }

    //
    // 检查到 MDownloadModule 没有被修改时：
    // 应用被关闭后撤销了全部正在下载的状态，因此【初始化过后的重复打开应用】意味着可以直接拉取 MDownloadQueueModule 表中的 isDownloaded 属性内容
    if (baseDownloadModuleGroupUse.isEmpty) {
      downloadModuleModels.forEach(
        (moduleModel) {
          baseDownloadModuleGroup.forEach(
            (baseDownloadModule) {
              if (moduleModel.get_module_name == baseDownloadModule.moduleName) {
                baseDownloadModule.sqliteDownloadStatus = moduleModel.get_download_status;
              }
            },
          );
        },
      );
      baseDownloadModuleGroupUse.clear();
      baseDownloadModuleGroupUse.addAll(baseDownloadModuleGroup);
    }
  }
}
