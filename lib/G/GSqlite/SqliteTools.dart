import 'package:jysp/G/GSqlite/GSqlite.dart';
import 'package:jysp/Tools/TDebug.dart';

/// 通用工具
class SqliteTools {
  ///

  /// 获取全部的表, 不包含 android_metadata
  Future<List<String>> getAllTableNames() async {
    final List<String> tableNames = (await db.query(
      'sqlite_master',
      where: 'type = ?',
      whereArgs: <Object?>['table'],
    ))
        .map((Map<String, Object?> row) => row['name']! as String)
        .toList();
    tableNames.remove('android_metadata');
    return tableNames;
  }

  /// 清空指定表，并非删除表
  /// - [return] 返回删除的行数量
  Future<void> clearTable(String tableName) async {
    await db.execute('DROP TABLE IF EXISTS $tableName');
    return;
  }

  /// 清空数据库
  Future<void> clearSqlite() async {
    dLog(() => '清空前的表：', null, () async => await getAllTableNames());
    final List<String> allTable = await getAllTableNames();
    for (int i = 0; i < allTable.length; i++) {
      await clearTable(allTable[i]);
    }
    // await deleteDatabase(GSqlite.dbPathRoot + GSqlite.dbName).whenComplete(() => dLog(() => "清空全部的表成功"));
    // await openDatabase(GSqlite.dbPathRoot + GSqlite.dbName);
    dLog(() => '清空后的表：', null, () async => await getAllTableNames());
  }

  /// 创建全部需要的表
  Future<void> createAllTables(Map<String, String>? sqls) async {
    await Future.forEach<String>(
      sqls!.keys,
      (String tableName) async {
        return await db.execute(sqls[tableName]!);
      },
    );
    dLog(() => '创建全部需要的表完成：', null, () async => await SqliteTools().getAllTableNames());
  }
}
