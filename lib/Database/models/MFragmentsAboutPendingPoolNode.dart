// ignore_for_file: non_constant_identifier_names
import 'package:jysp/Database/Models/MBase.dart';
import 'package:jysp/G/GSqlite/GSqlite.dart';


class MFragmentsAboutPendingPoolNode implements MBase{

  MFragmentsAboutPendingPoolNode();

  /// 1. insert 时，无需传入 id ，id 是自增的。
  /// 2. 若只创建 model 而并非 inset，id 的值为 null。
  MFragmentsAboutPendingPoolNode.createModel({required int? aiid_v,required String? uuid_v,required int? raw_fragment_aiid_v,required String? raw_fragment_uuid_v,required int? pn_pending_pool_node_aiid_v,required String? pn_pending_pool_node_uuid_v,required int? recommend_raw_rule_aiid_v,required String? recommend_raw_rule_uuid_v,required String? title_v,required int? created_at_v,required int? updated_at_v,}) {
    _rowJson.addAll(<String, Object?>{aiid:aiid_v,uuid:uuid_v,raw_fragment_aiid:raw_fragment_aiid_v,raw_fragment_uuid:raw_fragment_uuid_v,pn_pending_pool_node_aiid:pn_pending_pool_node_aiid_v,pn_pending_pool_node_uuid:pn_pending_pool_node_uuid_v,recommend_raw_rule_aiid:recommend_raw_rule_aiid_v,recommend_raw_rule_uuid:recommend_raw_rule_uuid_v,title:title_v,created_at:created_at_v,updated_at:updated_at_v,});
  }

  static String get getTableName => 'fragments_about_pending_pool_nodes';

  static String get id => 'id';
  static String get aiid => 'aiid';
  static String get uuid => 'uuid';
  static String get raw_fragment_aiid => 'raw_fragment_aiid';
  static String get raw_fragment_uuid => 'raw_fragment_uuid';
  static String get pn_pending_pool_node_aiid => 'pn_pending_pool_node_aiid';
  static String get pn_pending_pool_node_uuid => 'pn_pending_pool_node_uuid';
  static String get recommend_raw_rule_aiid => 'recommend_raw_rule_aiid';
  static String get recommend_raw_rule_uuid => 'recommend_raw_rule_uuid';
  static String get title => 'title';
  static String get created_at => 'created_at';
  static String get updated_at => 'updated_at';


  static Map<String, Object?> asJsonNoId({required int? aiid_v,required String? uuid_v,required int? raw_fragment_aiid_v,required String? raw_fragment_uuid_v,required int? pn_pending_pool_node_aiid_v,required String? pn_pending_pool_node_uuid_v,required int? recommend_raw_rule_aiid_v,required String? recommend_raw_rule_uuid_v,required String? title_v,required int? created_at_v,required int? updated_at_v,}
  ) {
    return <String, Object?>{aiid:aiid_v,uuid:uuid_v,raw_fragment_aiid:raw_fragment_aiid_v,raw_fragment_uuid:raw_fragment_uuid_v,pn_pending_pool_node_aiid:pn_pending_pool_node_aiid_v,pn_pending_pool_node_uuid:pn_pending_pool_node_uuid_v,recommend_raw_rule_aiid:recommend_raw_rule_aiid_v,recommend_raw_rule_uuid:recommend_raw_rule_uuid_v,title:title_v,created_at:created_at_v,updated_at:updated_at_v,};
  }

  static Map<String, Object?> asModelNoId(Map<String, Object?> json) {
    return <String, Object?>{aiid:json[aiid],uuid:json[uuid],raw_fragment_aiid:json[raw_fragment_aiid],raw_fragment_uuid:json[raw_fragment_uuid],pn_pending_pool_node_aiid:json[pn_pending_pool_node_aiid],pn_pending_pool_node_uuid:json[pn_pending_pool_node_uuid],recommend_raw_rule_aiid:json[recommend_raw_rule_aiid],recommend_raw_rule_uuid:json[recommend_raw_rule_uuid],title:json[title],created_at:json[created_at],updated_at:json[updated_at],};
  }


  /// 若 [where]/[whereArgs] 为 null，则 query 的是全部 row。
  static Future<List<Map<String, Object?>>> queryRowsAsJsons({String? where, List<Object?>? whereArgs}) async {
    return await db.query(getTableName, where: 'id = ?', whereArgs: whereArgs);
  }

  /// 若 [where]/[whereArgs] 为 null，则 query 的是全部 row。
  static Future<List<MFragmentsAboutPendingPoolNode>> queryRowsAsModels({String? where, List<Object?>? whereArgs}) async {
    final List<Map<String, Object?>> rows = await queryRowsAsJsons(where: where, whereArgs: whereArgs);
    final List<MFragmentsAboutPendingPoolNode> rowModels = <MFragmentsAboutPendingPoolNode>[];
    for (final Map<String, Object?> row in rows) {
        final MFragmentsAboutPendingPoolNode newRowModel = MFragmentsAboutPendingPoolNode();
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
  'raw_fragment_aiid': null,
  'raw_fragment_uuid': null,
  'pn_pending_pool_node_aiid': 'pn_pending_pool_nodes',
  'pn_pending_pool_node_uuid': 'pn_pending_pool_nodes',
  'recommend_raw_rule_aiid': 'rules',
  'recommend_raw_rule_uuid': 'rules'
};

  final Set<String> _deleteChildFollowFatherKeysForTwo = <String>{};

  final Set<String> _deleteChildFollowFatherKeysForSingle = <String>{};

  final List<String> _deleteFatherFollowChildKeys =<String>[pn_pending_pool_node_aiid,pn_pending_pool_node_uuid,];

  @override
  String get getCurrentTableName => getTableName;

@override int? get get_id => _rowJson[id] as int?;@override int? get get_aiid => _rowJson[aiid] as int?;@override String? get get_uuid => _rowJson[uuid] as String?; int? get get_raw_fragment_aiid => _rowJson[raw_fragment_aiid] as int?; String? get get_raw_fragment_uuid => _rowJson[raw_fragment_uuid] as String?; int? get get_pn_pending_pool_node_aiid => _rowJson[pn_pending_pool_node_aiid] as int?; String? get get_pn_pending_pool_node_uuid => _rowJson[pn_pending_pool_node_uuid] as String?; int? get get_recommend_raw_rule_aiid => _rowJson[recommend_raw_rule_aiid] as int?; String? get get_recommend_raw_rule_uuid => _rowJson[recommend_raw_rule_uuid] as String?; String? get get_title => _rowJson[title] as String?;@override int? get get_created_at => _rowJson[created_at] as int?;@override int? get get_updated_at => _rowJson[updated_at] as int?;
}
