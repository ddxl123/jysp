// ignore_for_file: non_constant_identifier_names
import 'package:jysp/Database/Models/MBase.dart';
import 'package:jysp/G/GSqlite/GSqlite.dart';


class MFragmentsAboutMemoryPoolNode implements MBase{

  MFragmentsAboutMemoryPoolNode();

  /// 1. insert 时，无需传入 id ，id 是自增的。
  /// 2. 若只创建 model 而并非 inset，id 的值为 null。
  MFragmentsAboutMemoryPoolNode.createModel({required int? aiid_v,required String? uuid_v,required int? fragments_about_pending_pool_node_aiid_v,required String? fragments_about_pending_pool_node_uuid_v,required int? using_raw_rule_aiid_v,required String? using_raw_rule_uuid_v,required int? pn_memory_pool_node_aiid_v,required String? pn_memory_pool_node_uuid_v,required int? created_at_v,required int? updated_at_v,}) {
    _rowJson.addAll(<String, Object?>{aiid:aiid_v,uuid:uuid_v,fragments_about_pending_pool_node_aiid:fragments_about_pending_pool_node_aiid_v,fragments_about_pending_pool_node_uuid:fragments_about_pending_pool_node_uuid_v,using_raw_rule_aiid:using_raw_rule_aiid_v,using_raw_rule_uuid:using_raw_rule_uuid_v,pn_memory_pool_node_aiid:pn_memory_pool_node_aiid_v,pn_memory_pool_node_uuid:pn_memory_pool_node_uuid_v,created_at:created_at_v,updated_at:updated_at_v,});
  }

  static String get getTableName => 'fragments_about_memory_pool_nodes';

  static String get id => 'id';
  static String get aiid => 'aiid';
  static String get uuid => 'uuid';
  static String get fragments_about_pending_pool_node_aiid => 'fragments_about_pending_pool_node_aiid';
  static String get fragments_about_pending_pool_node_uuid => 'fragments_about_pending_pool_node_uuid';
  static String get using_raw_rule_aiid => 'using_raw_rule_aiid';
  static String get using_raw_rule_uuid => 'using_raw_rule_uuid';
  static String get pn_memory_pool_node_aiid => 'pn_memory_pool_node_aiid';
  static String get pn_memory_pool_node_uuid => 'pn_memory_pool_node_uuid';
  static String get created_at => 'created_at';
  static String get updated_at => 'updated_at';


  static Map<String, Object?> asJsonNoId({required int? aiid_v,required String? uuid_v,required int? fragments_about_pending_pool_node_aiid_v,required String? fragments_about_pending_pool_node_uuid_v,required int? using_raw_rule_aiid_v,required String? using_raw_rule_uuid_v,required int? pn_memory_pool_node_aiid_v,required String? pn_memory_pool_node_uuid_v,required int? created_at_v,required int? updated_at_v,}
  ) {
    return <String, Object?>{aiid:aiid_v,uuid:uuid_v,fragments_about_pending_pool_node_aiid:fragments_about_pending_pool_node_aiid_v,fragments_about_pending_pool_node_uuid:fragments_about_pending_pool_node_uuid_v,using_raw_rule_aiid:using_raw_rule_aiid_v,using_raw_rule_uuid:using_raw_rule_uuid_v,pn_memory_pool_node_aiid:pn_memory_pool_node_aiid_v,pn_memory_pool_node_uuid:pn_memory_pool_node_uuid_v,created_at:created_at_v,updated_at:updated_at_v,};
  }

  static Map<String, Object?> asModelNoId(Map<String, Object?> json) {
    return <String, Object?>{aiid:json[aiid],uuid:json[uuid],fragments_about_pending_pool_node_aiid:json[fragments_about_pending_pool_node_aiid],fragments_about_pending_pool_node_uuid:json[fragments_about_pending_pool_node_uuid],using_raw_rule_aiid:json[using_raw_rule_aiid],using_raw_rule_uuid:json[using_raw_rule_uuid],pn_memory_pool_node_aiid:json[pn_memory_pool_node_aiid],pn_memory_pool_node_uuid:json[pn_memory_pool_node_uuid],created_at:json[created_at],updated_at:json[updated_at],};
  }


