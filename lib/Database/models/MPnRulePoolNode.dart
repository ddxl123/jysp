// ignore_for_file: non_constant_identifier_names
import 'package:jysp/G/GSqlite/GSqlite.dart';
import 'package:jysp/Database/models/GlobalEnum.dart';

class MPnRulePoolNode {

  MPnRulePoolNode();

  MPnRulePoolNode.createModel({required int? pn_rule_pool_node_id_v,required String? pn_rule_pool_node_uuid_v,required int? type_v,required String? name_v,required String? position_v,required int? created_at_v,required int? updated_at_v,required Curd? curd_status_v,}) {
    _rowModel.addAll({pn_rule_pool_node_id:pn_rule_pool_node_id_v,pn_rule_pool_node_uuid:pn_rule_pool_node_uuid_v,type:type_v,name:name_v,position:position_v,created_at:created_at_v,updated_at:updated_at_v,curd_status:curd_status_v?.index,});
  }

  static String get getTableName => "pn_rule_pool_nodes";

  static String get pn_rule_pool_node_id => "pn_rule_pool_node_id";
  static String get pn_rule_pool_node_uuid => "pn_rule_pool_node_uuid";
  static String get type => "type";
  static String get name => "name";
  static String get position => "position";
  static String get created_at => "created_at";
  static String get updated_at => "updated_at";
  static String get curd_status => "curd_status";


  static Map<String, Object?> toSqliteMap({required int? pn_rule_pool_node_id_v,required String? pn_rule_pool_node_uuid_v,required int? type_v,required String? name_v,required String? position_v,required int? created_at_v,required int? updated_at_v,required Curd? curd_status_v,}
  ) {
    return {pn_rule_pool_node_id:pn_rule_pool_node_id_v,pn_rule_pool_node_uuid:pn_rule_pool_node_uuid_v,type:type_v,name:name_v,position:position_v,created_at:created_at_v,updated_at:updated_at_v,curd_status:curd_status_v?.index,};
  }

  static Map<String, Object?> toModelMap(Map<String, Object?> sqliteMap) {
    return {pn_rule_pool_node_id:sqliteMap[pn_rule_pool_node_id],pn_rule_pool_node_uuid:sqliteMap[pn_rule_pool_node_uuid],type:sqliteMap[type],name:sqliteMap[name],position:sqliteMap[position],created_at:sqliteMap[created_at],updated_at:sqliteMap[updated_at],curd_status:sqliteMap[curd_status] == null ? null : Curd.values[sqliteMap[curd_status] as int],};
  }

  static Future<List<Map<String, Object?>>> getAllRowsAsSqliteMap() async {
    return await GSqlite.db.query(getTableName);
  }

  static Future<List<MPnRulePoolNode>> getAllRowsAsModel() async {
    List<Map<String, Object?>> allRows = await getAllRowsAsSqliteMap();
    List<MPnRulePoolNode> allRowModels = [];
    allRows.forEach(
      (row) {
        MPnRulePoolNode newRowModel = MPnRulePoolNode();
        newRowModel._rowModel.addAll(toModelMap(row));
        allRowModels.add(newRowModel);
      },
    );
    return allRowModels;
  }

  Map<String, Object?> _rowModel = {};



  int? get get_pn_rule_pool_node_id => _rowModel[pn_rule_pool_node_id] as int?;
  String? get get_pn_rule_pool_node_uuid => _rowModel[pn_rule_pool_node_uuid] as String?;
  int? get get_type => _rowModel[type] as int?;
  String? get get_name => _rowModel[name] as String?;
  String? get get_position => _rowModel[position] as String?;
  int? get get_created_at => _rowModel[created_at] as int?;
  int? get get_updated_at => _rowModel[updated_at] as int?;
  Curd? get get_curd_status => _rowModel[curd_status] as Curd?;

}
