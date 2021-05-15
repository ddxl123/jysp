// ignore_for_file: non_constant_identifier_names
import 'package:jysp/Database/Models/MBase.dart';
import 'package:jysp/G/GSqlite/GSqlite.dart';

import 'package:sqflite/sqflite.dart';



class MRule implements MBase{

  MRule();

  /// 1. insert 时，无需传入 id ，id 是自增的。
  /// 2. 若只创建 model 而并非 inset，id 的值为 null。
  MRule.createModel({required int? aiid_v,required String? uuid_v,required int? raw_rule_aiid_v,required String? raw_rule_uuid_v,required int? pn_rule_pool_node_aiid_v,required String? pn_rule_pool_node_uuid_v,required int? created_at_v,required int? updated_at_v,}) {
    _rowJson.addAll(<String, Object?>{aiid:aiid_v,uuid:uuid_v,raw_rule_aiid:raw_rule_aiid_v,raw_rule_uuid:raw_rule_uuid_v,pn_rule_pool_node_aiid:pn_rule_pool_node_aiid_v,pn_rule_pool_node_uuid:pn_rule_pool_node_uuid_v,created_at:created_at_v,updated_at:updated_at_v,});
  }

  static String get getTableName => 'rules';

  static String get id => 'id';
  static String get aiid => 'aiid';
  static String get uuid => 'uuid';
  static String get raw_rule_aiid => 'raw_rule_aiid';
  static String get raw_rule_uuid => 'raw_rule_uuid';
  static String get pn_rule_pool_node_aiid => 'pn_rule_pool_node_aiid';
  static String get pn_rule_pool_node_uuid => 'pn_rule_pool_node_uuid';
  static String get created_at => 'created_at';
  static String get updated_at => 'updated_at';


  static Map<String, Object?> asJsonNoId({required int? aiid_v,required String? uuid_v,required int? raw_rule_aiid_v,required String? raw_rule_uuid_v,required int? pn_rule_pool_node_aiid_v,required String? pn_rule_pool_node_uuid_v,required int? created_at_v,required int? updated_at_v,}
  ) {
    return <String, Object?>{aiid:aiid_v,uuid:uuid_v,raw_rule_aiid:raw_rule_aiid_v,raw_rule_uuid:raw_rule_uuid_v,pn_rule_pool_node_aiid:pn_rule_pool_node_aiid_v,pn_rule_pool_node_uuid:pn_rule_pool_node_uuid_v,created_at:created_at_v,updated_at:updated_at_v,};
  }

  static Map<String, Object?> asModelNoId(Map<String, Object?> json) {
    return <String, Object?>{aiid:json[aiid],uuid:json[uuid],raw_rule_aiid:json[raw_rule_aiid],raw_rule_uuid:json[raw_rule_uuid],pn_rule_pool_node_aiid:json[pn_rule_pool_node_aiid],pn_rule_pool_node_uuid:json[pn_rule_pool_node_uuid],created_at:json[created_at],updated_at:json[updated_at],};
  }


  /// 若 [where]/[whereArgs] 为 null，则 query 的是全部 row。
  static Future<List<Map<String, Object?>>> queryRowsAsJsons({required String? where,required List<Object?>? whereArgs,required Transaction? connectTransaction}) async {
    if(connectTransaction != null)
    {
      return await connectTransaction.query(getTableName, where: where, whereArgs: whereArgs);
    }
    return await db.query(getTableName, where: where, whereArgs: whereArgs);
  }

  /// 若 [where]/[whereArgs] 为 null，则 query 的是全部 row。
  static Future<List<MRule>> queryRowsAsModels({required String? where,required List<Object?>? whereArgs,required Transaction? connectTransaction}) async {
    final List<Map<String, Object?>> rows = await queryRowsAsJsons(where: where, whereArgs: whereArgs,connectTransaction: connectTransaction);
    final List<MRule> rowModels = <MRule>[];
    for (final Map<String, Object?> row in rows) {
        final MRule newRowModel = MRule();
        newRowModel._rowJson.addAll(row);
        rowModels.add(newRowModel);
    }
    return rowModels;
  }

  // ====================================================================
  // ====================================================================

  @override
  String? getForeignKeyBelongsTos({required String foreignKeyName}) => <String,String?>{raw_rule_aiid: null,raw_rule_uuid: null,pn_rule_pool_node_aiid: 'pn_rule_pool_nodes.aiid',pn_rule_pool_node_uuid: 'pn_rule_pool_nodes.uuid',}[foreignKeyName];

  @override
  Set<String> get getDeleteForeignKeyFollowCurrentForTwo => <String>{};

  @override
  Set<String> get getDeleteForeignKeyFollowCurrentForSingle => <String>{};

  // ====================================================================

  @override
  List<String> get getDeleteManyForeignKeyForTwo => <String>[];

  @override
  List<String> get getDeleteManyForeignKeyForSingle => <String>[];

  // ====================================================================
  // ====================================================================

  @override
  Map<String, Object?> get getRowJson => _rowJson;

  final Map<String, Object?> _rowJson = <String, Object?>{};

  @override
  String get getCurrentTableName => getTableName;

@override int? get get_id => _rowJson[id] as int?;@override int? get get_aiid => _rowJson[aiid] as int?;@override String? get get_uuid => _rowJson[uuid] as String?; int? get get_raw_rule_aiid => _rowJson[raw_rule_aiid] as int?; String? get get_raw_rule_uuid => _rowJson[raw_rule_uuid] as String?; int? get get_pn_rule_pool_node_aiid => _rowJson[pn_rule_pool_node_aiid] as int?; String? get get_pn_rule_pool_node_uuid => _rowJson[pn_rule_pool_node_uuid] as String?;@override int? get get_created_at => _rowJson[created_at] as int?;@override int? get get_updated_at => _rowJson[updated_at] as int?;
}
