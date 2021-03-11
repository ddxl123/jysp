// ignore_for_file: non_constant_identifier_names
// ignore_for_file: unused_element

import 'package:jysp/Database/both/TFragment.dart';
import 'package:jysp/Database/both/TFragmentPoolNode.dart';
import 'package:jysp/Database/both/TMemoryRule.dart';
import 'package:jysp/Database/both/TSeparateRule.dart';
import 'package:jysp/Database/both/TTest.dart';
import 'package:jysp/Database/both/TUser.dart';
import 'package:jysp/Database/local/TCurd.dart';
import 'package:jysp/Database/local/TToken.dart';

enum SqliteType { TEXT, INTEGER, UNIQUE, PRIMARY_KEY, NOT_NULL, UNSIGNED, AUTOINCREMENT }

extension SqliteTypeValue on SqliteType {
  String get value {
    switch (this.index) {
      case 0:
        return "TEXT";
      case 1:
        return "INTEGER";
      case 2:
        return "UNIQUE";
      case 3:
        return "PRIMARY_KEY";
      case 4:
        return "NOT_NULL";
      case 5:
        return "UNSIGNED";
      case 6:
        return "AUTO_INCREMENT";
      default:
        throw Exception("Unknown value!");
    }
  }
}

/// 罗列全部被需要的表的 sql 语句
mixin TableToSql {
  ///

  /// 针对 sqlite 的 sql create table 语句
  /// [key]：表名，[value]：create sqls
  Map<String, String> sql = {};

  /// 罗列针对 sqlite 的 sql create table 语句
  void toSetSql() {
    sql.clear();
    _tableToSql(TFragment());
    _tableToSql(TFragmentPoolNode());
    _tableToSql(TMemoryRule());
    _tableToSql(TSeparateRule());
    _tableToSql(TUser());
    _tableToSql(TCurd());
    _tableToSql(TToken());
    _tableToSql(TTest());
  }

  /// 设置针对 sqlite 的 sql create table 语句
  /// [tableName] 要加 [s]
  void _tableToSql(DBTableBase table) {
    /// 解析 table
    String tableName = table.getTableNameInstance;
    List<List<dynamic>> fields = table.fields;

    /// 解析 fields
    String fieldsSql = "";
    fields.forEach((field) {
      for (int i = 0; i < field.length; i++) {
        if (i == 0) {
          /// 第一个角标为 field 名
          fieldsSql += field[0];
        } else {
          fieldsSql += (" " + (field[i] as SqliteType).value);
        }
      }

      /// 给每个字段添加结尾逗号
      fieldsSql += ",";
    });

    /// 去掉最后一个逗号
    fieldsSql = fieldsSql.substring(0, fieldsSql.length - 1);

    /// 存入
    sql[tableName] = """
      CREATE TABLE $tableName (
      $fieldsSql
      )
    """;
  }

  ///
}

abstract class DBTableBase {
  List<List<dynamic>> get fields;
  String getTableNameInstance = "";

  static String get created_at => "created_at";

  static String get updated_at => "updated_at";

  /// 非主键
  /// _m sqlite:INTEGER(存AIID) 可为空, [mysql:BIGINT](设AIID) 主键 不为空 无符号 自增
  static List x_id_m_no_primary(String x_id) => [x_id, SqliteType.INTEGER, SqliteType.UNIQUE];

  /// 非主键
  /// _s sqlite:TEXT(设UUID) 可为空
  static List x_id_s_no_primary(String x_id_s) => [x_id_s, SqliteType.TEXT, SqliteType.UNIQUE];

  /// 主键
  /// sqlite 自增
  static List x_id_primary(String x_id) => [x_id, SqliteType.AUTOINCREMENT, SqliteType.PRIMARY_KEY];

  static List get created_at_sql => [created_at, SqliteType.INTEGER, SqliteType.NOT_NULL, SqliteType.UNSIGNED];

  static List get updated_at_sql => [updated_at, SqliteType.INTEGER, SqliteType.NOT_NULL, SqliteType.UNSIGNED];
}

///
///
///
// 1. 请尽快将数据同步至云端, 以防本地数据出现差错, 最终导致全部数据被清空重置。
// 2. 每次 CURD sqlite 都要识别一次当前表是否存在。
// 3. 应用初始化：创建全部需要的表。若【已有表数量】==0，则为初始化；若 0<【已有表数量】<【需求表数量】，则【本地数据损坏】；若【已有表数量】==【需求表数量】，则本地数据正常
// 4. 模块初始化：整体式模块、分离式模块。
// 5. 改变 state 时，读取时只读取 sqlite。
///
///
///

///
///
///
/// 例子
class TExamples implements DBTableBase {
  @override
  String getTableNameInstance = getTableName;

  static String get getTableName => "examples";

  static String get _id => "_id";

  static String get _id_s => "_id_s";

  static String get created_at => DBTableBase.created_at;

  static String get updated_at => DBTableBase.updated_at;

  @override
  List<List> get fields => [
        DBTableBase.x_id_m_no_primary(_id),
        DBTableBase.x_id_s_no_primary(_id_s),
        DBTableBase.created_at_sql,
        DBTableBase.updated_at_sql,
      ];

  static Map<String, dynamic> toMap(
    String _id_v,
    String _id_s_v,
    int created_at_v,
    int updated_at_v,
  ) {
    return {
      _id: _id_v,
      _id_s: _id_s_v,
      created_at: created_at_v,
      updated_at: updated_at_v,
    };
  }
}
