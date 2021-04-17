// ignore_for_file: non_constant_identifier_names
import 'package:jysp/G/GSqlite/GSqlite.dart';
import 'package:jysp/Database/models/GlobalEnum.dart';

class MFragmentsAboutPendingPoolNode {

  MFragmentsAboutPendingPoolNode();

  MFragmentsAboutPendingPoolNode.createModel({required int? fragments_about_pending_pool_node_id_v,required String? fragments_about_pending_pool_node_uuid_v,required int? raw_fragment_id_v,required String? raw_fragment_id_uuid_v,required int? pn_pending_pool_node_id_v,required String? pn_pending_pool_node_uuid_v,required int? recommend_raw_rule_id_v,required String? recommend_raw_rule_uuid_v,required String? title_v,required int? created_at_v,required int? updated_at_v,required Curd? curd_status_v,}) {
    _rowModel.addAll({fragments_about_pending_pool_node_id:fragments_about_pending_pool_node_id_v,fragments_about_pending_pool_node_uuid:fragments_about_pending_pool_node_uuid_v,raw_fragment_id:raw_fragment_id_v,raw_fragment_id_uuid:raw_fragment_id_uuid_v,pn_pending_pool_node_id:pn_pending_pool_node_id_v,pn_pending_pool_node_uuid:pn_pending_pool_node_uuid_v,recommend_raw_rule_id:recommend_raw_rule_id_v,recommend_raw_rule_uuid:recommend_raw_rule_uuid_v,title:title_v,created_at:created_at_v,updated_at:updated_at_v,curd_status:curd_status_v?.index,});
  }

  static String get getTableName => "fragments_about_pending_pool_nodes";

  static String get fragments_about_pending_pool_node_id => "fragments_about_pending_pool_node_id";
  static String get fragments_about_pending_pool_node_uuid => "fragments_about_pending_pool_node_uuid";
  static String get raw_fragment_id => "raw_fragment_id";
  static String get raw_fragment_id_uuid => "raw_fragment_id_uuid";
  static String get pn_pending_pool_node_id => "pn_pending_pool_node_id";
  static String get pn_pending_pool_node_uuid => "pn_pending_pool_node_uuid";
  static String get recommend_raw_rule_id => "recommend_raw_rule_id";
  static String get recommend_raw_rule_uuid => "recommend_raw_rule_uuid";
  static String get title => "title";
  static String get created_at => "created_at";
  static String get updated_at => "updated_at";
  static String get curd_status => "curd_status";


  static Map<String, Object?> toSqliteMap({required int? fragments_about_pending_pool_node_id_v,required String? fragments_about_pending_pool_node_uuid_v,required int? raw_fragment_id_v,required String? raw_fragment_id_uuid_v,required int? pn_pending_pool_node_id_v,required String? pn_pending_pool_node_uuid_v,required int? recommend_raw_rule_id_v,required String? recommend_raw_rule_uuid_v,required String? title_v,required int? created_at_v,required int? updated_at_v,required Curd? curd_status_v,}
  ) {
    return {fragments_about_pending_pool_node_id:fragments_about_pending_pool_node_id_v,fragments_about_pending_pool_node_uuid:fragments_about_pending_pool_node_uuid_v,raw_fragment_id:raw_fragment_id_v,raw_fragment_id_uuid:raw_fragment_id_uuid_v,pn_pending_pool_node_id:pn_pending_pool_node_id_v,pn_pending_pool_node_uuid:pn_pending_pool_node_uuid_v,recommend_raw_rule_id:recommend_raw_rule_id_v,recommend_raw_rule_uuid:recommend_raw_rule_uuid_v,title:title_v,created_at:created_at_v,updated_at:updated_at_v,curd_status:curd_status_v?.index,};
  }

  static Map<String, Object?> toModelMap(Map<String, Object?> sqliteMap) {
    return {fragments_about_pending_pool_node_id:sqliteMap[fragments_about_pending_pool_node_id],fragments_about_pending_pool_node_uuid:sqliteMap[fragments_about_pending_pool_node_uuid],raw_fragment_id:sqliteMap[raw_fragment_id],raw_fragment_id_uuid:sqliteMap[raw_fragment_id_uuid],pn_pending_pool_node_id:sqliteMap[pn_pending_pool_node_id],pn_pending_pool_node_uuid:sqliteMap[pn_pending_pool_node_uuid],recommend_raw_rule_id:sqliteMap[recommend_raw_rule_id],recommend_raw_rule_uuid:sqliteMap[recommend_raw_rule_uuid],title:sqliteMap[title],created_at:sqliteMap[created_at],updated_at:sqliteMap[updated_at],curd_status:sqliteMap[curd_status] == null ? null : Curd.values[sqliteMap[curd_status] as int],};
  }

  static Future<List<Map<String, Object?>>> getAllRowsAsSqliteMap() async {
    return await GSqlite.db.query(getTableName);
  }

  static Future<List<MFragmentsAboutPendingPoolNode>> getAllRowsAsModel() async {
    List<Map<String, Object?>> allRows = await getAllRowsAsSqliteMap();
    List<MFragmentsAboutPendingPoolNode> allRowModels = [];
    allRows.forEach(
      (row) {
        MFragmentsAboutPendingPoolNode newRowModel = MFragmentsAboutPendingPoolNode();
        newRowModel._rowModel.addAll(toModelMap(row));
        allRowModels.add(newRowModel);
      },
    );
    return allRowModels;
  }

  Map<String, Object?> _rowModel = {};



  int? get get_fragments_about_pending_pool_node_id => _rowModel[fragments_about_pending_pool_node_id] as int?;
  String? get get_fragments_about_pending_pool_node_uuid => _rowModel[fragments_about_pending_pool_node_uuid] as String?;
  int? get get_raw_fragment_id => _rowModel[raw_fragment_id] as int?;
  String? get get_raw_fragment_id_uuid => _rowModel[raw_fragment_id_uuid] as String?;
  int? get get_pn_pending_pool_node_id => _rowModel[pn_pending_pool_node_id] as int?;
  String? get get_pn_pending_pool_node_uuid => _rowModel[pn_pending_pool_node_uuid] as String?;
  int? get get_recommend_raw_rule_id => _rowModel[recommend_raw_rule_id] as int?;
  String? get get_recommend_raw_rule_uuid => _rowModel[recommend_raw_rule_uuid] as String?;
  String? get get_title => _rowModel[title] as String?;
  int? get get_created_at => _rowModel[created_at] as int?;
  int? get get_updated_at => _rowModel[updated_at] as int?;
  Curd? get get_curd_status => _rowModel[curd_status] as Curd?;

}
