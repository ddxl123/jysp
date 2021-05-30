// ignore_for_file: non_constant_identifier_names
import 'package:jysp/Database/Models/MBase.dart';


enum PendingPoolNodeType {ordinary,}

class MPnPendingPoolNode implements MBase{

  MPnPendingPoolNode();

  /// 1. insert 时，无需传入 id ，id 是自增的。
  /// 2. 若只创建 model 而并非 inset，id 的值为 null。
  MPnPendingPoolNode.createModel({required int? aiid_v,required String? uuid_v,required int? recommend_rule_aiid_v,required String? recommend_rule_uuid_v,required PendingPoolNodeType? type_v,required String? name_v,required String? box_position_v,required int? created_at_v,required int? updated_at_v,}) {
    getRowJson.addAll(<String, Object?>{aiid:aiid_v,uuid:uuid_v,recommend_rule_aiid:recommend_rule_aiid_v,recommend_rule_uuid:recommend_rule_uuid_v,type:type_v?.index,name:name_v,box_position:box_position_v,created_at:created_at_v,updated_at:updated_at_v,});
  }

  static String get tableName => 'pn_pending_pool_nodes';

  static String get id => 'id';
  static String get aiid => 'aiid';
  static String get uuid => 'uuid';
  static String get recommend_rule_aiid => 'recommend_rule_aiid';
  static String get recommend_rule_uuid => 'recommend_rule_uuid';
  static String get type => 'type';
  static String get name => 'name';
  static String get box_position => 'box_position';
  static String get created_at => 'created_at';
  static String get updated_at => 'updated_at';


  static Map<String, Object?> asJsonNoId({required int? aiid_v,required String? uuid_v,required int? recommend_rule_aiid_v,required String? recommend_rule_uuid_v,required PendingPoolNodeType? type_v,required String? name_v,required String? box_position_v,required int? created_at_v,required int? updated_at_v,}
  ) {
    return <String, Object?>{aiid:aiid_v,uuid:uuid_v,recommend_rule_aiid:recommend_rule_aiid_v,recommend_rule_uuid:recommend_rule_uuid_v,type:type_v?.index,name:name_v,box_position:box_position_v,created_at:created_at_v,updated_at:updated_at_v,};
  }

  static Map<String, Object?> asModelNoId(Map<String, Object?> json) {
    return <String, Object?>{aiid:json[aiid],uuid:json[uuid],recommend_rule_aiid:json[recommend_rule_aiid],recommend_rule_uuid:json[recommend_rule_uuid],type:json[type] == null ? null : PendingPoolNodeType.values[json[type]! as int],name:json[name],box_position:json[box_position],created_at:json[created_at],updated_at:json[updated_at],};
  }

  // ====================================================================
  // ====================================================================

  @override
  String? getForeignKeyBelongsTos({required String foreignKeyName}) => <String,String?>{recommend_rule_aiid: 'fragments_about_rule_pool_nodes.aiid',recommend_rule_uuid: 'fragments_about_rule_pool_nodes.uuid',}[foreignKeyName];

  @override
  Set<String> get getDeleteForeignKeyFollowCurrentForTwo => <String>{};

  @override
  Set<String> get getDeleteForeignKeyFollowCurrentForSingle => <String>{};

  // ====================================================================

  @override
  List<String> get getDeleteManyForeignKeyForTwo => <String>['fragments_about_pending_pool_nodes.pn_pending_pool_node.',];

  @override
  List<String> get getDeleteManyForeignKeyForSingle => <String>[];

  // ====================================================================
  // ====================================================================

  final Map<String, Object?> _rowJson = <String, Object?>{};

  @override
  Map<String, Object?> get getRowJson => _rowJson;


  @override
  String get getTableName => tableName;

@override int? get get_id => getRowJson[id] as int?;@override int? get get_aiid => getRowJson[aiid] as int?;@override String? get get_uuid => getRowJson[uuid] as String?; int? get get_recommend_rule_aiid => getRowJson[recommend_rule_aiid] as int?; String? get get_recommend_rule_uuid => getRowJson[recommend_rule_uuid] as String?; PendingPoolNodeType? get get_type => getRowJson[type] == null ? null : PendingPoolNodeType.values[getRowJson[type]! as int]; String? get get_name => getRowJson[name] as String?; String? get get_box_position => getRowJson[box_position] as String?;@override int? get get_created_at => getRowJson[created_at] as int?;@override int? get get_updated_at => getRowJson[updated_at] as int?;
}
