// ignore_for_file: non_constant_identifier_names

import 'package:jysp/Database/DBTableBase.dart';

class TSeparateRule implements DBTableBase {
  @override
  String getTableNameInstance = getTableName;

  static String get getTableName => "separate_rules";

  static String get separate_rule_id => "separate_rule_id";

  static String get separate_rule_id_s => "separate_rule_id_s";

  static String get created_at => DBTableBase.created_at;

  static String get updated_at => DBTableBase.updated_at;

  @override
  List<List> get fields => [
        DBTableBase.x_id_m_no_primary(separate_rule_id),
        DBTableBase.x_id_s_no_primary(separate_rule_id_s),
        DBTableBase.created_at_sql,
        DBTableBase.updated_at_sql,
      ];

  static Map<String, dynamic> toMap(
    int separate_rule_id_v,
    String separate_rule_id_s_v,
    int created_at_v,
    int updated_at_v,
  ) {
    return {
      separate_rule_id: separate_rule_id_v,
      separate_rule_id_s: separate_rule_id_s_v,
      created_at: created_at_v,
      updated_at: updated_at_v,
    };
  }
}
