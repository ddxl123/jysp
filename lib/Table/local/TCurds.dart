// ignore_for_file: non_constant_identifier_names

import 'package:jysp/Table/TableBase.dart';

// 此表为 null 时, 删除该表并重建, 因为需要把 sort_id 重置。
// 本表某字段对应的 table_field_id 不存在且 curd 不为 [删] 时, 或table_name 不存在时, 直接执行数据损坏任务删除数据库并重建。

class TCurds implements Table {
  @override
  String getTableNameInstance = getTableName;

  static String get getTableName => "curds";

  static String get sort_id => "sort_id";

  static String get table_name => "table_name";

  static String get table_field_id => "table_field_id";

  static String get curd => "curd";

  @override
  List<List> get fields => [
        [sort_id, SqliteType.INTEGER, SqliteType.PRIMARY_KEY, SqliteType.NOT_NULL, SqliteType.UNSIGNED, SqliteType.AUTOINCREMENT],
        [table_name, SqliteType.TEXT],
        [table_field_id, SqliteType.TEXT],
        [curd, SqliteType.INTEGER],
      ];

  static Map<String, dynamic> toMap(
    String sort_id_v,
    String table_name_v,
    int table_field_id_v,
    int curd_v,
  ) {
    return {
      sort_id: sort_id_v,
      table_name: table_name_v,
      table_field_id: table_field_id_v,
      curd: curd_v,
    };
  }
}
