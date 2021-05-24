// ignore_for_file: non_constant_identifier_names
import 'package:jysp/Database/Models/MBase.dart';
import 'package:jysp/Database/MergeModels/MMBase.dart';



import 'package:jysp/Database/Models/MPnPendingPoolNode.dart';import 'package:jysp/Database/Models/MPnMemoryPoolNode.dart';import 'package:jysp/Database/Models/MPnCompletePoolNode.dart';import 'package:jysp/Database/Models/MPnRulePoolNode.dart';

class MMPoolNode implements MMBase{
  MMPoolNode({required MBase model}) {
    switch (model.runtimeType) {
            case MPnPendingPoolNode:
        mPnPendingPoolNode = model as MPnPendingPoolNode;
      break;      case MPnMemoryPoolNode:
        mPnMemoryPoolNode = model as MPnMemoryPoolNode;
      break;      case MPnCompletePoolNode:
        mPnCompletePoolNode = model as MPnCompletePoolNode;
      break;      case MPnRulePoolNode:
        mPnRulePoolNode = model as MPnRulePoolNode;
      break;
      default:
      throw 'model type is bad';
    }
  }

  MPnPendingPoolNode? mPnPendingPoolNode;MPnMemoryPoolNode? mPnMemoryPoolNode;MPnCompletePoolNode? mPnCompletePoolNode;MPnRulePoolNode? mPnRulePoolNode;

  MBase get model {
        if (mPnPendingPoolNode != null) {
      return mPnPendingPoolNode!;
    }    if (mPnMemoryPoolNode != null) {
      return mPnMemoryPoolNode!;
    }    if (mPnCompletePoolNode != null) {
      return mPnCompletePoolNode!;
    }    if (mPnRulePoolNode != null) {
      return mPnRulePoolNode!;
    }
    throw 'model is not exsit';
  }

  /// [values] 必须严格按照 0-1 对应的模型顺序
  V setValue<V>(List<V Function()> values) {
        if (mPnPendingPoolNode != null) {
      return values[0]();
    }    if (mPnMemoryPoolNode != null) {
      return values[1]();
    }    if (mPnCompletePoolNode != null) {
      return values[2]();
    }    if (mPnRulePoolNode != null) {
      return values[3]();
    }
    throw 'unknown model';
  }

  V Function() argumentErr<V>() {
    throw 'argument err';
  }

  String get getTableName => setValue<String>(
      <String Function()>[
        () => mPnPendingPoolNode!.getTableName,() => mPnMemoryPoolNode!.getTableName,() => mPnCompletePoolNode!.getTableName,() => mPnRulePoolNode!.getTableName,
        ]);
  

      String get id => setValue<String>(
        <String Function()>[
          () => MPnPendingPoolNode.id,() => MPnMemoryPoolNode.id,() => MPnCompletePoolNode.id,() => MPnRulePoolNode.id,
          ]);      String get aiid => setValue<String>(
        <String Function()>[
          () => MPnPendingPoolNode.aiid,() => MPnMemoryPoolNode.aiid,() => MPnCompletePoolNode.aiid,() => MPnRulePoolNode.aiid,
          ]);      String get uuid => setValue<String>(
        <String Function()>[
          () => MPnPendingPoolNode.uuid,() => MPnMemoryPoolNode.uuid,() => MPnCompletePoolNode.uuid,() => MPnRulePoolNode.uuid,
          ]);      String get recommend_rule_aiid => setValue<String>(
        <String Function()>[
          () => MPnPendingPoolNode.recommend_rule_aiid,argumentErr(),argumentErr(),argumentErr(),
          ]);      String get recommend_rule_uuid => setValue<String>(
        <String Function()>[
          () => MPnPendingPoolNode.recommend_rule_uuid,argumentErr(),argumentErr(),argumentErr(),
          ]);      String get type => setValue<String>(
        <String Function()>[
          () => MPnPendingPoolNode.type,() => MPnMemoryPoolNode.type,() => MPnCompletePoolNode.type,() => MPnRulePoolNode.type,
          ]);      String get name => setValue<String>(
        <String Function()>[
          () => MPnPendingPoolNode.name,() => MPnMemoryPoolNode.name,() => MPnCompletePoolNode.name,() => MPnRulePoolNode.name,
          ]);      String get position => setValue<String>(
        <String Function()>[
          () => MPnPendingPoolNode.position,() => MPnMemoryPoolNode.position,() => MPnCompletePoolNode.position,() => MPnRulePoolNode.position,
          ]);      String get created_at => setValue<String>(
        <String Function()>[
          () => MPnPendingPoolNode.created_at,() => MPnMemoryPoolNode.created_at,() => MPnCompletePoolNode.created_at,() => MPnRulePoolNode.created_at,
          ]);      String get updated_at => setValue<String>(
        <String Function()>[
          () => MPnPendingPoolNode.updated_at,() => MPnMemoryPoolNode.updated_at,() => MPnCompletePoolNode.updated_at,() => MPnRulePoolNode.updated_at,
          ]);      String get using_rule_aiid => setValue<String>(
        <String Function()>[
          argumentErr(),() => MPnMemoryPoolNode.using_rule_aiid,argumentErr(),argumentErr(),
          ]);      String get using_rule_uuid => setValue<String>(
        <String Function()>[
          argumentErr(),() => MPnMemoryPoolNode.using_rule_uuid,argumentErr(),argumentErr(),
          ]);      String get used_rule_aiid => setValue<String>(
        <String Function()>[
          argumentErr(),argumentErr(),() => MPnCompletePoolNode.used_rule_aiid,argumentErr(),
          ]);      String get used_rule_uuid => setValue<String>(
        <String Function()>[
          argumentErr(),argumentErr(),() => MPnCompletePoolNode.used_rule_uuid,argumentErr(),
          ]);

