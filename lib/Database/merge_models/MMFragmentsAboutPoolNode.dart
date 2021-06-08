// ignore_for_file: non_constant_identifier_names
import 'package:jysp/database/models/MBase.dart';
import 'package:jysp/database/merge_models/MMBase.dart';



import 'package:jysp/database/models/MFragmentsAboutPendingPoolNode.dart';import 'package:jysp/database/models/MFragmentsAboutMemoryPoolNode.dart';import 'package:jysp/database/models/MFragmentsAboutCompletePoolNode.dart';import 'package:jysp/database/models/MFragmentsAboutRulePoolNode.dart';

class MMFragmentsAboutPoolNode implements MMBase{
  MMFragmentsAboutPoolNode({required MBase model}) {
    switch (model.runtimeType) {
            case MFragmentsAboutPendingPoolNode:
        mFragmentsAboutPendingPoolNode = model as MFragmentsAboutPendingPoolNode;
      break;      case MFragmentsAboutMemoryPoolNode:
        mFragmentsAboutMemoryPoolNode = model as MFragmentsAboutMemoryPoolNode;
      break;      case MFragmentsAboutCompletePoolNode:
        mFragmentsAboutCompletePoolNode = model as MFragmentsAboutCompletePoolNode;
      break;      case MFragmentsAboutRulePoolNode:
        mFragmentsAboutRulePoolNode = model as MFragmentsAboutRulePoolNode;
      break;
      default:
      throw 'model type is bad';
    }
  }

  MFragmentsAboutPendingPoolNode? mFragmentsAboutPendingPoolNode;MFragmentsAboutMemoryPoolNode? mFragmentsAboutMemoryPoolNode;MFragmentsAboutCompletePoolNode? mFragmentsAboutCompletePoolNode;MFragmentsAboutRulePoolNode? mFragmentsAboutRulePoolNode;

  MBase get model {
        if (mFragmentsAboutPendingPoolNode != null) {
      return mFragmentsAboutPendingPoolNode!;
    }    if (mFragmentsAboutMemoryPoolNode != null) {
      return mFragmentsAboutMemoryPoolNode!;
    }    if (mFragmentsAboutCompletePoolNode != null) {
      return mFragmentsAboutCompletePoolNode!;
    }    if (mFragmentsAboutRulePoolNode != null) {
      return mFragmentsAboutRulePoolNode!;
    }
    throw 'model is not exsit';
  }

  /// [values] 必须严格按照 0-1 对应的模型顺序
  V setValue<V>(List<V Function()> values) {
        if (mFragmentsAboutPendingPoolNode != null) {
      return values[0]();
    }    if (mFragmentsAboutMemoryPoolNode != null) {
      return values[1]();
    }    if (mFragmentsAboutCompletePoolNode != null) {
      return values[2]();
    }    if (mFragmentsAboutRulePoolNode != null) {
      return values[3]();
    }
    throw 'unknown model';
  }

  V Function() argumentErr<V>() {
    throw 'argument err';
  }

  String get getTableName => setValue<String>(
      <String Function()>[
        () => mFragmentsAboutPendingPoolNode!.getTableName,() => mFragmentsAboutMemoryPoolNode!.getTableName,() => mFragmentsAboutCompletePoolNode!.getTableName,() => mFragmentsAboutRulePoolNode!.getTableName,
        ]);
  

