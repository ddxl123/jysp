// ignore_for_file: non_constant_identifier_names
// ignore_for_file: unused_element

import 'package:jysp/Table/both/TFragmentPoolNodes.dart';
import 'package:jysp/Table/both/TFragments.dart';
import 'package:jysp/Table/both/TMemoryRules.dart';
import 'package:jysp/Table/both/TRs.dart';
import 'package:jysp/Table/both/TSeparateRules.dart';
import 'package:jysp/Table/both/TUsers.dart';

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
        return "AUTOINCREMENT";
      default:
        throw Exception("Unknown value!");
    }
  }
}

/// 罗列全部被需要的表的 sql 语句
mixin TableToSql {
  ///

  /// 针对 sqlite 的 sql create table 语句
  /// [key]：表名，[value]：create sql
  Map<String, String> sql = {};

  /// 罗列针对 sqlite 的 sql create table 语句
  void toSetSql() {
    sql.clear();
    _tableToSql(TUsers());
    _tableToSql(TSeparateRules());
    _tableToSql(TMemoryRules());
    _tableToSql(TFragments());
    _tableToSql(TFragmentPoolNodes());
    _tableToSql(TRs());
  }

  /// 设置针对 sqlite 的 sql create table 语句
  /// [tableName] 要加 [s]
  void _tableToSql(Table table) {
    /// 解析 table
    String tableName = table.getTableNameInstance;
    List<List<dynamic>> fields = table.fields;

    /// 去掉后缀的 s
    String tableNameNoS = tableName.substring(0, tableName.length - 1);

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

    /// 存入
    sql[tableName] = """
      CREATE TABLE $tableName (
      ${tableNameNoS}_id_m ${SqliteType.TEXT.value} ${SqliteType.UNIQUE.value},
      ${tableNameNoS}_id_s ${SqliteType.TEXT.value} ${SqliteType.UNIQUE.value},
      $fieldsSql
      created_at ${SqliteType.INTEGER.value},
      updated_at ${SqliteType.INTEGER.value}
      )
    """;
  }

  ///
}

abstract class Table {
  List<List<dynamic>> get fields;
  String getTableNameInstance;

  static String get created_at => "created_at";

  static String get updated_at => "updated_at";

  /// 对于主键：
  /// _m sqlite:TEXT(存AIID) 可不唯一 可为空, mysql:BIGINT(设AIID) 主键 不为空 无符号 自增
  /// _s sqlite:TEXT(设UUID) 唯一 可为空, mysql:CHAR(20)(存UUID) 唯一 可为空
  static List x_id_ms_sql(String x_id_x) {
    if (x_id_x[x_id_x.length - 1] == "m") {
      return [x_id_x, SqliteType.TEXT];
    } else if (x_id_x[x_id_x.length - 1] == "s") {
      return [x_id_x, SqliteType.TEXT, SqliteType.UNIQUE];
    } else {
      throw "no m or s";
    }
  }

  ///
  /// 对于非主键：
  /// _m sqlite:TEXT(存AIID) 可不唯一 可为空, mysql:BIGINT(存AIID) 可不唯一 可为空
  /// _s sqlite:TEXT(存UUID) 可不唯一 可为空, mysql:CHAR(20)(存UUID) 可不唯一 可为空
  static List x_id_ms_sql_nopk(String x_id_x) => [x_id_x, SqliteType.TEXT];

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
class TExamples implements Table {
  @override
  String getTableNameInstance = getTableName;

  static String get getTableName => "examples";

  static String get _id_m => "_id_m";

  static String get _id_s => "_id_s";

  static String get created_at => Table.created_at;

  static String get updated_at => Table.updated_at;

  @override
  List<List> get fields => [
        Table.x_id_ms_sql(_id_m),
        Table.x_id_ms_sql(_id_s),
        Table.created_at_sql,
        Table.updated_at_sql,
      ];

  static Map<String, dynamic> toMap(
    String _id_m_v,
    String _id_s_v,
    int created_at_v,
    int updated_at_v,
  ) {
    return {
      _id_m: _id_m_v,
      _id_s: _id_s_v,
      created_at: created_at_v,
      updated_at: updated_at_v,
    };
  }
}
