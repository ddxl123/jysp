import 'package:jysp/Table/TableBase.dart';

class TRs implements Table {
  @override
  String getTableNameInstance = getTableName;

  @override
  List<List> get fields => [
        [collector_id_m, SqliteType.TEXT, SqliteType.UNIQUE],
        [collector_id_s, SqliteType.TEXT, SqliteType.UNIQUE],
        [fragment_id_m, SqliteType.TEXT, SqliteType.UNIQUE],
        [fragment_id_s, SqliteType.TEXT, SqliteType.UNIQUE],
        [fragment_creator_id_m, SqliteType.TEXT, SqliteType.UNIQUE],
        [fragment_creator_id_s, SqliteType.TEXT, SqliteType.UNIQUE],
        [fragment_pool_node_id_m, SqliteType.TEXT, SqliteType.UNIQUE],
        [fragment_pool_node_id_s, SqliteType.TEXT, SqliteType.UNIQUE],
        [fragment_pool_node_creator_id_m, SqliteType.TEXT, SqliteType.UNIQUE],
        [fragment_pool_node_creator_id_s, SqliteType.TEXT, SqliteType.UNIQUE],
        [memory_rule_id_m, SqliteType.TEXT, SqliteType.UNIQUE],
        [memory_rule_id_s, SqliteType.TEXT, SqliteType.UNIQUE],
        [memory_rule_creator_id_m, SqliteType.TEXT, SqliteType.UNIQUE],
        [memory_rule_creator_id_s, SqliteType.TEXT, SqliteType.UNIQUE],
        [separate_rule_id_m, SqliteType.TEXT, SqliteType.UNIQUE],
        [separate_rule_id_s, SqliteType.TEXT, SqliteType.UNIQUE],
        [separate_rule_creator_id_m, SqliteType.TEXT, SqliteType.UNIQUE],
        [separate_rule_creator_id_s, SqliteType.TEXT, SqliteType.UNIQUE],
      ];

  static String get getTableName => "rs";

  // ignore: non_constant_identifier_names
  static String get collector_id_m => "collector_id_m";

  // ignore: non_constant_identifier_names
  static String get collector_id_s => "collector_id_s";

  // ignore: non_constant_identifier_names
  static String get fragment_id_m => "fragment_id_m";

  // ignore: non_constant_identifier_names
  static String get fragment_id_s => "fragment_id_s";

  // ignore: non_constant_identifier_names
  static String get fragment_creator_id_m => "fragment_creator_id_m";

  // ignore: non_constant_identifier_names
  static String get fragment_creator_id_s => "fragment_creator_id_s";

  // ignore: non_constant_identifier_names
  static String get fragment_pool_node_id_m => "fragment_pool_node_id_m";

  // ignore: non_constant_identifier_names
  static String get fragment_pool_node_id_s => "fragment_pool_node_id_s";

  // ignore: non_constant_identifier_names
  static String get fragment_pool_node_creator_id_m => "fragment_pool_node_creator_id_m";

  // ignore: non_constant_identifier_names
  static String get fragment_pool_node_creator_id_s => "fragment_pool_node_creator_id_s";

  // ignore: non_constant_identifier_names
  static String get memory_rule_id_m => "memory_rule_id_m";

  // ignore: non_constant_identifier_names
  static String get memory_rule_id_s => "memory_rule_id_s";

  // ignore: non_constant_identifier_names
  static String get memory_rule_creator_id_m => "memory_rule_creator_id_m";

  // ignore: non_constant_identifier_names
  static String get memory_rule_creator_id_s => "memory_rule_creator_id_s";

  // ignore: non_constant_identifier_names
  static String get separate_rule_id_m => "separate_rule_id_m";

  // ignore: non_constant_identifier_names
  static String get separate_rule_id_s => "separate_rule_id_s";

  // ignore: non_constant_identifier_names
  static String get separate_rule_creator_id_m => "separate_rule_creator_id_m";

  // ignore: non_constant_identifier_names
  static String get separate_rule_creator_id_s => "separate_rule_creator_id_s";

  static Map<String, dynamic> toMap(
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
  ) {
    return {
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
      separate_rule_creator_id_s: separate_rule_creator_id_s_v
    };
  }
}
