import 'dart:io';

import 'package:flutter/material.dart';
import 'package:jysp/Database/DBTableBase.dart';
import 'package:jysp/Database/local/TToken.dart';
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
mixin CommonTools on Root, TableToSql {
  ///

  /// 获取全部的表
  Future<List<String>> _getAllTableNames() async {
    var tableNames = (await db.query('sqlite_master', where: 'type = ?', whereArgs: ['table'])).map((row) => row['name'] as String).toList(growable: false)..sort();
    return tableNames;
  }

  /// 清空指定表，并非删除表
  /// - [return] 返回删除的行数量
  Future<int> clearTable(String tableName) async {
    return await db.delete(tableName);
  }

  /// 删除数据库并重新创建数据库，清空所有非默认的表，并非重置
  Future<void> clearSqlite() async {
    List<String> logGetAllTableNamesBefore = await _getAllTableNames();
    dLog(() => "清空前的表：" + logGetAllTableNamesBefore.toString());
    await deleteDatabase(dbPathRoot + dbName).whenComplete(() => dLog(() => "清空全部的表成功"));
    // db.close(); // 当数据库被删除时，执行关闭也会提示 err
    db = await openDatabase(dbPathRoot + dbName);
    List<String> logGetAllTableNamesAfter = await _getAllTableNames();
    dLog(() => "清空后的表：" + logGetAllTableNamesAfter.toString());
  }

  /// 创建指定表
  Future<void> _createTable(String tableName) async {
    return await db.execute(sql[tableName]);
  }

  /// 创建全部需要的表
  Future<void> _createAllTables() async {
    await Future.forEach(sql.keys, (tableName) {
      return _createTable(tableName);
    });
  }
}

/// 诊断工具
mixin DiagTools on Root, TableToSql, CommonTools {
  ///

  /// 检测数据库是否存在
  Future<bool> _isExistDbFile() async {
    return await File(dbPathRoot + dbName).exists();
  }

  // 检查指定表是否存在
  Future<bool> isTableExist(String table) async {
    var count = firstIntValue(await db.query('sqlite_master', columns: ['COUNT(*)'], where: 'type = ? AND name = ?', whereArgs: ['table', table]));
    if (count > 0) {
      return true;
    } else {
      return false;
    }
  }

  /// 检测 sqlite 是否已经【应用初始化】过：
  /// 1.需要的表只要存在至少一个，即被视为【应用初始化】已被执行过
  Future<bool> _isAppInited() async {
    List<String> tableNames = await _getAllTableNames();
    List<String> neededSqls = sql.keys.toList();
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
    List<String> neededSqls = sql.keys.toList();
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

mixin Token on Root {
  ///

  /// 从 sqlite 中获取 access_token 或 refresh_token。
  ///
  /// 无论是否失败，或是否为 null，都要将请求发送出去，以便能拿到可使用的 tokens。
  ///
  /// 该请求不会抛出任何 err。
  ///
  /// - [tokenType]:
  ///   - [0]: access_token
  ///   - [1]: refresh_token
  /// - [return]: string ,不能返回 null, 因为 ""+null 会报错
  ///
  Future<String> getSqliteToken({@required int tokenTypeCode}) async {
    String tokenType = tokenTypeCode == 0 ? "access_token" : (tokenTypeCode == 1 ? "refresh_token" : null);
    String token;
    try {
      token = (await db.query(TToken.getTableName))[0][tokenType];
    } catch (e) {
      // 获取失败。可能是 query 失败，也可能是 [0] 值为 null
      token = null;
    }
    dLog(() => "从 sqlite 中获取 $tokenType 的结果：", () => token.toString());
    // 不能返回 null, 因为 ""+null 会报错
    return token ?? "";
  }

  /// 在 sqlite 存储 access_token 和 refresh_token
  ///
  /// - [tokens]: 需要存储的 access_token 和 refresh_token。
  /// - [success]: 存储成功的回调。**注意:返回的结果可以是 Future, 函数内部已嵌套 await**
  /// - [fail]: 存储失败的回调。**注意:返回的结果可以是 Future, 函数内部已嵌套 await**
  ///   - [failCode]: [1]: tokens 值为 null。 [2]: tokens sqlite 存储失败。
  ///
  Future<void> setSqliteToken({
    @required Map tokens,
    @required Function() success,
    @required Function(int failCode) fail,
  }) async {
    if (tokens[TToken.access_token] == null || tokens[TToken.refresh_token] == null) {
      await fail(1);
      dLog(() => "响应的 tokens 数据异常!");
    } else {
      dLog(() => "响应的 tokens 数据正常!");

      // 先清空表，再插入
      await db.transaction(
        (txn) async {
          await txn.delete(TToken.getTableName);
          await txn.insert(TToken.getTableName, TToken.toMap(tokens[TToken.access_token], tokens[TToken.refresh_token]));
        },
      )
          //
          .then((onValue) async {
        await success();
        List<Map> queryResult = await db.query(TToken.getTableName);
        dLog(() => "sqlite 查询 tokens 成功：", () => queryResult);
      })
          //
          .catchError((onError) async {
        await fail(2);
        dLog(() => "token sqlite 存储失败");
      });
    }
  }

  ///
}

class GSqlite with Root, TableToSql, CommonTools, DiagTools, Token {
  ///

  /// 初始化 Sqlite
  Future<SqliteDamagedResult> init() async {
    /// 罗列全部被需要的表的 sql 语句
    toSetSql();

    /// 打开 sqlite 数据库
    dbPathRoot = await getDatabasesPath();
    String dbPath = dbPathRoot + dbName;
    db = await openDatabase(dbPath);

    await clearSqlite();

    /// 检测是否数据损坏
    SqliteDamagedResult sqliteDamagedResult = await _isSqliteDamaged();
    if (sqliteDamagedResult != SqliteDamagedResult.notDamaged) {
      return sqliteDamagedResult;
    }

    /// 检测是否已经【应用初始化】过
    if (!await _isAppInited()) {
      await _createAllTables();
      dLog(() => "应用初始化成功。");
    } else {
      dLog(() => "应用已被初始化过。");
    }

    // await db.insert(TFragmentPoolNodes.getTableName, TFragmentPoolNodes.toMap(1, 2, "0-0-0", "哈哈哈哈"));
    List<String> getResult = await _getAllTableNames();
    dLog(() => "sqlite 包含的表：" + getResult.toString());

    return SqliteDamagedResult.notDamaged;
  }

  ///
}
