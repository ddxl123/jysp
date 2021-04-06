// ignore_for_file: non_constant_identifier_names
import 'package:jysp/G/GSqlite/GSqlite.dart';

enum PendingPoolNodeType {
  notDownloaded,
  nodeIsZero,
  ordinary,
}

class MPnPendingPoolNode {
  MPnPendingPoolNode();

  MPnPendingPoolNode.createModel({
    required int? pn_pending_pool_node_id_v,
    required String? pn_pending_pool_node_uuid_v,
    required int? recommend_raw_rule_id_v,
    required String? recommend_raw_rule_uuid_v,
    required PendingPoolNodeType? type_v,
    required String? name_v,
    required String? position_v,
    required int? created_at_v,
    required int? updated_at_v,
    required int? curd_status_v,
  }) {
    _rowModel.addAll({
      pn_pending_pool_node_id: pn_pending_pool_node_id_v,
      pn_pending_pool_node_uuid: pn_pending_pool_node_uuid_v,
      recommend_raw_rule_id: recommend_raw_rule_id_v,
      recommend_raw_rule_uuid: recommend_raw_rule_uuid_v,
      type: type_v?.index,
      name: name_v,
      position: position_v,
      created_at: created_at_v,
      updated_at: updated_at_v,
      curd_status: curd_status_v,
    });
  }

  static String get getTableName => "pn_pending_pool_nodes";

  static String get pn_pending_pool_node_id => "pn_pending_pool_node_id";
  static String get pn_pending_pool_node_uuid => "pn_pending_pool_node_uuid";
  static String get recommend_raw_rule_id => "recommend_raw_rule_id";
  static String get recommend_raw_rule_uuid => "recommend_raw_rule_uuid";
  static String get type => "type";
  static String get name => "name";
  static String get position => "position";
  static String get created_at => "created_at";
  static String get updated_at => "updated_at";
  static String get curd_status => "curd_status";

  static Map<String, Object?> toSqliteMap({
    required int? pn_pending_pool_node_id_v,
    required String? pn_pending_pool_node_uuid_v,
    required int? recommend_raw_rule_id_v,
    required String? recommend_raw_rule_uuid_v,
    required PendingPoolNodeType? type_v,
    required String? name_v,
    required String? position_v,
    required int? created_at_v,
    required int? updated_at_v,
    required int? curd_status_v,
  }) {
    return {
      pn_pending_pool_node_id: pn_pending_pool_node_id_v,
      pn_pending_pool_node_uuid: pn_pending_pool_node_uuid_v,
      recommend_raw_rule_id: recommend_raw_rule_id_v,
      recommend_raw_rule_uuid: recommend_raw_rule_uuid_v,
      type: type_v?.index,
      name: name_v,
      position: position_v,
      created_at: created_at_v,
      updated_at: updated_at_v,
      curd_status: curd_status_v,
    };
  }

  static Map<String, Object?> toModelMap(Map<String, Object?> sqliteMap) {
    return {
      pn_pending_pool_node_id: sqliteMap[pn_pending_pool_node_id],
      pn_pending_pool_node_uuid: sqliteMap[pn_pending_pool_node_uuid],
      recommend_raw_rule_id: sqliteMap[recommend_raw_rule_id],
      recommend_raw_rule_uuid: sqliteMap[recommend_raw_rule_uuid],
      type: sqliteMap[type] == null ? null : PendingPoolNodeType.values[sqliteMap[type] as int],
      name: sqliteMap[name],
      position: sqliteMap[position],
      created_at: sqliteMap[created_at],
      updated_at: sqliteMap[updated_at],
      curd_status: sqliteMap[curd_status],
    };
  }

  static Future<List<MPnPendingPoolNode>> getAllRowsAsModel() async {
    List<Map<String, Object?>> allRows = await GSqlite.db.query(getTableName);
    List<MPnPendingPoolNode> allRowModels = [];
    allRows.forEach(
      (row) {
        MPnPendingPoolNode newRowModel = MPnPendingPoolNode();
        newRowModel._rowModel = toModelMap(row);
        allRowModels.add(newRowModel);
      },
    );
    return allRowModels;
  }

  Map<String, Object?> _rowModel = {};

  int? get get_pn_pending_pool_node_id => _rowModel[pn_pending_pool_node_id] as int?;
  String? get get_pn_pending_pool_node_uuid => _rowModel[pn_pending_pool_node_uuid] as String?;
  int? get get_recommend_raw_rule_id => _rowModel[recommend_raw_rule_id] as int?;
  String? get get_recommend_raw_rule_uuid => _rowModel[recommend_raw_rule_uuid] as String?;
  PendingPoolNodeType? get get_type => _rowModel[type] as PendingPoolNodeType?;
  String? get get_name => _rowModel[name] as String?;
  String? get get_position => _rowModel[position] as String?;
  int? get get_created_at => _rowModel[created_at] as int?;
  int? get get_updated_at => _rowModel[updated_at] as int?;
  int? get get_curd_status => _rowModel[curd_status] as int?;
}