      String get id => setValue<String>(
        <String Function()>[
          () => MFragmentsAboutPendingPoolNode.id,() => MFragmentsAboutMemoryPoolNode.id,() => MFragmentsAboutCompletePoolNode.id,() => MFragmentsAboutRulePoolNode.id,
          ]);      String get aiid => setValue<String>(
        <String Function()>[
          () => MFragmentsAboutPendingPoolNode.aiid,() => MFragmentsAboutMemoryPoolNode.aiid,() => MFragmentsAboutCompletePoolNode.aiid,() => MFragmentsAboutRulePoolNode.aiid,
          ]);      String get uuid => setValue<String>(
        <String Function()>[
          () => MFragmentsAboutPendingPoolNode.uuid,() => MFragmentsAboutMemoryPoolNode.uuid,() => MFragmentsAboutCompletePoolNode.uuid,() => MFragmentsAboutRulePoolNode.uuid,
          ]);      String get raw_fragment_aiid => setValue<String>(
        <String Function()>[
          () => MFragmentsAboutPendingPoolNode.raw_fragment_aiid,argumentErr(),argumentErr(),argumentErr(),
          ]);      String get raw_fragment_uuid => setValue<String>(
        <String Function()>[
          () => MFragmentsAboutPendingPoolNode.raw_fragment_uuid,argumentErr(),argumentErr(),argumentErr(),
          ]);      String get pn_pending_pool_node_aiid => setValue<String>(
        <String Function()>[
          () => MFragmentsAboutPendingPoolNode.pn_pending_pool_node_aiid,argumentErr(),argumentErr(),argumentErr(),
          ]);      String get pn_pending_pool_node_uuid => setValue<String>(
        <String Function()>[
          () => MFragmentsAboutPendingPoolNode.pn_pending_pool_node_uuid,argumentErr(),argumentErr(),argumentErr(),
          ]);      String get recommend_rule_aiid => setValue<String>(
        <String Function()>[
          () => MFragmentsAboutPendingPoolNode.recommend_rule_aiid,argumentErr(),argumentErr(),argumentErr(),
          ]);      String get recommend_rule_uuid => setValue<String>(
        <String Function()>[
          () => MFragmentsAboutPendingPoolNode.recommend_rule_uuid,argumentErr(),argumentErr(),argumentErr(),
          ]);      String get title => setValue<String>(
        <String Function()>[
          () => MFragmentsAboutPendingPoolNode.title,() => MFragmentsAboutMemoryPoolNode.title,() => MFragmentsAboutCompletePoolNode.title,() => MFragmentsAboutRulePoolNode.title,
          ]);      String get created_at => setValue<String>(
        <String Function()>[
          () => MFragmentsAboutPendingPoolNode.created_at,() => MFragmentsAboutMemoryPoolNode.created_at,() => MFragmentsAboutCompletePoolNode.created_at,() => MFragmentsAboutRulePoolNode.created_at,
          ]);      String get updated_at => setValue<String>(
        <String Function()>[
          () => MFragmentsAboutPendingPoolNode.updated_at,() => MFragmentsAboutMemoryPoolNode.updated_at,() => MFragmentsAboutCompletePoolNode.updated_at,() => MFragmentsAboutRulePoolNode.updated_at,
          ]);      String get fragments_about_pending_pool_node_aiid => setValue<String>(
        <String Function()>[
          argumentErr(),() => MFragmentsAboutMemoryPoolNode.fragments_about_pending_pool_node_aiid,() => MFragmentsAboutCompletePoolNode.fragments_about_pending_pool_node_aiid,argumentErr(),
          ]);      String get fragments_about_pending_pool_node_uuid => setValue<String>(
        <String Function()>[
          argumentErr(),() => MFragmentsAboutMemoryPoolNode.fragments_about_pending_pool_node_uuid,() => MFragmentsAboutCompletePoolNode.fragments_about_pending_pool_node_uuid,argumentErr(),
          ]);      String get using_rule_aiid => setValue<String>(
        <String Function()>[
          argumentErr(),() => MFragmentsAboutMemoryPoolNode.using_rule_aiid,argumentErr(),argumentErr(),
          ]);      String get using_rule_uuid => setValue<String>(
        <String Function()>[
          argumentErr(),() => MFragmentsAboutMemoryPoolNode.using_rule_uuid,argumentErr(),argumentErr(),
          ]);      String get pn_memory_pool_node_aiid => setValue<String>(
        <String Function()>[
          argumentErr(),() => MFragmentsAboutMemoryPoolNode.pn_memory_pool_node_aiid,argumentErr(),argumentErr(),
          ]);      String get pn_memory_pool_node_uuid => setValue<String>(
        <String Function()>[
          argumentErr(),() => MFragmentsAboutMemoryPoolNode.pn_memory_pool_node_uuid,argumentErr(),argumentErr(),
          ]);      String get used_rule_aiid => setValue<String>(
        <String Function()>[
          argumentErr(),argumentErr(),() => MFragmentsAboutCompletePoolNode.used_rule_aiid,argumentErr(),
          ]);      String get used_rule_uuid => setValue<String>(
        <String Function()>[
          argumentErr(),argumentErr(),() => MFragmentsAboutCompletePoolNode.used_rule_uuid,argumentErr(),
          ]);      String get pn_complete_pool_node_aiid => setValue<String>(
        <String Function()>[
          argumentErr(),argumentErr(),() => MFragmentsAboutCompletePoolNode.pn_complete_pool_node_aiid,argumentErr(),
          ]);      String get pn_complete_pool_node_uuid => setValue<String>(
        <String Function()>[
          argumentErr(),argumentErr(),() => MFragmentsAboutCompletePoolNode.pn_complete_pool_node_uuid,argumentErr(),
          ]);      String get raw_rule_aiid => setValue<String>(
        <String Function()>[
          argumentErr(),argumentErr(),argumentErr(),() => MFragmentsAboutRulePoolNode.raw_rule_aiid,
          ]);      String get raw_rule_uuid => setValue<String>(
        <String Function()>[
          argumentErr(),argumentErr(),argumentErr(),() => MFragmentsAboutRulePoolNode.raw_rule_uuid,
          ]);      String get pn_rule_pool_node_aiid => setValue<String>(
        <String Function()>[
          argumentErr(),argumentErr(),argumentErr(),() => MFragmentsAboutRulePoolNode.pn_rule_pool_node_aiid,
          ]);      String get pn_rule_pool_node_uuid => setValue<String>(
        <String Function()>[
          argumentErr(),argumentErr(),argumentErr(),() => MFragmentsAboutRulePoolNode.pn_rule_pool_node_uuid,
          ]);

