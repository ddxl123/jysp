// ignore_for_file: non_constant_identifier_names

import 'package:jysp/Database/base/DBTableBase.dart';
import 'package:jysp/Database/base/SqliteType.dart';

class MCurd implements DBTableBase {
  @override
  String getTableNameInstance = getTableName;

  static String get getTableName => "curds";

  static String get table => "table";

  static String get row_id => "row_id";

  static String get row_uuid => "row_uuid";

  static String get curd_is_ok => "curd_is_ok";

  static String get created_at => "created_at";

  static String get updated_at => "updated_at";

  @override
  Map<String, List<SqliteType>> get fields => {table: [SqliteType.TEXT], row_id: [SqliteType.INTEGER, SqliteType.UNSIGNED], row_uuid: [SqliteType.TEXT], curd_is_ok: [SqliteType.INTEGER], created_at: [SqliteType.INTEGER, SqliteType.UNSIGNED, SqliteType.NOT_NULL], updated_at: [SqliteType.INTEGER, SqliteType.UNSIGNED, SqliteType.NOT_NULL]};

  static Map<String, dynamic> toMap({required String table_v,required int row_id_v,required String row_uuid_v,required int curd_is_ok_v,required int created_at_v,required int updated_at_v,}
  ) {
    return {table:table_v,row_id:row_id_v,row_uuid:row_uuid_v,curd_is_ok:curd_is_ok_v,created_at:created_at_v,updated_at:updated_at_v,};
  }
}
