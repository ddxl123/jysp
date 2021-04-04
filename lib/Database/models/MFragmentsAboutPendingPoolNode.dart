// ignore_for_file: non_constant_identifier_names

import 'package:jysp/Database/base/DBTableBase.dart';
import 'package:jysp/Database/base/SqliteType.dart';

class MFragmentsAboutPendingPoolNode implements DBTableBase {
  @override
  String getTableNameInstance = getTableName;

  static String get getTableName => "fragments_about_pending_pool_nodes";

  static String get fragments_about_pending_pool_node_id => "fragments_about_pending_pool_node_id";

  static String get fragments_about_pending_pool_node_uuid => "fragments_about_pending_pool_node_uuid";

  static String get pn_pending_pool_node_id => "pn_pending_pool_node_id";

  static String get pn_pending_pool_node_uuid => "pn_pending_pool_node_uuid";

  static String get recommend_raw_rule_id => "recommend_raw_rule_id";

  static String get recommend_raw_rule_uuid => "recommend_raw_rule_uuid";

  static String get title => "title";

  static String get created_at => "created_at";

  static String get updated_at => "updated_at";

  static String get curd_status => "curd_status";

  @override
  Map<String, List<SqliteType>> get fields => {fragments_about_pending_pool_node_id: [SqliteType.INTEGER, SqliteType.UNSIGNED], fragments_about_pending_pool_node_uuid: [SqliteType.TEXT], pn_pending_pool_node_id: [SqliteType.INTEGER, SqliteType.UNSIGNED], pn_pending_pool_node_uuid: [SqliteType.TEXT], recommend_raw_rule_id: [SqliteType.INTEGER, SqliteType.UNSIGNED], recommend_raw_rule_uuid: [SqliteType.TEXT], title: [SqliteType.INTEGER], created_at: [SqliteType.INTEGER, SqliteType.UNSIGNED, SqliteType.NOT_NULL], updated_at: [SqliteType.INTEGER, SqliteType.UNSIGNED, SqliteType.NOT_NULL], curd_status: [SqliteType.INTEGER]};

  static Map<String, dynamic> toMap({required int fragments_about_pending_pool_node_id_v,required String fragments_about_pending_pool_node_uuid_v,required int pn_pending_pool_node_id_v,required String pn_pending_pool_node_uuid_v,required int recommend_raw_rule_id_v,required String recommend_raw_rule_uuid_v,required int title_v,required int created_at_v,required int updated_at_v,required int curd_status_v,}
  ) {
    return {fragments_about_pending_pool_node_id:fragments_about_pending_pool_node_id_v,fragments_about_pending_pool_node_uuid:fragments_about_pending_pool_node_uuid_v,pn_pending_pool_node_id:pn_pending_pool_node_id_v,pn_pending_pool_node_uuid:pn_pending_pool_node_uuid_v,recommend_raw_rule_id:recommend_raw_rule_id_v,recommend_raw_rule_uuid:recommend_raw_rule_uuid_v,title:title_v,created_at:created_at_v,updated_at:updated_at_v,curd_status:curd_status_v,};
  }
}