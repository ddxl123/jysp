import 'package:jysp/Database/base/DBTableBase.dart';
import 'package:jysp/Database/base/SqliteType.dart';
import 'package:jysp/Database/models/ModelList.dart';

/// 罗列全部被需要的表的 sql 语句
class ParseIntoSqls {
  ///

  /// 罗列针对 sqlite 的 sql create table 语句
  /// sqls --- [key]：表名，[value]：create sql
  Map<String, String> parseIntoSqls() {
    Map<String, String> sqls = {};
    ModelList.models.forEach(
      (model) {
        _parseIntoSql(model, sqls);
      },
    );
    return sqls;
  }

  /// 设置针对 sqlite 的 sql create table 语句
  /// [tableName] 要加 [s]
  void _parseIntoSql(DBTableBase table, Map<String, String> sql) {
    // 解析 table
    String tableName = table.getTableNameInstance;
    Map<String, List<SqliteType>> fields = table.fields;

    // 解析 fields
    String fieldsSql = "";

    fields.forEach(
      (fieldName, fieldTypes) {
        fieldsSql += fieldName;
        fieldTypes.forEach(
          (fieldType) {
            fieldsSql += (" " + fieldType.value);
          },
        );

        // 给每个字段添加结尾逗号
        fieldsSql += ",";
      },
    );

    // 去掉最后一个逗号
    fieldsSql = fieldsSql.substring(0, fieldsSql.length - 1);

    // 存入
    sql[tableName] = "CREATE TABLE $tableName ($fieldsSql)";
  }

  ///
}
