import 'package:sqflite/sqflite.dart';

class GSqlite {
  ///

  static late final Database db;
  static late final String dbPathRoot;
  static final String dbName = "/jysp.db";

  /// 打开 sqlite 数据库
  static Future<void> openDb() async {
    dbPathRoot = await getDatabasesPath();
    String dbPath = dbPathRoot + dbName;
    db = await openDatabase(dbPath);
  }

  /// 初始化 Sqlite
  // Future<SqliteInitResult> init() async {
  //   try {
  //     // 打开 sqlite 数据库
  //     dbPathRoot = await getDatabasesPath();
  //     String dbPath = dbPathRoot + dbName;
  //     db = await openDatabase(dbPath);

  //     // TODO: 先清空，发布版本需要去除
  //     await sqliteTools.clearSqlite();

  //     // 检测是否数据损坏
  //     SqliteInitResult sqliteDamagedResult = await diagTools.isSqliteDamaged();
  //     if (sqliteDamagedResult != SqliteInitResult.ok) {
  //       return sqliteDamagedResult;
  //     }

  //     await dLog(() => "sqlite 包含的表：", null, () async => await sqliteTools.getAllTableNames());

  //     return SqliteInitResult.ok;
  //   } catch (e) {
  //     dLog(() => e.toString());
  //     return SqliteInitResult.catchError;
  //   }
  // }

  ///
}
