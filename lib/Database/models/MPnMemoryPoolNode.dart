// ignore_for_file: non_constant_identifier_names

import 'package:jysp/Database/base/DBTableBase.dart';
import 'package:jysp/Database/base/SqliteType.dart';

class MPnMemoryPoolNode implements DBTableBase {
  @override
  String getTableNameInstance = getTableName;

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

  @override
  Map<String, List<SqliteType>> get fields => {pn_memory_pool_node_id: [SqliteType.INTEGER, SqliteType.UNSIGNED], pn_memory_pool_node_uuid: [SqliteType.TEXT], using_raw_rule_id: [SqliteType.INTEGER, SqliteType.UNSIGNED], using_raw_rule_uuid: [SqliteType.TEXT], type: [SqliteType.INTEGER], name: [SqliteType.TEXT], position: [SqliteType.TEXT], created_at: [SqliteType.INTEGER, SqliteType.UNSIGNED, SqliteType.NOT_NULL], updated_at: [SqliteType.INTEGER, SqliteType.UNSIGNED, SqliteType.NOT_NULL], curd_status: [SqliteType.INTEGER]};

  static Map<String, dynamic> toMap({required int pn_memory_pool_node_id_v,required String pn_memory_pool_node_uuid_v,required int using_raw_rule_id_v,required String using_raw_rule_uuid_v,required int type_v,required String name_v,required String position_v,required int created_at_v,required int updated_at_v,required int curd_status_v,}
  ) {
    return {pn_memory_pool_node_id:pn_memory_pool_node_id_v,pn_memory_pool_node_uuid:pn_memory_pool_node_uuid_v,using_raw_rule_id:using_raw_rule_id_v,using_raw_rule_uuid:using_raw_rule_uuid_v,type:type_v,name:name_v,position:position_v,created_at:created_at_v,updated_at:updated_at_v,curd_status:curd_status_v,};
  }
}