  Map<String, Object?> get getRowJson => setValue<Map<String, Object?>>(
      <Map<String, Object?> Function()>[
        () => mPnPendingPoolNode!.getRowJson,() => mPnMemoryPoolNode!.getRowJson,() => mPnCompletePoolNode!.getRowJson,() => mPnRulePoolNode!.getRowJson,
      ]);
  

      int? get get_id => setValue<int?>(
        <int? Function()>[
          () => mPnPendingPoolNode!.get_id,() => mPnMemoryPoolNode!.get_id,() => mPnCompletePoolNode!.get_id,() => mPnRulePoolNode!.get_id,
        ]);      int? get get_aiid => setValue<int?>(
        <int? Function()>[
          () => mPnPendingPoolNode!.get_aiid,() => mPnMemoryPoolNode!.get_aiid,() => mPnCompletePoolNode!.get_aiid,() => mPnRulePoolNode!.get_aiid,
        ]);      String? get get_uuid => setValue<String?>(
        <String? Function()>[
          () => mPnPendingPoolNode!.get_uuid,() => mPnMemoryPoolNode!.get_uuid,() => mPnCompletePoolNode!.get_uuid,() => mPnRulePoolNode!.get_uuid,
        ]);      int? get get_recommend_rule_aiid => setValue<int?>(
        <int? Function()>[
          () => mPnPendingPoolNode!.get_recommend_rule_aiid,argumentErr(),argumentErr(),argumentErr(),
        ]);      String? get get_recommend_rule_uuid => setValue<String?>(
        <String? Function()>[
          () => mPnPendingPoolNode!.get_recommend_rule_uuid,argumentErr(),argumentErr(),argumentErr(),
        ]);      PendingPoolNodeType? get get_type_pn_pending_pool_nodes => setValue<PendingPoolNodeType?>(
        <PendingPoolNodeType? Function()>[
          () => mPnPendingPoolNode!.get_type,argumentErr(),argumentErr(),argumentErr(),
        ]);      MemoryPoolNodeType? get get_type_pn_memory_pool_nodes => setValue<MemoryPoolNodeType?>(
        <MemoryPoolNodeType? Function()>[
          argumentErr(),() => mPnMemoryPoolNode!.get_type,argumentErr(),argumentErr(),
        ]);      CompletePoolNodeType? get get_type_pn_complete_pool_nodes => setValue<CompletePoolNodeType?>(
        <CompletePoolNodeType? Function()>[
          argumentErr(),argumentErr(),() => mPnCompletePoolNode!.get_type,argumentErr(),
        ]);      RulePoolNodeType? get get_type_pn_rule_pool_nodes => setValue<RulePoolNodeType?>(
        <RulePoolNodeType? Function()>[
          argumentErr(),argumentErr(),argumentErr(),() => mPnRulePoolNode!.get_type,
        ]);      String? get get_name => setValue<String?>(
        <String? Function()>[
          () => mPnPendingPoolNode!.get_name,() => mPnMemoryPoolNode!.get_name,() => mPnCompletePoolNode!.get_name,() => mPnRulePoolNode!.get_name,
        ]);      String? get get_position => setValue<String?>(
        <String? Function()>[
          () => mPnPendingPoolNode!.get_position,() => mPnMemoryPoolNode!.get_position,() => mPnCompletePoolNode!.get_position,() => mPnRulePoolNode!.get_position,
        ]);      int? get get_created_at => setValue<int?>(
        <int? Function()>[
          () => mPnPendingPoolNode!.get_created_at,() => mPnMemoryPoolNode!.get_created_at,() => mPnCompletePoolNode!.get_created_at,() => mPnRulePoolNode!.get_created_at,
        ]);      int? get get_updated_at => setValue<int?>(
        <int? Function()>[
          () => mPnPendingPoolNode!.get_updated_at,() => mPnMemoryPoolNode!.get_updated_at,() => mPnCompletePoolNode!.get_updated_at,() => mPnRulePoolNode!.get_updated_at,
        ]);      int? get get_using_rule_aiid => setValue<int?>(
        <int? Function()>[
          argumentErr(),() => mPnMemoryPoolNode!.get_using_rule_aiid,argumentErr(),argumentErr(),
        ]);      String? get get_using_rule_uuid => setValue<String?>(
        <String? Function()>[
          argumentErr(),() => mPnMemoryPoolNode!.get_using_rule_uuid,argumentErr(),argumentErr(),
        ]);      int? get get_used_rule_aiid => setValue<int?>(
        <int? Function()>[
          argumentErr(),argumentErr(),() => mPnCompletePoolNode!.get_used_rule_aiid,argumentErr(),
        ]);      String? get get_used_rule_uuid => setValue<String?>(
        <String? Function()>[
          argumentErr(),argumentErr(),() => mPnCompletePoolNode!.get_used_rule_uuid,argumentErr(),
        ]);

