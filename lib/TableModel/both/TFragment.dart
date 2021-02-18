// ignore_for_file: non_constant_identifier_names

import 'package:jysp/TableModel/TableBase.dart';

class TFragment implements Table {
  @override
  String getTableNameInstance = getTableName;

  static String get getTableName => "fragments";

  static String get fragment_id_m => "fragment_id_m";

  static String get fragment_id_s => "fragment_id_s";

  static String get text => "text";

  static String get created_at => Table.created_at;

  static String get updated_at => Table.updated_at;

  @override
  List<List> get fields => [
        Table.x_id_ms_sql(fragment_id_m),
        Table.x_id_ms_sql(fragment_id_s),
        [text, SqliteType.TEXT], // mysql:VARCHAR(255)
        Table.created_at_sql,
        Table.updated_at_sql,
      ];

  static Map<String, dynamic> toMap(
    String fragment_id_m_v,
    String fragment_id_s_v,
    String text_v,
    int created_at_v,
    int updated_at_v,
  ) {
    return {
      fragment_id_m: fragment_id_m_v,
      fragment_id_s: fragment_id_s_v,
      text: text_v,
      created_at: created_at_v,
      updated_at: updated_at_v,
    };
  }
}
