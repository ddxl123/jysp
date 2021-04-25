// ignore_for_file: non_constant_identifier_names
import 'package:jysp/Database/Base/MBase.dart';
import 'package:jysp/G/GSqlite/GSqlite.dart';

enum CompletePoolNodeType {ordinary,}
class MPnCompletePoolNode implements MBase{

  MPnCompletePoolNode();

  /// 1. insert 时，无需传入 id ，id 是自增的。
  /// 2. 若只创建 model 而并非 inset，id 的值为 null。
  MPnCompletePoolNode.createModel({required int? atid_v,required String? uuid_v,required int? used_raw_rule_atid_v,required String? used_raw_rule_uuid_v,required CompletePoolNodeType? type_v,required String? name_v,required String? position_v,required int? created_at_v,required int? updated_at_v,}) {
    _rowJson.addAll(<String, Object?>{atid:atid_v,uuid:uuid_v,used_raw_rule_atid:used_raw_rule_atid_v,used_raw_rule_uuid:used_raw_rule_uuid_v,type:type_v?.index,name:name_v,position:position_v,created_at:created_at_v,updated_at:updated_at_v,});
  }

  static String get getTableName => 'pn_complete_pool_nodes';

  static String get id => 'id';
  static String get atid => 'atid';
  static String get uuid => 'uuid';
  static String get used_raw_rule_atid => 'used_raw_rule_atid';
  static String get used_raw_rule_uuid => 'used_raw_rule_uuid';
  static String get type => 'type';
  static String get name => 'name';
  static String get position => 'position';
  static String get created_at => 'created_at';
  static String get updated_at => 'updated_at';


  static Map<String, Object?> asJsonNoId({required int? atid_v,required String? uuid_v,required int? used_raw_rule_atid_v,required String? used_raw_rule_uuid_v,required CompletePoolNodeType? type_v,required String? name_v,required String? position_v,required int? created_at_v,required int? updated_at_v,}
  ) {
    return <String, Object?>{atid:atid_v,uuid:uuid_v,used_raw_rule_atid:used_raw_rule_atid_v,used_raw_rule_uuid:used_raw_rule_uuid_v,type:type_v?.index,name:name_v,position:position_v,created_at:created_at_v,updated_at:updated_at_v,};
  }

  static Map<String, Object?> asModelNoId(Map<String, Object?> json) {
    return <String, Object?>{atid:json[atid],uuid:json[uuid],used_raw_rule_atid:json[used_raw_rule_atid],used_raw_rule_uuid:json[used_raw_rule_uuid],type:json[type] == null ? null : CompletePoolNodeType.values[json[type]! as int],name:json[name],position:json[position],created_at:json[created_at],updated_at:json[updated_at],};
  }

  /// 若 [byId] 为 null，则 query 的是全部 row。
  static Future<List<Map<String, Object?>>> queryRowsAsJsons([int? byId]) async {
    if (byId == null) {
      return await db.query(getTableName);
    } else {
      return await db.query(getTableName, where: 'id = ?', whereArgs: <int>[byId]);
    }
  }

  /// 若 [byId] 为 null，则 query 的是全部 row。
  static Future<List<MPnCompletePoolNode>> queryRowsAsModels([int? byId]) async {
    final List<Map<String, Object?>> rows = await queryRowsAsJsons(byId);
    final List<MPnCompletePoolNode> rowModels = <MPnCompletePoolNode>[];
    for (final Map<String, Object?> row in rows) {
        final MPnCompletePoolNode newRowModel = MPnCompletePoolNode();
        newRowModel._rowJson.addAll(row);
        rowModels.add(newRowModel);
    }
    return rowModels;
  }

  @override
  Map<String, Object?> get getRowJson => _rowJson;

  @override
  Map<String, String?> get getForeignKeyTableNames => _foreignKeyTableNames;

  @override
  List<String> get getDeleteChildFollowFathers => _deleteChildFollowFathers;

  @override
  List<String> get getDeleteFatherFollowChilds => _deleteFatherFollowChilds;

  final Map<String, Object?> _rowJson = <String, Object?>{};

  final Map<String, String?> _foreignKeyTableNames = <String, String?>{
  'used_raw_rule_atid': 'rules',
  'used_raw_rule_uuid': 'rules'
};

  final List<String> _deleteChildFollowFathers = <String>[];

  final List<String> _deleteFatherFollowChilds =<String>[];

  @override
  String get getCurrentTableName => getTableName;

@override int? get get_id => _rowJson[id] as int?;@override int? get get_atid => _rowJson[atid] as int?;@override String? get get_uuid => _rowJson[uuid] as String?; int? get get_used_raw_rule_atid => _rowJson[used_raw_rule_atid] as int?; String? get get_used_raw_rule_uuid => _rowJson[used_raw_rule_uuid] as String?; CompletePoolNodeType? get get_type => _rowJson[type] == null ? null : CompletePoolNodeType.values[_rowJson[type]! as int]; String? get get_name => _rowJson[name] as String?; String? get get_position => _rowJson[position] as String?;@override int? get get_created_at => _rowJson[created_at] as int?;@override int? get get_updated_at => _rowJson[updated_at] as int?;
}
