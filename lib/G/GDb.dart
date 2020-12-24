import 'dart:math';

import 'package:jysp/Tools/Toast.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite/utils/utils.dart';

class GDb {
  Database db;
  String dbPath = "/jysp.db";
  String tableName = 'user';

  Map<String, String> _tablesNeededSql = {
    "tb_name": """
    CREATE TABLE tb_name (
    id INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT UNIQUE,
    orderId Text NOT NULL,
    type TEXT NOT NULL);
    """,
  };

  /// 每次启动应用，
  /// 先用SP检测是否第一次启动应用
  Future init(List<String> tableNames) async {
    String databasesPath = await getDatabasesPath();
    String path = databasesPath + dbPath;
    db = await openDatabase(path);

    /// 检查需要的表是否存在，不存在则创建
    tableNames.forEach((item) {
      _tableIsExist(item);
    });
  }

  // 检查指定表是否存在, 若不存在则创建
  void _tableIsExist(String table) async {
    var count = firstIntValue(await db.query('sqlite_master', columns: ['COUNT(*)'], where: 'type = ? AND name = ?', whereArgs: ['table', table]));
    if (count == 0) {
      await db.execute(_tablesNeededSql[table]);
    }
  }

  /// 获取当前数据库中所有的表
  Future<List<String>> getTableNames() async {
    var tableNames = (await db.query('sqlite_master', where: 'type = ?', whereArgs: ['table'])).map((row) => row['name'] as String).toList(growable: false)..sort();
    return tableNames;
  }
}

class User {
  int tid;
  String uid;
  String username;
  String phone;
  String pwd;
  String hh;
  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      'uid': uid,
      'username': username,
      'phone': phone,
      'password': pwd,
      'heart': hh,
    };
    if (tid != null) {
      map['id'] = tid;
    }
    return map;
  }

  User();
  User.fromMap(Map<String, dynamic> map) {
    tid = map['id'];
    uid = map['uid'].toString();
    username = map['username'];
    phone = map['phone'].toString();
    pwd = map['password'];
    hh = map['heart'].toString();
  }
}
