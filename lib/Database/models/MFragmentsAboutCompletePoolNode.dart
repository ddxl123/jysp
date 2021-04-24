// ignore_for_file: non_constant_identifier_names
import 'package:jysp/Database/Base/MBase.dart';
import 'package:jysp/G/GSqlite/GSqlite.dart';


class MFragmentsAboutCompletePoolNode implements MBase{

  MFragmentsAboutCompletePoolNode();

  /// 1. insert 时，无需传入 id ，id 是自增的。
  /// 2. 若只创建 model 而并非 inset，id 的值为 null。
  MFragmentsAboutCompletePoolNode.createModel({required int? atid_v,required String? uuid_v,required int? fragments_about_pending_pool_node_atid_v,required String? fragments_about_pending_pool_node_uuid_v,required int? used_raw_rule_atid_v,required String? used_raw_rule_uuid_v,required int? pn_complete_pool_node_atid_v,required String? pn_complete_pool_node_uuid_v,required int? created_at_v,required int? updated_at_v,}) {
    _rowJson.addAll(<String, Object?>{atid:atid_v,uuid:uuid_v,fragments_about_pending_pool_node_atid:fragments_about_pending_pool_node_atid_v,fragments_about_pending_pool_node_uuid:fragments_about_pending_pool_node_uuid_v,used_raw_rule_atid:used_raw_rule_atid_v,used_raw_rule_uuid:used_raw_rule_uuid_v,pn_complete_pool_node_atid:pn_complete_pool_node_atid_v,pn_complete_pool_node_uuid:pn_complete_pool_node_uuid_v,created_at:created_at_v,updated_at:updated_at_v,});
  }

  static String get getTableName => 'fragments_about_complete_pool_nodes';

  static String get id => 'id';
  static String get atid => 'atid';
  static String get uuid => 'uuid';
  static String get fragments_about_pending_pool_node_atid => 'fragments_about_pending_pool_node_atid';
  static String get fragments_about_pending_pool_node_uuid => 'fragments_about_pending_pool_node_uuid';
  static String get used_raw_rule_atid => 'used_raw_rule_atid';
  static String get used_raw_rule_uuid => 'used_raw_rule_uuid';
  static String get pn_complete_pool_node_atid => 'pn_complete_pool_node_atid';
  static String get pn_complete_pool_node_uuid => 'pn_complete_pool_node_uuid';
  static String get created_at => 'created_at';
  static String get updated_at => 'updated_at';


  static Map<String, Object?> asJsonNoId({required int? atid_v,required String? uuid_v,required int? fragments_about_pending_pool_node_atid_v,required String? fragments_about_pending_pool_node_uuid_v,required int? used_raw_rule_atid_v,required String? used_raw_rule_uuid_v,required int? pn_complete_pool_node_atid_v,required String? pn_complete_pool_node_uuid_v,required int? created_at_v,required int? updated_at_v,}
  ) {
    return <String, Object?>{atid:atid_v,uuid:uuid_v,fragments_about_pending_pool_node_atid:fragments_about_pending_pool_node_atid_v,fragments_about_pending_pool_node_uuid:fragments_about_pending_pool_node_uuid_v,used_raw_rule_atid:used_raw_rule_atid_v,used_raw_rule_uuid:used_raw_rule_uuid_v,pn_complete_pool_node_atid:pn_complete_pool_node_atid_v,pn_complete_pool_node_uuid:pn_complete_pool_node_uuid_v,created_at:created_at_v,updated_at:updated_at_v,};
  }

  static Map<String, Object?> asModelNoId(Map<String, Object?> json) {
    return <String, Object?>{atid:json[atid],uuid:json[uuid],fragments_about_pending_pool_node_atid:json[fragments_about_pending_pool_node_atid],fragments_about_pending_pool_node_uuid:json[fragments_about_pending_pool_node_uuid],used_raw_rule_atid:json[used_raw_rule_atid],used_raw_rule_uuid:json[used_raw_rule_uuid],pn_complete_pool_node_atid:json[pn_complete_pool_node_atid],pn_complete_pool_node_uuid:json[pn_complete_pool_node_uuid],created_at:json[created_at],updated_at:json[updated_at],};
  }

  static Future<List<Map<String, Object?>>> getAllRowsAsJson() async {
    return await db.query(getTableName);
  }

  static Future<List<MFragmentsAboutCompletePoolNode>> getAllRowsAsModel() async {
    final List<Map<String, Object?>> allRows = await getAllRowsAsJson();
    final List<MFragmentsAboutCompletePoolNode> allRowModels = <MFragmentsAboutCompletePoolNode>[];
    for (final Map<String, Object?> row in allRows) {
        final MFragmentsAboutCompletePoolNode newRowModel = MFragmentsAboutCompletePoolNode();
        newRowModel._rowJson.addAll(row);
        allRowModels.add(newRowModel);
    }
    return allRowModels;
  }

  @override
  Map<String, Object?> get getRowJson => _rowJson;

  @override
  Map<String, String?> get getForeignKeyTables => _foreignKeyTables;

  @override
  List<String> get getDeleteChildFollowFathers => _deleteChildFollowFathers;

  @override
  List<String> get getDeleteFatherFollowChilds => _deleteFatherFollowChilds;

  final Map<String, Object?> _rowJson = <String, Object?>{};

  final Map<String, String?> _foreignKeyTables = <String, String?>{
  'fragments_about_pending_pool_node_atid': 'fragments_about_pending_pool_nodes',
  'fragments_about_pending_pool_node_uuid': 'fragments_about_pending_pool_nodes',
  'used_raw_rule_atid': 'rules',
  'used_raw_rule_uuid': 'rules',
  'pn_complete_pool_node_atid': 'pn_complete_pool_nodes',
  'pn_complete_pool_node_uuid': 'pn_complete_pool_nodes'
};

  final List<String> _deleteChildFollowFathers = <String>[];

  final List<String> _deleteFatherFollowChilds =<String>[fragments_about_pending_pool_node_atid,fragments_about_pending_pool_node_uuid,pn_complete_pool_node_atid,pn_complete_pool_node_uuid,];

  @override
  String get getCurrentTableName => getTableName;

@override int? get get_id => _rowJson[id] as int?;@override int? get get_atid => _rowJson[atid] as int?;@override String? get get_uuid => _rowJson[uuid] as String?; int? get get_fragments_about_pending_pool_node_atid => _rowJson[fragments_about_pending_pool_node_atid] as int?; String? get get_fragments_about_pending_pool_node_uuid => _rowJson[fragments_about_pending_pool_node_uuid] as String?; int? get get_used_raw_rule_atid => _rowJson[used_raw_rule_atid] as int?; String? get get_used_raw_rule_uuid => _rowJson[used_raw_rule_uuid] as String?; int? get get_pn_complete_pool_node_atid => _rowJson[pn_complete_pool_node_atid] as int?; String? get get_pn_complete_pool_node_uuid => _rowJson[pn_complete_pool_node_uuid] as String?;@override int? get get_created_at => _rowJson[created_at] as int?;@override int? get get_updated_at => _rowJson[updated_at] as int?;
}
