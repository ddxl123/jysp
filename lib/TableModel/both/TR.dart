// ignore_for_file: non_constant_identifier_names

import 'package:jysp/TableModel/TableBase.dart';

class TR implements Table {
  @override
  String getTableNameInstance = getTableName;

  static String get getTableName => "rs";

  static String get r_id_m => "r_id_m";

  static String get r_id_s => "r_id_s";

  static String get collector_id_m => "collector_id_m";

  static String get collector_id_s => "collector_id_s";

  static String get fragment_id_m => "fragment_id_m";

  static String get fragment_id_s => "fragment_id_s";

  static String get fragment_creator_id_m => "fragment_creator_id_m";

  static String get fragment_creator_id_s => "fragment_creator_id_s";

  static String get fragment_pool_node_id_m => "fragment_pool_node_id_m";

  static String get fragment_pool_node_id_s => "fragment_pool_node_id_s";

  static String get fragment_pool_node_creator_id_m => "fragment_pool_node_creator_id_m";

  static String get fragment_pool_node_creator_id_s => "fragment_pool_node_creator_id_s";

  static String get memory_rule_id_m => "memory_rule_id_m";

  static String get memory_rule_id_s => "memory_rule_id_s";

  static String get memory_rule_creator_id_m => "memory_rule_creator_id_m";

  static String get memory_rule_creator_id_s => "memory_rule_creator_id_s";

  static String get separate_rule_id_m => "separate_rule_id_m";

  static String get separate_rule_id_s => "separate_rule_id_s";

  static String get separate_rule_creator_id_m => "separate_rule_creator_id_m";

  static String get separate_rule_creator_id_s => "separate_rule_creator_id_s";

  static String get created_at => Table.created_at;

  static String get updated_at => Table.updated_at;

  @override
  List<List> get fields => [
        Table.x_id_ms_sql(r_id_m),
        Table.x_id_ms_sql(r_id_s),
        Table.x_id_ms_sql_nopk(collector_id_m),
        Table.x_id_ms_sql_nopk(collector_id_s),
        Table.x_id_ms_sql_nopk(fragment_id_m),
        Table.x_id_ms_sql_nopk(fragment_id_s),
        Table.x_id_ms_sql_nopk(fragment_creator_id_m),
        Table.x_id_ms_sql_nopk(fragment_creator_id_s),
        Table.x_id_ms_sql_nopk(fragment_pool_node_id_m),
        Table.x_id_ms_sql_nopk(fragment_pool_node_id_s),
        Table.x_id_ms_sql_nopk(fragment_pool_node_creator_id_m),
        Table.x_id_ms_sql_nopk(fragment_pool_node_creator_id_s),
        Table.x_id_ms_sql_nopk(memory_rule_id_m),
        Table.x_id_ms_sql_nopk(memory_rule_id_s),
        Table.x_id_ms_sql_nopk(memory_rule_creator_id_m),
        Table.x_id_ms_sql_nopk(memory_rule_creator_id_s),
        Table.x_id_ms_sql_nopk(separate_rule_id_m),
        Table.x_id_ms_sql_nopk(separate_rule_id_s),
        Table.x_id_ms_sql_nopk(separate_rule_creator_id_m),
        Table.x_id_ms_sql_nopk(separate_rule_creator_id_s),
        Table.created_at_sql,
        Table.updated_at_sql,
      ];

  static Map<String, dynamic> toMap(
    String r_id_m_v,
    String r_id_s_v,
    String collector_id_m_v,
    String collector_id_s_v,
    String fragment_id_m_v,
    String fragment_id_s_v,
    String fragment_creator_id_m_v,
    String fragment_creator_id_s_v,
    String fragment_pool_node_id_m_v,
    String fragment_pool_node_id_s_v,
    String fragment_pool_node_creator_id_m_v,
    String fragment_pool_node_creator_id_s_v,
    String memory_rule_id_m_v,
    String memory_rule_id_s_v,
    String memory_rule_creator_id_m_v,
    String memory_rule_creator_id_s_v,
    String separate_rule_id_m_v,
    String separate_rule_id_s_v,
    String separate_rule_creator_id_m_v,
    String separate_rule_creator_id_s_v,
    int created_at_v,
    int updated_at_v,
  ) {
    return {
      r_id_m: r_id_m_v,
      r_id_s: r_id_s_v,
      collector_id_m: collector_id_m_v,
      collector_id_s: collector_id_s_v,
      fragment_id_m: fragment_id_m_v,
      fragment_id_s: fragment_id_s_v,
      fragment_creator_id_m: fragment_creator_id_m_v,
      fragment_creator_id_s: fragment_creator_id_s_v,
      fragment_pool_node_id_m: fragment_pool_node_id_m_v,
      fragment_pool_node_id_s: fragment_pool_node_id_s_v,
      fragment_pool_node_creator_id_m: fragment_pool_node_creator_id_m_v,
      fragment_pool_node_creator_id_s: fragment_pool_node_creator_id_s_v,
      memory_rule_id_m: memory_rule_id_m_v,
      memory_rule_id_s: memory_rule_id_s_v,
      memory_rule_creator_id_m: memory_rule_creator_id_m_v,
      memory_rule_creator_id_s: memory_rule_creator_id_s_v,
      separate_rule_id_m: separate_rule_id_m_v,
      separate_rule_id_s: separate_rule_id_s_v,
      separate_rule_creator_id_m: separate_rule_creator_id_m_v,
      separate_rule_creator_id_s: separate_rule_creator_id_s_v,
      created_at: created_at_v,
      updated_at: updated_at_v,
    };
  }
}
