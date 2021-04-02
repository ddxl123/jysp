// ignore_for_file: non_constant_identifier_names

import 'package:jysp/Database/base/DBTableBase.dart';
import 'package:jysp/Database/base/SqliteType.dart';

class MRule implements DBTableBase {
  @override
  String getTableNameInstance = getTableName;

  static String get getTableName => "rules";

  static String get raw_rule_id => "raw_rule_id";

  static String get raw_rule_uuid => "raw_rule_uuid";

  static String get pn_rule_pool_node_id => "pn_rule_pool_node_id";

  static String get pn_rule_pool_node_uuid => "pn_rule_pool_node_uuid";

  static String get created_at => "created_at";

  static String get updated_at => "updated_at";

  static String get curd_status => "curd_status";

  @override
  Map<String, List<SqliteType>> get fields => {raw_rule_id: [SqliteType.INTEGER, SqliteType.UNSIGNED], raw_rule_uuid: [SqliteType.TEXT], pn_rule_pool_node_id: [SqliteType.INTEGER, SqliteType.UNSIGNED], pn_rule_pool_node_uuid: [SqliteType.TEXT], created_at: [SqliteType.INTEGER, SqliteType.UNSIGNED, SqliteType.NOT_NULL], updated_at: [SqliteType.INTEGER, SqliteType.UNSIGNED, SqliteType.NOT_NULL], curd_status: [SqliteType.INTEGER]};

  static Map<String, dynamic> toMap({required int raw_rule_id_v,required String raw_rule_uuid_v,required int pn_rule_pool_node_id_v,required String pn_rule_pool_node_uuid_v,required int created_at_v,required int updated_at_v,required int curd_status_v,}
  ) {
    return {raw_rule_id:raw_rule_id_v,raw_rule_uuid:raw_rule_uuid_v,pn_rule_pool_node_id:pn_rule_pool_node_id_v,pn_rule_pool_node_uuid:pn_rule_pool_node_uuid_v,created_at:created_at_v,updated_at:updated_at_v,curd_status:curd_status_v,};
  }
}
