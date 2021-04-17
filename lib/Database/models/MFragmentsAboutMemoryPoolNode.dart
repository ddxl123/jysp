// ignore_for_file: non_constant_identifier_names
import 'package:jysp/G/GSqlite/GSqlite.dart';
import 'package:jysp/Database/models/GlobalEnum.dart';

class MFragmentsAboutMemoryPoolNode {

  MFragmentsAboutMemoryPoolNode();

  MFragmentsAboutMemoryPoolNode.createModel({required int? fragments_about_memory_pool_node_id_v,required String? fragments_about_memory_pool_node_uuid_v,required int? fragments_about_pending_pool_node_id_v,required String? fragments_about_pending_pool_node_uuid_v,required int? using_raw_rule_id_v,required String? using_raw_rule_uuid_v,required int? pn_memory_pool_node_id_v,required String? pn_memory_pool_node_uuid_v,required int? created_at_v,required int? updated_at_v,required Curd? curd_status_v,}) {
    _rowModel.addAll({fragments_about_memory_pool_node_id:fragments_about_memory_pool_node_id_v,fragments_about_memory_pool_node_uuid:fragments_about_memory_pool_node_uuid_v,fragments_about_pending_pool_node_id:fragments_about_pending_pool_node_id_v,fragments_about_pending_pool_node_uuid:fragments_about_pending_pool_node_uuid_v,using_raw_rule_id:using_raw_rule_id_v,using_raw_rule_uuid:using_raw_rule_uuid_v,pn_memory_pool_node_id:pn_memory_pool_node_id_v,pn_memory_pool_node_uuid:pn_memory_pool_node_uuid_v,created_at:created_at_v,updated_at:updated_at_v,curd_status:curd_status_v?.index,});
  }

  static String get getTableName => "fragments_about_memory_pool_nodes";

  static String get fragments_about_memory_pool_node_id => "fragments_about_memory_pool_node_id";
  static String get fragments_about_memory_pool_node_uuid => "fragments_about_memory_pool_node_uuid";
  static String get fragments_about_pending_pool_node_id => "fragments_about_pending_pool_node_id";
  static String get fragments_about_pending_pool_node_uuid => "fragments_about_pending_pool_node_uuid";
  static String get using_raw_rule_id => "using_raw_rule_id";
  static String get using_raw_rule_uuid => "using_raw_rule_uuid";
  static String get pn_memory_pool_node_id => "pn_memory_pool_node_id";
  static String get pn_memory_pool_node_uuid => "pn_memory_pool_node_uuid";
  static String get created_at => "created_at";
  static String get updated_at => "updated_at";
  static String get curd_status => "curd_status";


  static Map<String, Object?> toSqliteMap({required int? fragments_about_memory_pool_node_id_v,required String? fragments_about_memory_pool_node_uuid_v,required int? fragments_about_pending_pool_node_id_v,required String? fragments_about_pending_pool_node_uuid_v,required int? using_raw_rule_id_v,required String? using_raw_rule_uuid_v,required int? pn_memory_pool_node_id_v,required String? pn_memory_pool_node_uuid_v,required int? created_at_v,required int? updated_at_v,required Curd? curd_status_v,}
  ) {
    return {fragments_about_memory_pool_node_id:fragments_about_memory_pool_node_id_v,fragments_about_memory_pool_node_uuid:fragments_about_memory_pool_node_uuid_v,fragments_about_pending_pool_node_id:fragments_about_pending_pool_node_id_v,fragments_about_pending_pool_node_uuid:fragments_about_pending_pool_node_uuid_v,using_raw_rule_id:using_raw_rule_id_v,using_raw_rule_uuid:using_raw_rule_uuid_v,pn_memory_pool_node_id:pn_memory_pool_node_id_v,pn_memory_pool_node_uuid:pn_memory_pool_node_uuid_v,created_at:created_at_v,updated_at:updated_at_v,curd_status:curd_status_v?.index,};
  }

  static Map<String, Object?> toModelMap(Map<String, Object?> sqliteMap) {
    return {fragments_about_memory_pool_node_id:sqliteMap[fragments_about_memory_pool_node_id],fragments_about_memory_pool_node_uuid:sqliteMap[fragments_about_memory_pool_node_uuid],fragments_about_pending_pool_node_id:sqliteMap[fragments_about_pending_pool_node_id],fragments_about_pending_pool_node_uuid:sqliteMap[fragments_about_pending_pool_node_uuid],using_raw_rule_id:sqliteMap[using_raw_rule_id],using_raw_rule_uuid:sqliteMap[using_raw_rule_uuid],pn_memory_pool_node_id:sqliteMap[pn_memory_pool_node_id],pn_memory_pool_node_uuid:sqliteMap[pn_memory_pool_node_uuid],created_at:sqliteMap[created_at],updated_at:sqliteMap[updated_at],curd_status:sqliteMap[curd_status] == null ? null : Curd.values[sqliteMap[curd_status] as int],};
  }

  static Future<List<Map<String, Object?>>> getAllRowsAsSqliteMap() async {
    return await GSqlite.db.query(getTableName);
  }

  static Future<List<MFragmentsAboutMemoryPoolNode>> getAllRowsAsModel() async {
    List<Map<String, Object?>> allRows = await getAllRowsAsSqliteMap();
    List<MFragmentsAboutMemoryPoolNode> allRowModels = [];
    allRows.forEach(
      (row) {
        MFragmentsAboutMemoryPoolNode newRowModel = MFragmentsAboutMemoryPoolNode();
        newRowModel._rowModel.addAll(toModelMap(row));
        allRowModels.add(newRowModel);
      },
    );
    return allRowModels;
  }

  Map<String, Object?> _rowModel = {};



  int? get get_fragments_about_memory_pool_node_id => _rowModel[fragments_about_memory_pool_node_id] as int?;
  String? get get_fragments_about_memory_pool_node_uuid => _rowModel[fragments_about_memory_pool_node_uuid] as String?;
  int? get get_fragments_about_pending_pool_node_id => _rowModel[fragments_about_pending_pool_node_id] as int?;
  String? get get_fragments_about_pending_pool_node_uuid => _rowModel[fragments_about_pending_pool_node_uuid] as String?;
  int? get get_using_raw_rule_id => _rowModel[using_raw_rule_id] as int?;
  String? get get_using_raw_rule_uuid => _rowModel[using_raw_rule_uuid] as String?;
  int? get get_pn_memory_pool_node_id => _rowModel[pn_memory_pool_node_id] as int?;
  String? get get_pn_memory_pool_node_uuid => _rowModel[pn_memory_pool_node_uuid] as String?;
  int? get get_created_at => _rowModel[created_at] as int?;
  int? get get_updated_at => _rowModel[updated_at] as int?;
  Curd? get get_curd_status => _rowModel[curd_status] as Curd?;

}