  Map<String, Object?> get getRowJson => setValue<Map<String, Object?>>(
      <Map<String, Object?> Function()>[
        () => mFragmentsAboutPendingPoolNode!.getRowJson,() => mFragmentsAboutMemoryPoolNode!.getRowJson,() => mFragmentsAboutCompletePoolNode!.getRowJson,() => mFragmentsAboutRulePoolNode!.getRowJson,
      ]);
  

      int? get get_id => setValue<int?>(
        <int? Function()>[
          () => mFragmentsAboutPendingPoolNode!.get_id,() => mFragmentsAboutMemoryPoolNode!.get_id,() => mFragmentsAboutCompletePoolNode!.get_id,() => mFragmentsAboutRulePoolNode!.get_id,
        ]);      int? get get_aiid => setValue<int?>(
        <int? Function()>[
          () => mFragmentsAboutPendingPoolNode!.get_aiid,() => mFragmentsAboutMemoryPoolNode!.get_aiid,() => mFragmentsAboutCompletePoolNode!.get_aiid,() => mFragmentsAboutRulePoolNode!.get_aiid,
        ]);      String? get get_uuid => setValue<String?>(
        <String? Function()>[
          () => mFragmentsAboutPendingPoolNode!.get_uuid,() => mFragmentsAboutMemoryPoolNode!.get_uuid,() => mFragmentsAboutCompletePoolNode!.get_uuid,() => mFragmentsAboutRulePoolNode!.get_uuid,
        ]);      int? get get_raw_fragment_aiid => setValue<int?>(
        <int? Function()>[
          () => mFragmentsAboutPendingPoolNode!.get_raw_fragment_aiid,argumentErr(),argumentErr(),argumentErr(),
        ]);      String? get get_raw_fragment_uuid => setValue<String?>(
        <String? Function()>[
          () => mFragmentsAboutPendingPoolNode!.get_raw_fragment_uuid,argumentErr(),argumentErr(),argumentErr(),
        ]);      int? get get_pn_pending_pool_node_aiid => setValue<int?>(
        <int? Function()>[
          () => mFragmentsAboutPendingPoolNode!.get_pn_pending_pool_node_aiid,argumentErr(),argumentErr(),argumentErr(),
        ]);      String? get get_pn_pending_pool_node_uuid => setValue<String?>(
        <String? Function()>[
          () => mFragmentsAboutPendingPoolNode!.get_pn_pending_pool_node_uuid,argumentErr(),argumentErr(),argumentErr(),
        ]);      int? get get_recommend_rule_aiid => setValue<int?>(
        <int? Function()>[
          () => mFragmentsAboutPendingPoolNode!.get_recommend_rule_aiid,argumentErr(),argumentErr(),argumentErr(),
        ]);      String? get get_recommend_rule_uuid => setValue<String?>(
        <String? Function()>[
          () => mFragmentsAboutPendingPoolNode!.get_recommend_rule_uuid,argumentErr(),argumentErr(),argumentErr(),
        ]);      String? get get_title => setValue<String?>(
        <String? Function()>[
          () => mFragmentsAboutPendingPoolNode!.get_title,() => mFragmentsAboutMemoryPoolNode!.get_title,() => mFragmentsAboutCompletePoolNode!.get_title,() => mFragmentsAboutRulePoolNode!.get_title,
        ]);      int? get get_created_at => setValue<int?>(
        <int? Function()>[
          () => mFragmentsAboutPendingPoolNode!.get_created_at,() => mFragmentsAboutMemoryPoolNode!.get_created_at,() => mFragmentsAboutCompletePoolNode!.get_created_at,() => mFragmentsAboutRulePoolNode!.get_created_at,
        ]);      int? get get_updated_at => setValue<int?>(
        <int? Function()>[
          () => mFragmentsAboutPendingPoolNode!.get_updated_at,() => mFragmentsAboutMemoryPoolNode!.get_updated_at,() => mFragmentsAboutCompletePoolNode!.get_updated_at,() => mFragmentsAboutRulePoolNode!.get_updated_at,
        ]);      int? get get_fragments_about_pending_pool_node_aiid => setValue<int?>(
        <int? Function()>[
          argumentErr(),() => mFragmentsAboutMemoryPoolNode!.get_fragments_about_pending_pool_node_aiid,() => mFragmentsAboutCompletePoolNode!.get_fragments_about_pending_pool_node_aiid,argumentErr(),
        ]);      String? get get_fragments_about_pending_pool_node_uuid => setValue<String?>(
        <String? Function()>[
          argumentErr(),() => mFragmentsAboutMemoryPoolNode!.get_fragments_about_pending_pool_node_uuid,() => mFragmentsAboutCompletePoolNode!.get_fragments_about_pending_pool_node_uuid,argumentErr(),
        ]);      int? get get_using_rule_aiid => setValue<int?>(
        <int? Function()>[
          argumentErr(),() => mFragmentsAboutMemoryPoolNode!.get_using_rule_aiid,argumentErr(),argumentErr(),
        ]);      String? get get_using_rule_uuid => setValue<String?>(
        <String? Function()>[
          argumentErr(),() => mFragmentsAboutMemoryPoolNode!.get_using_rule_uuid,argumentErr(),argumentErr(),
        ]);      int? get get_pn_memory_pool_node_aiid => setValue<int?>(
        <int? Function()>[
          argumentErr(),() => mFragmentsAboutMemoryPoolNode!.get_pn_memory_pool_node_aiid,argumentErr(),argumentErr(),
        ]);      String? get get_pn_memory_pool_node_uuid => setValue<String?>(
        <String? Function()>[
          argumentErr(),() => mFragmentsAboutMemoryPoolNode!.get_pn_memory_pool_node_uuid,argumentErr(),argumentErr(),
        ]);      int? get get_used_rule_aiid => setValue<int?>(
        <int? Function()>[
          argumentErr(),argumentErr(),() => mFragmentsAboutCompletePoolNode!.get_used_rule_aiid,argumentErr(),
        ]);      String? get get_used_rule_uuid => setValue<String?>(
        <String? Function()>[
          argumentErr(),argumentErr(),() => mFragmentsAboutCompletePoolNode!.get_used_rule_uuid,argumentErr(),
        ]);      int? get get_pn_complete_pool_node_aiid => setValue<int?>(
        <int? Function()>[
          argumentErr(),argumentErr(),() => mFragmentsAboutCompletePoolNode!.get_pn_complete_pool_node_aiid,argumentErr(),
        ]);      String? get get_pn_complete_pool_node_uuid => setValue<String?>(
        <String? Function()>[
          argumentErr(),argumentErr(),() => mFragmentsAboutCompletePoolNode!.get_pn_complete_pool_node_uuid,argumentErr(),
        ]);      int? get get_raw_rule_aiid => setValue<int?>(
        <int? Function()>[
          argumentErr(),argumentErr(),argumentErr(),() => mFragmentsAboutRulePoolNode!.get_raw_rule_aiid,
        ]);      String? get get_raw_rule_uuid => setValue<String?>(
        <String? Function()>[
          argumentErr(),argumentErr(),argumentErr(),() => mFragmentsAboutRulePoolNode!.get_raw_rule_uuid,
        ]);      int? get get_pn_rule_pool_node_aiid => setValue<int?>(
        <int? Function()>[
          argumentErr(),argumentErr(),argumentErr(),() => mFragmentsAboutRulePoolNode!.get_pn_rule_pool_node_aiid,
        ]);      String? get get_pn_rule_pool_node_uuid => setValue<String?>(
        <String? Function()>[
          argumentErr(),argumentErr(),argumentErr(),() => mFragmentsAboutRulePoolNode!.get_pn_rule_pool_node_uuid,
        ]);

