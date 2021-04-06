// ignore_for_file: non_constant_identifier_names
import 'package:jysp/G/GSqlite/GSqlite.dart';

class MPnMemoryPoolNode {
  MPnMemoryPoolNode();

  MPnMemoryPoolNode.createModel({
    required int? pn_memory_pool_node_id_v,
    required String? pn_memory_pool_node_uuid_v,
    required int? using_raw_rule_id_v,
    required String? using_raw_rule_uuid_v,
    required int? type_v,
    required String? name_v,
    required String? position_v,
    required int? created_at_v,
    required int? updated_at_v,
    required int? curd_status_v,
  }) {
    _rowModel.addAll({
      pn_memory_pool_node_id: pn_memory_pool_node_id_v,
      pn_memory_pool_node_uuid: pn_memory_pool_node_uuid_v,
      using_raw_rule_id: using_raw_rule_id_v,
      using_raw_rule_uuid: using_raw_rule_uuid_v,
      type: type_v,
      name: name_v,
      position: position_v,
      created_at: created_at_v,
      updated_at: updated_at_v,
      curd_status: curd_status_v,
    });
  }

  static String get getTableName => "pn_memory_pool_nodes";

  static String get pn_memory_pool_node_id => "pn_memory_pool_node_id";
  static String get pn_memory_pool_node_uuid => "pn_memory_pool_node_uuid";
  static String get using_raw_rule_id => "using_raw_rule_id";
  static String get using_raw_rule_uuid => "using_raw_rule_uuid";
  static String get type => "type";
  static String get name => "name";
  static String get position => "position";
  static String get created_at => "created_at";
  static String get updated_at => "updated_at";
  static String get curd_status => "curd_status";

  static Map<String, Object?> toSqliteMap({
    required int? pn_memory_pool_node_id_v,
    required String? pn_memory_pool_node_uuid_v,
    required int? using_raw_rule_id_v,
    required String? using_raw_rule_uuid_v,
    required int? type_v,
    required String? name_v,
    required String? position_v,
    required int? created_at_v,
    required int? updated_at_v,
    required int? curd_status_v,
  }) {
    return {
      pn_memory_pool_node_id: pn_memory_pool_node_id_v,
      pn_memory_pool_node_uuid: pn_memory_pool_node_uuid_v,
      using_raw_rule_id: using_raw_rule_id_v,
      using_raw_rule_uuid: using_raw_rule_uuid_v,
      type: type_v,
      name: name_v,
      position: position_v,
      created_at: created_at_v,
      updated_at: updated_at_v,
      curd_status: curd_status_v,
    };
  }

  static Map<String, Object?> toModelMap(Map<String, Object?> sqliteMap) {
    return {
      pn_memory_pool_node_id: sqliteMap[pn_memory_pool_node_id],
      pn_memory_pool_node_uuid: sqliteMap[pn_memory_pool_node_uuid],
      using_raw_rule_id: sqliteMap[using_raw_rule_id],
      using_raw_rule_uuid: sqliteMap[using_raw_rule_uuid],
      type: sqliteMap[type],
      name: sqliteMap[name],
      position: sqliteMap[position],
      created_at: sqliteMap[created_at],
      updated_at: sqliteMap[updated_at],
      curd_status: sqliteMap[curd_status],
    };
  }

  static Future<List<MPnMemoryPoolNode>> getAllRowsAsModel() async {
    List<Map<String, Object?>> allRows = await GSqlite.db.query(getTableName);
    List<MPnMemoryPoolNode> allRowModels = [];
    allRows.forEach(
      (row) {
        MPnMemoryPoolNode newRowModel = MPnMemoryPoolNode();
        newRowModel._rowModel = toModelMap(row);
        allRowModels.add(newRowModel);
      },
    );
    return allRowModels;
  }

  Map<String, Object?> _rowModel = {};

  int? get get_pn_memory_pool_node_id => _rowModel[pn_memory_pool_node_id] as int?;
  String? get get_pn_memory_pool_node_uuid => _rowModel[pn_memory_pool_node_uuid] as String?;
  int? get get_using_raw_rule_id => _rowModel[using_raw_rule_id] as int?;
  String? get get_using_raw_rule_uuid => _rowModel[using_raw_rule_uuid] as String?;
  int? get get_type => _rowModel[type] as int?;
  String? get get_name => _rowModel[name] as String?;
  String? get get_position => _rowModel[position] as String?;
  int? get get_created_at => _rowModel[created_at] as int?;
  int? get get_updated_at => _rowModel[updated_at] as int?;
  int? get get_curd_status => _rowModel[curd_status] as int?;
}
