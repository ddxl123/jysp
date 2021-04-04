import 'package:jysp/AppInit/AppVersionManager.dart';
import 'package:jysp/Database/models/MDownloadModule.dart';
import 'package:jysp/Database/models/MVersionInfo.dart';
import 'package:jysp/Database/models/ModelList.dart';
import 'package:jysp/G/GSqlite/GSqlite.dart';
import 'package:jysp/G/GSqlite/ParseIntoSqls.dart';
import 'package:jysp/G/GSqlite/SqliteDiag.dart';
import 'package:jysp/G/GSqlite/SqliteTools.dart';
import 'package:sqflite/sqflite.dart';

enum AppInitStatus {
  ok,
  tableLost,
  initialized,
}

class AppInit {
  ///

  static bool _isAppInited = false;

  /// 注意先后顺序
  /// - [return]: [AppInitStatus] or [VersionStatus]
  Future<Object> appInit() async {
    if (_isAppInited) {
      return AppInitStatus.initialized;
    }
    _isAppInited = true;

    // 解析全部需要的表的 Sql 语句
    Map<String, String> sqls = ParseIntoSqls().parseIntoSqls();

    // 打开数据库
    await GSqlite.openDb();

    // TODO: 先清空，发布版本需要去除
    await SqliteTools().clearSqlite();

    // 检查应用是否第一次被打开: 根据 [version_info] 表是否存在进行检查
    if (await SqliteDiag().isTableExist(MVersionInfo.getTableName)) {
      return _notFirstInit(sqls);
    } else {
      return _firstInit(sqls);
    }
  }

  /// 第一次打开应用
  Future<Object> _firstInit(Map<String, String> sqls) async {
    // 1. 创建全部的表
    await SqliteTools().clearSqlite();
    await SqliteTools().createAllTables(sqls);

    // 2. 创建 [version_infos] 信息
    await GSqlite.db.update(
      MVersionInfo.getTableName,
      MVersionInfo.toMap(
        saved_version_v: (await AppVersionManager().getCurrentAppVersion()),
        created_at_v: DateTime.now().millisecondsSinceEpoch,
        updated_at_v: DateTime.now().millisecondsSinceEpoch,
      ),
    );

    // 3. 为 [download_modules] 表生成 baseModules
    Batch batch = GSqlite.db.batch();
    for (int i = 0; i < ModelList.downloadBaseModules.length; i++) {
      batch.insert(
        MDownloadModule.getTableName,
        MDownloadModule.toMap(
          module_name_v: ModelList.downloadBaseModules[i],
          download_is_ok_v: 0,
          created_at_v: DateTime.now().millisecondsSinceEpoch,
          updated_at_v: DateTime.now().millisecondsSinceEpoch,
        ),
      );
    }
    await batch.commit();
    return AppInitStatus.ok;
  }

  /// 不是第一次打开应用. 注意先后顺序
  Future<Object> _notFirstInit(Map<String, String> sqls) async {
    // 检查 app 版本的准确性
    VersionStatus versionStatus = await AppVersionManager().appVersionCheck();
    if (versionStatus != VersionStatus.keep) {
      return versionStatus;
    }

    // 检查数据库表是否准确
    if (!await SqliteDiag().isTableComplete(sqls)) {
      return AppInitStatus.tableLost;
    }

    return AppInitStatus.ok;
  }

  ///
}
