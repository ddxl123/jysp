// ignore_for_file: non_constant_identifier_names
import 'package:jysp/database/models/MBase.dart';


enum CompletePoolNodeType {ordinary,}

class MPnCompletePoolNode implements MBase{

  MPnCompletePoolNode();

  /// 1. insert 时，无需传入 id ，id 是自增的。
  /// 2. 若只创建 model 而并非 inset，id 的值为 null。
  MPnCompletePoolNode.createModel({required int? aiid_v,required String? uuid_v,required int? used_rule_aiid_v,required String? used_rule_uuid_v,required CompletePoolNodeType? type_v,required String? name_v,required String? box_position_v,required int? created_at_v,required int? updated_at_v,}) {
    getRowJson.addAll(<String, Object?>{aiid:aiid_v,uuid:uuid_v,used_rule_aiid:used_rule_aiid_v,used_rule_uuid:used_rule_uuid_v,type:type_v?.index,name:name_v,box_position:box_position_v,created_at:created_at_v,updated_at:updated_at_v,});
  }

  static String get tableName => 'pn_complete_pool_nodes';

  static String get id => 'id';
  static String get aiid => 'aiid';
  static String get uuid => 'uuid';
  static String get used_rule_aiid => 'used_rule_aiid';
  static String get used_rule_uuid => 'used_rule_uuid';
  static String get type => 'type';
  static String get name => 'name';
  static String get box_position => 'box_position';
  static String get created_at => 'created_at';
  static String get updated_at => 'updated_at';


  static Map<String, Object?> asJsonNoId({required int? aiid_v,required String? uuid_v,required int? used_rule_aiid_v,required String? used_rule_uuid_v,required CompletePoolNodeType? type_v,required String? name_v,required String? box_position_v,required int? created_at_v,required int? updated_at_v,}
  ) {
    return <String, Object?>{aiid:aiid_v,uuid:uuid_v,used_rule_aiid:used_rule_aiid_v,used_rule_uuid:used_rule_uuid_v,type:type_v?.index,name:name_v,box_position:box_position_v,created_at:created_at_v,updated_at:updated_at_v,};
  }

  static Map<String, Object?> asModelNoId(Map<String, Object?> json) {
    return <String, Object?>{aiid:json[aiid],uuid:json[uuid],used_rule_aiid:json[used_rule_aiid],used_rule_uuid:json[used_rule_uuid],type:json[type] == null ? null : CompletePoolNodeType.values[json[type]! as int],name:json[name],box_position:json[box_position],created_at:json[created_at],updated_at:json[updated_at],};
  }

  // ====================================================================
  // ====================================================================

  @override
  String? getForeignKeyBelongsTos({required String foreignKeyName}) => <String,String?>{used_rule_aiid: 'fragments_about_rule_pool_nodes.aiid',used_rule_uuid: 'fragments_about_rule_pool_nodes.uuid',}[foreignKeyName];

  @override
  Set<String> get getDeleteForeignKeyFollowCurrentForTwo => <String>{};

  @override
  Set<String> get getDeleteForeignKeyFollowCurrentForSingle => <String>{};

  // ====================================================================

  @override
  List<String> get getDeleteManyForeignKeyForTwo => <String>['fragments_about_complete_pool_nodes.pn_complete_pool_node.',];

  @override
  List<String> get getDeleteManyForeignKeyForSingle => <String>[];

  // ====================================================================
  // ====================================================================

  final Map<String, Object?> _rowJson = <String, Object?>{};

  @override
  Map<String, Object?> get getRowJson => _rowJson;


  @override
  String get getTableName => tableName;

@override int? get get_id => getRowJson[id] as int?;@override int? get get_aiid => getRowJson[aiid] as int?;@override String? get get_uuid => getRowJson[uuid] as String?; int? get get_used_rule_aiid => getRowJson[used_rule_aiid] as int?; String? get get_used_rule_uuid => getRowJson[used_rule_uuid] as String?; CompletePoolNodeType? get get_type => getRowJson[type] == null ? null : CompletePoolNodeType.values[getRowJson[type]! as int]; String? get get_name => getRowJson[name] as String?; String? get get_box_position => getRowJson[box_position] as String?;@override int? get get_created_at => getRowJson[created_at] as int?;@override int? get get_updated_at => getRowJson[updated_at] as int?;
}
