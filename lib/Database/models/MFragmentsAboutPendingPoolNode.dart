// ignore_for_file: non_constant_identifier_names
import 'package:jysp/Database/Base/MBase.dart';
import 'package:jysp/G/GSqlite/GSqlite.dart';


class MFragmentsAboutPendingPoolNode implements MBase{

  MFragmentsAboutPendingPoolNode();

  /// 1. insert 时，无需传入 id ，id 是自增的。
  /// 2. 若只创建 model 而并非 inset，id 的值为 null。
  MFragmentsAboutPendingPoolNode.createModel({required int? atid_v,required String? uuid_v,required int? raw_fragment_atid_v,required String? raw_fragment_uuid_v,required int? pn_pending_pool_node_atid_v,required String? pn_pending_pool_node_uuid_v,required int? recommend_raw_rule_atid_v,required String? recommend_raw_rule_uuid_v,required String? title_v,required int? created_at_v,required int? updated_at_v,}) {
    _rowJson.addAll(<String, Object?>{atid:atid_v,uuid:uuid_v,raw_fragment_atid:raw_fragment_atid_v,raw_fragment_uuid:raw_fragment_uuid_v,pn_pending_pool_node_atid:pn_pending_pool_node_atid_v,pn_pending_pool_node_uuid:pn_pending_pool_node_uuid_v,recommend_raw_rule_atid:recommend_raw_rule_atid_v,recommend_raw_rule_uuid:recommend_raw_rule_uuid_v,title:title_v,created_at:created_at_v,updated_at:updated_at_v,});
  }

  static String get getTableName => 'fragments_about_pending_pool_nodes';

  static String get id => 'id';
  static String get atid => 'atid';
  static String get uuid => 'uuid';
  static String get raw_fragment_atid => 'raw_fragment_atid';
  static String get raw_fragment_uuid => 'raw_fragment_uuid';
  static String get pn_pending_pool_node_atid => 'pn_pending_pool_node_atid';
  static String get pn_pending_pool_node_uuid => 'pn_pending_pool_node_uuid';
  static String get recommend_raw_rule_atid => 'recommend_raw_rule_atid';
  static String get recommend_raw_rule_uuid => 'recommend_raw_rule_uuid';
  static String get title => 'title';
  static String get created_at => 'created_at';
  static String get updated_at => 'updated_at';


  static Map<String, Object?> asJsonNoId({required int? atid_v,required String? uuid_v,required int? raw_fragment_atid_v,required String? raw_fragment_uuid_v,required int? pn_pending_pool_node_atid_v,required String? pn_pending_pool_node_uuid_v,required int? recommend_raw_rule_atid_v,required String? recommend_raw_rule_uuid_v,required String? title_v,required int? created_at_v,required int? updated_at_v,}
  ) {
    return <String, Object?>{atid:atid_v,uuid:uuid_v,raw_fragment_atid:raw_fragment_atid_v,raw_fragment_uuid:raw_fragment_uuid_v,pn_pending_pool_node_atid:pn_pending_pool_node_atid_v,pn_pending_pool_node_uuid:pn_pending_pool_node_uuid_v,recommend_raw_rule_atid:recommend_raw_rule_atid_v,recommend_raw_rule_uuid:recommend_raw_rule_uuid_v,title:title_v,created_at:created_at_v,updated_at:updated_at_v,};
  }

  static Map<String, Object?> asModelNoId(Map<String, Object?> json) {
    return <String, Object?>{atid:json[atid],uuid:json[uuid],raw_fragment_atid:json[raw_fragment_atid],raw_fragment_uuid:json[raw_fragment_uuid],pn_pending_pool_node_atid:json[pn_pending_pool_node_atid],pn_pending_pool_node_uuid:json[pn_pending_pool_node_uuid],recommend_raw_rule_atid:json[recommend_raw_rule_atid],recommend_raw_rule_uuid:json[recommend_raw_rule_uuid],title:json[title],created_at:json[created_at],updated_at:json[updated_at],};
  }

  static Future<List<Map<String, Object?>>> getAllRowsAsJson() async {
    return await db.query(getTableName);
  }

  static Future<List<MFragmentsAboutPendingPoolNode>> getAllRowsAsModel() async {
    final List<Map<String, Object?>> allRows = await getAllRowsAsJson();
    final List<MFragmentsAboutPendingPoolNode> allRowModels = <MFragmentsAboutPendingPoolNode>[];
    for (final Map<String, Object?> row in allRows) {
        final MFragmentsAboutPendingPoolNode newRowModel = MFragmentsAboutPendingPoolNode();
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
  'raw_fragment_atid': null,
  'raw_fragment_uuid': null,
  'pn_pending_pool_node_atid': 'pn_pending_pool_nodes',
  'pn_pending_pool_node_uuid': 'pn_pending_pool_nodes',
  'recommend_raw_rule_atid': 'rules',
  'recommend_raw_rule_uuid': 'rules'
};

  final List<String> _deleteChildFollowFathers = <String>[];

  final List<String> _deleteFatherFollowChilds =<String>[pn_pending_pool_node_atid,pn_pending_pool_node_uuid,];

  @override
  String get getCurrentTableName => getTableName;

@override int? get get_id => _rowJson[id] as int?;@override int? get get_atid => _rowJson[atid] as int?;@override String? get get_uuid => _rowJson[uuid] as String?; int? get get_raw_fragment_atid => _rowJson[raw_fragment_atid] as int?; String? get get_raw_fragment_uuid => _rowJson[raw_fragment_uuid] as String?; int? get get_pn_pending_pool_node_atid => _rowJson[pn_pending_pool_node_atid] as int?; String? get get_pn_pending_pool_node_uuid => _rowJson[pn_pending_pool_node_uuid] as String?; int? get get_recommend_raw_rule_atid => _rowJson[recommend_raw_rule_atid] as int?; String? get get_recommend_raw_rule_uuid => _rowJson[recommend_raw_rule_uuid] as String?; String? get get_title => _rowJson[title] as String?;@override int? get get_created_at => _rowJson[created_at] as int?;@override int? get get_updated_at => _rowJson[updated_at] as int?;
}
