// ignore_for_file: non_constant_identifier_names

import 'package:jysp/Database/DBTableBase.dart';

class TFragment implements DBTableBase {
  @override
  String getTableNameInstance = getTableName;

  static String get getTableName => "fragments";

  static String get fragment_id => "fragment_id";

  static String get fragment_id_s => "fragment_id_s";

  static String get text => "text";

  static String get created_at => DBTableBase.created_at;

  static String get updated_at => DBTableBase.updated_at;

  @override
  List<List> get fields => [
        DBTableBase.x_id_m_no_primary(fragment_id),
        DBTableBase.x_id_s_no_primary(fragment_id_s),
        [text, SqliteType.TEXT], // mysql:VARCHAR(255)
        DBTableBase.created_at_sql,
        DBTableBase.updated_at_sql,
      ];

  static Map<String, dynamic> toMap(
    int fragment_id_v,
    String fragment_id_s_v,
    String text_v,
    int created_at_v,
    int updated_at_v,
  ) {
    return {
      fragment_id: fragment_id_v,
      fragment_id_s: fragment_id_s_v,
      text: text_v,
      created_at: created_at_v,
      updated_at: updated_at_v,
    };
  }
}