  Set<String> get getDeleteForeignKeyFollowCurrentForSingle => setValue<Set<String>>(<Set<String> Function()>[
        () => mFragmentsAboutPendingPoolNode!.getDeleteForeignKeyFollowCurrentForSingle,() => mFragmentsAboutMemoryPoolNode!.getDeleteForeignKeyFollowCurrentForSingle,() => mFragmentsAboutCompletePoolNode!.getDeleteForeignKeyFollowCurrentForSingle,() => mFragmentsAboutRulePoolNode!.getDeleteForeignKeyFollowCurrentForSingle,
      ]);


  Set<String> get getDeleteForeignKeyFollowCurrentForTwo => setValue<Set<String>>(<Set<String> Function()>[
        () => mFragmentsAboutPendingPoolNode!.getDeleteForeignKeyFollowCurrentForTwo,() => mFragmentsAboutMemoryPoolNode!.getDeleteForeignKeyFollowCurrentForTwo,() => mFragmentsAboutCompletePoolNode!.getDeleteForeignKeyFollowCurrentForTwo,() => mFragmentsAboutRulePoolNode!.getDeleteForeignKeyFollowCurrentForTwo,
      ]);


  List<String> get getDeleteManyForeignKeyForSingle => setValue<List<String>>(<List<String> Function()>[
        () => mFragmentsAboutPendingPoolNode!.getDeleteManyForeignKeyForSingle,() => mFragmentsAboutMemoryPoolNode!.getDeleteManyForeignKeyForSingle,() => mFragmentsAboutCompletePoolNode!.getDeleteManyForeignKeyForSingle,() => mFragmentsAboutRulePoolNode!.getDeleteManyForeignKeyForSingle,
      ]);


  List<String> get getDeleteManyForeignKeyForTwo => setValue<List<String>>(<List<String> Function()>[
        () => mFragmentsAboutPendingPoolNode!.getDeleteManyForeignKeyForTwo,() => mFragmentsAboutMemoryPoolNode!.getDeleteManyForeignKeyForTwo,() => mFragmentsAboutCompletePoolNode!.getDeleteManyForeignKeyForTwo,() => mFragmentsAboutRulePoolNode!.getDeleteManyForeignKeyForTwo,
      ]);


  String? getForeignKeyBelongsTos({required String foreignKeyName}) => setValue<String?>(<String? Function()>[
        () => mFragmentsAboutPendingPoolNode!.getForeignKeyBelongsTos(foreignKeyName: foreignKeyName),() => mFragmentsAboutMemoryPoolNode!.getForeignKeyBelongsTos(foreignKeyName: foreignKeyName),() => mFragmentsAboutCompletePoolNode!.getForeignKeyBelongsTos(foreignKeyName: foreignKeyName),() => mFragmentsAboutRulePoolNode!.getForeignKeyBelongsTos(foreignKeyName: foreignKeyName),
      ]);


}