  Set<String> get getDeleteForeignKeyFollowCurrentForSingle => setValue<Set<String>>(<Set<String> Function()>[
        () => mPnPendingPoolNode!.getDeleteForeignKeyFollowCurrentForSingle,() => mPnMemoryPoolNode!.getDeleteForeignKeyFollowCurrentForSingle,() => mPnCompletePoolNode!.getDeleteForeignKeyFollowCurrentForSingle,() => mPnRulePoolNode!.getDeleteForeignKeyFollowCurrentForSingle,
      ]);


  Set<String> get getDeleteForeignKeyFollowCurrentForTwo => setValue<Set<String>>(<Set<String> Function()>[
        () => mPnPendingPoolNode!.getDeleteForeignKeyFollowCurrentForTwo,() => mPnMemoryPoolNode!.getDeleteForeignKeyFollowCurrentForTwo,() => mPnCompletePoolNode!.getDeleteForeignKeyFollowCurrentForTwo,() => mPnRulePoolNode!.getDeleteForeignKeyFollowCurrentForTwo,
      ]);


  List<String> get getDeleteManyForeignKeyForSingle => setValue<List<String>>(<List<String> Function()>[
        () => mPnPendingPoolNode!.getDeleteManyForeignKeyForSingle,() => mPnMemoryPoolNode!.getDeleteManyForeignKeyForSingle,() => mPnCompletePoolNode!.getDeleteManyForeignKeyForSingle,() => mPnRulePoolNode!.getDeleteManyForeignKeyForSingle,
      ]);


  List<String> get getDeleteManyForeignKeyForTwo => setValue<List<String>>(<List<String> Function()>[
        () => mPnPendingPoolNode!.getDeleteManyForeignKeyForTwo,() => mPnMemoryPoolNode!.getDeleteManyForeignKeyForTwo,() => mPnCompletePoolNode!.getDeleteManyForeignKeyForTwo,() => mPnRulePoolNode!.getDeleteManyForeignKeyForTwo,
      ]);


  String? getForeignKeyBelongsTos({required String foreignKeyName}) => setValue<String?>(<String? Function()>[
        () => mPnPendingPoolNode!.getForeignKeyBelongsTos(foreignKeyName: foreignKeyName),() => mPnMemoryPoolNode!.getForeignKeyBelongsTos(foreignKeyName: foreignKeyName),() => mPnCompletePoolNode!.getForeignKeyBelongsTos(foreignKeyName: foreignKeyName),() => mPnRulePoolNode!.getForeignKeyBelongsTos(foreignKeyName: foreignKeyName),
      ]);


}
