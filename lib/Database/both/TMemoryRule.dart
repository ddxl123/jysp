// ignore_for_file: non_constant_identifier_names

import 'package:jysp/Database/DBTableBase.dart';

class TMemoryRule implements DBTableBase {
  @override
  String getTableNameInstance = getTableName;

  static String get getTableName => "memory_rules";

  static String get memory_rule_id => "memory_rule_id";

  static String get memory_rule_id_s => "memory_rule_id_s";

  static String get created_at => DBTableBase.created_at;

  static String get updated_at => DBTableBase.updated_at;

  @override
  List<List> get fields => [
        DBTableBase.x_id_m_no_primary(memory_rule_id),
        DBTableBase.x_id_s_no_primary(memory_rule_id_s),
        DBTableBase.created_at_sql,
        DBTableBase.updated_at_sql,
      ];

  static Map<String, dynamic> toMap(
    int memory_rule_id_v,
    String memory_rule_id_s_v,
    int created_at_v,
    int updated_at_v,
  ) {
    return {
      memory_rule_id: memory_rule_id_v,
      memory_rule_id_s: memory_rule_id_s_v,
      created_at: created_at_v,
      updated_at: updated_at_v,
    };
  }
}
