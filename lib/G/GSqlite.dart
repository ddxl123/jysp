import 'dart:io';

import 'package:jysp/G/GSqliteField.dart';
import 'package:jysp/Tools/TDebug.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite/utils/utils.dart';

enum SqliteDamagedResult { notDamaged, notExistDbFile, tableLost }

mixin Root {
  Database db;
  String dbPathRoot;
  String dbName = "/jysp.db";
}

/// 通用工具
mixin CommonTools on Root, TablesNeededSql {
  ///

  /// 获取全部的表
  Future<List<String>> _getAllTableNames() async {
    var tableNames = (await db.query('sqlite_master', where: 'type = ?', whereArgs: ['table'])).map((row) => row['name'] as String).toList(growable: false)..sort();
    return tableNames;
  }

  /// 删除指定的表
  Future<void> _removeTable(String tableName) async {
    return await db.execute("DROP TABLE $tableName");
  }

  /// 删除数据库并重新创建数据库，清空所有非默认的表
  Future<void> removeTables() async {
    dLog("清空前的表：" + (await _getAllTableNames()).toString());
    await deleteDatabase(dbPathRoot + dbName).whenComplete(() => dLog("清空全部的表成功"));
    // db.close(); // 当数据库被删除时，执行关闭也会提示 err
    db = await openDatabase(dbPathRoot + dbName);
    dLog("清空后的表：" + (await _getAllTableNames()).toString());
  }

  /// 创建指定表
  Future<void> _createTable(String tableName) async {
    return await db.execute(createTableNeededSqls[tableName]);
  }

  /// 创建全部需要的表
  Future<void> _createAllTables() async {
    await Future.forEach(createTableNeededSqls.keys, (tableName) {
      return _createTable(tableName);
    });
  }

  ///
}

/// 诊断工具
mixin DiagTools on Root, TablesNeededSql, CommonTools {
  ///

  /// 检测数据库是否存在
  Future<bool> _isExistDbFile() async {
    return await File(dbPathRoot + dbName).exists();
  }

  // 检查指定表是否存在
  Future<bool> _isTableExist(String table) async {
    var count = firstIntValue(await db.query('sqlite_master', columns: ['COUNT(*)'], where: 'type = ? AND name = ?', whereArgs: ['table', table]));
    if (count > 0) {
      return true;
    }
  }

  /// 检测 sqlite 是否已经【应用初始化】过：
  /// 1.需要的表只要存在至少一个，即被视为【应用初始化】已被执行过
  Future<bool> _isAppInited() async {
    List<String> tableNames = await _getAllTableNames();
    List<String> neededSqls = createTableNeededSqls.keys.toList();
    for (int i = 0; i < neededSqls.length; i++) {
      if (tableNames.contains(neededSqls[i])) {
        return true;
      }
    }
    return false;
  }

  /// 检测 sqlite 数据是否损坏：
  /// 需要的表丢失、数据库文件不存在，视为数据损坏
  /// 1.数据库文件不存在，视为数据损坏
  /// 2.需要的表至少有一个不存在且至少有一个存在，视为数据损坏
  Future<SqliteDamagedResult> _isSqliteDamaged() async {
    if (!(await _isExistDbFile())) {
      return SqliteDamagedResult.notExistDbFile;
    }

    List<String> tableNames = await _getAllTableNames();
    List<String> neededSqls = createTableNeededSqls.keys.toList();
    bool isExistOne = false;
    bool isNotExistOne = false;
    for (int i = 0; i < neededSqls.length; i++) {
      if (tableNames.contains(neededSqls[i])) {
        isExistOne = true;
      } else {
        isNotExistOne = true;
      }
    }
    if (isExistOne && isNotExistOne) {
      return SqliteDamagedResult.tableLost;
    } else {
      return SqliteDamagedResult.notDamaged;
    }
  }

  ///
}

class GSqlite with Root, TablesNeededSql, CommonTools, DiagTools {
  ///

  /// 初始化 Sqlite
  Future<SqliteDamagedResult> init() async {
    /// 罗列全部被需要的表的 sql 语句
    toSetCreateTablesNeededSql();

    /// 打开 sqlite 数据库
    dbPathRoot = await getDatabasesPath();
    String dbPath = dbPathRoot + dbName;
    db = await openDatabase(dbPath);

    /// 检测是否数据损坏
    SqliteDamagedResult sqliteDamagedResult = await _isSqliteDamaged();
    if (sqliteDamagedResult != SqliteDamagedResult.notDamaged) {
      return sqliteDamagedResult;
    }

    /// 检测是否已经【应用初始化】过
    if (!await _isAppInited()) {
      await _createAllTables();
      dLog("应用初始化成功。");
    } else {
      dLog("应用已被初始化过。");
    }
    dLog("sqlite 包含的表：" + (await _getAllTableNames()).toString());

    return SqliteDamagedResult.notDamaged;
  }

  ///
}
