// ignore_for_file: non_constant_identifier_names
import 'package:jysp/G/GSqlite/GSqlite.dart';
import 'package:jysp/Database/models/GlobalEnum.dart';

class MRule {

  MRule();

  MRule.createModel({required int? rule_id_v,required String? rule_uuid_v,required int? raw_rule_id_v,required String? raw_rule_uuid_v,required int? pn_rule_pool_node_id_v,required String? pn_rule_pool_node_uuid_v,required int? created_at_v,required int? updated_at_v,required Curd? curd_status_v,}) {
    _rowModel.addAll({rule_id:rule_id_v,rule_uuid:rule_uuid_v,raw_rule_id:raw_rule_id_v,raw_rule_uuid:raw_rule_uuid_v,pn_rule_pool_node_id:pn_rule_pool_node_id_v,pn_rule_pool_node_uuid:pn_rule_pool_node_uuid_v,created_at:created_at_v,updated_at:updated_at_v,curd_status:curd_status_v?.index,});
  }

  static String get getTableName => "rules";

  static String get rule_id => "rule_id";
  static String get rule_uuid => "rule_uuid";
  static String get raw_rule_id => "raw_rule_id";
  static String get raw_rule_uuid => "raw_rule_uuid";
  static String get pn_rule_pool_node_id => "pn_rule_pool_node_id";
  static String get pn_rule_pool_node_uuid => "pn_rule_pool_node_uuid";
  static String get created_at => "created_at";
  static String get updated_at => "updated_at";
  static String get curd_status => "curd_status";


  static Map<String, Object?> toSqliteMap({required int? rule_id_v,required String? rule_uuid_v,required int? raw_rule_id_v,required String? raw_rule_uuid_v,required int? pn_rule_pool_node_id_v,required String? pn_rule_pool_node_uuid_v,required int? created_at_v,required int? updated_at_v,required Curd? curd_status_v,}
  ) {
    return {rule_id:rule_id_v,rule_uuid:rule_uuid_v,raw_rule_id:raw_rule_id_v,raw_rule_uuid:raw_rule_uuid_v,pn_rule_pool_node_id:pn_rule_pool_node_id_v,pn_rule_pool_node_uuid:pn_rule_pool_node_uuid_v,created_at:created_at_v,updated_at:updated_at_v,curd_status:curd_status_v?.index,};
  }

  static Map<String, Object?> toModelMap(Map<String, Object?> sqliteMap) {
    return {rule_id:sqliteMap[rule_id],rule_uuid:sqliteMap[rule_uuid],raw_rule_id:sqliteMap[raw_rule_id],raw_rule_uuid:sqliteMap[raw_rule_uuid],pn_rule_pool_node_id:sqliteMap[pn_rule_pool_node_id],pn_rule_pool_node_uuid:sqliteMap[pn_rule_pool_node_uuid],created_at:sqliteMap[created_at],updated_at:sqliteMap[updated_at],curd_status:sqliteMap[curd_status] == null ? null : Curd.values[sqliteMap[curd_status] as int],};
  }

  static Future<List<Map<String, Object?>>> getAllRowsAsSqliteMap() async {
    return await GSqlite.db.query(getTableName);
  }

  static Future<List<MRule>> getAllRowsAsModel() async {
    List<Map<String, Object?>> allRows = await getAllRowsAsSqliteMap();
    List<MRule> allRowModels = [];
    allRows.forEach(
      (row) {
        MRule newRowModel = MRule();
        newRowModel._rowModel.addAll(toModelMap(row));
        allRowModels.add(newRowModel);
      },
    );
    return allRowModels;
  }

  Map<String, Object?> _rowModel = {};



  int? get get_rule_id => _rowModel[rule_id] as int?;
  String? get get_rule_uuid => _rowModel[rule_uuid] as String?;
  int? get get_raw_rule_id => _rowModel[raw_rule_id] as int?;
  String? get get_raw_rule_uuid => _rowModel[raw_rule_uuid] as String?;
  int? get get_pn_rule_pool_node_id => _rowModel[pn_rule_pool_node_id] as int?;
  String? get get_pn_rule_pool_node_uuid => _rowModel[pn_rule_pool_node_uuid] as String?;
  int? get get_created_at => _rowModel[created_at] as int?;
  int? get get_updated_at => _rowModel[updated_at] as int?;
  Curd? get get_curd_status => _rowModel[curd_status] as Curd?;

}
