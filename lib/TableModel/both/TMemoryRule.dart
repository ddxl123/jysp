// ignore_for_file: non_constant_identifier_names

import 'package:jysp/TableModel/TableBase.dart';

class TMemoryRule implements Table {
  @override
  String getTableNameInstance = getTableName;

  static String get getTableName => "memory_rules";

  static String get memory_rule_id_m => "memory_rule_id_m";

  static String get memory_rule_id_s => "memory_rule_id_s";

  static String get created_at => Table.created_at;

  static String get updated_at => Table.updated_at;

  @override
  List<List> get fields => [
        Table.x_id_ms_sql(memory_rule_id_m),
        Table.x_id_ms_sql(memory_rule_id_s),
        Table.created_at_sql,
        Table.updated_at_sql,
      ];

  static Map<String, dynamic> toMap(
    String memory_rule_id_m_v,
    String memory_rule_id_s_v,
    int created_at_v,
    int updated_at_v,
  ) {
    return {
      memory_rule_id_m: memory_rule_id_m_v,
      memory_rule_id_s: memory_rule_id_s_v,
      created_at: created_at_v,
      updated_at: updated_at_v,
    };
  }
}