  /// 若 [where]/[whereArgs] 为 null，则 query 的是全部 row。
  static Future<List<Map<String, Object?>>> queryRowsAsJsons({String? where, List<Object?>? whereArgs}) async {
    return await db.query(getTableName, where: 'id = ?', whereArgs: whereArgs);
  }

  /// 若 [where]/[whereArgs] 为 null，则 query 的是全部 row。
  static Future<List<MFragmentsAboutMemoryPoolNode>> queryRowsAsModels({String? where, List<Object?>? whereArgs}) async {
    final List<Map<String, Object?>> rows = await queryRowsAsJsons(where: where, whereArgs: whereArgs);
    final List<MFragmentsAboutMemoryPoolNode> rowModels = <MFragmentsAboutMemoryPoolNode>[];
    for (final Map<String, Object?> row in rows) {
        final MFragmentsAboutMemoryPoolNode newRowModel = MFragmentsAboutMemoryPoolNode();
        newRowModel._rowJson.addAll(row);
        rowModels.add(newRowModel);
    }
    return rowModels;
  }

  @override
  Map<String, Object?> get getRowJson => _rowJson;

  @override
  String? getForeignKeyTableNames({required String foreignKeyName}) => _foreignKeyTableNames[foreignKeyName];

  @override
  Set<String> get getDeleteChildFollowFatherKeysForTwo => _deleteChildFollowFatherKeysForTwo;

  @override
  Set<String> get getDeleteChildFollowFatherKeysForSingle => _deleteChildFollowFatherKeysForSingle;

  @override
  List<String> get getDeleteFatherFollowChildKeys => _deleteFatherFollowChildKeys;

  final Map<String, Object?> _rowJson = <String, Object?>{};

  final Map<String, String?> _foreignKeyTableNames = <String, String?>{
  'fragments_about_pending_pool_node_aiid': 'fragments_about_pending_pool_nodes',
  'fragments_about_pending_pool_node_uuid': 'fragments_about_pending_pool_nodes',
  'using_raw_rule_aiid': 'rules',
  'using_raw_rule_uuid': 'rules',
  'pn_memory_pool_node_aiid': 'pn_memory_pool_nodes',
  'pn_memory_pool_node_uuid': 'pn_memory_pool_nodes'
};

  final Set<String> _deleteChildFollowFatherKeysForTwo = <String>{};

  final Set<String> _deleteChildFollowFatherKeysForSingle = <String>{};

  final List<String> _deleteFatherFollowChildKeys =<String>[fragments_about_pending_pool_node_aiid,fragments_about_pending_pool_node_uuid,pn_memory_pool_node_aiid,pn_memory_pool_node_uuid,];

  @override
  String get getCurrentTableName => getTableName;

@override int? get get_id => _rowJson[id] as int?;@override int? get get_aiid => _rowJson[aiid] as int?;@override String? get get_uuid => _rowJson[uuid] as String?; int? get get_fragments_about_pending_pool_node_aiid => _rowJson[fragments_about_pending_pool_node_aiid] as int?; String? get get_fragments_about_pending_pool_node_uuid => _rowJson[fragments_about_pending_pool_node_uuid] as String?; int? get get_using_raw_rule_aiid => _rowJson[using_raw_rule_aiid] as int?; String? get get_using_raw_rule_uuid => _rowJson[using_raw_rule_uuid] as String?; int? get get_pn_memory_pool_node_aiid => _rowJson[pn_memory_pool_node_aiid] as int?; String? get get_pn_memory_pool_node_uuid => _rowJson[pn_memory_pool_node_uuid] as String?;@override int? get get_created_at => _rowJson[created_at] as int?;@override int? get get_updated_at => _rowJson[updated_at] as int?;
}
