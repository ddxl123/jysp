import 'package:jysp/Table/TFragmentPoolNodes.dart';
import 'package:jysp/Table/TFragments.dart';
import 'package:jysp/Table/TMemoryRules.dart';
import 'package:jysp/Table/TRs.dart';
import 'package:jysp/Table/TSeparateRules.dart';
import 'package:jysp/Table/TUsers.dart';

enum SqliteType { TEXT, UNIQUE, INTEGER }

extension SqliteTypeValue on SqliteType {
  String get value {
    switch (this.index) {
      case 0:
        return "TEXT";
      case 1:
        return "UNIQUE";
      case 2:
        return "INTEGER";
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
}
