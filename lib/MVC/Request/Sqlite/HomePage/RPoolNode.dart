import 'dart:async';

import 'package:flutter/material.dart';
import 'package:jysp/Database/MergeModels/MMFragmentPoolNode.dart';
import 'package:jysp/Database/Models/MBase.dart';
import 'package:jysp/Database/Models/MPnCompletePoolNode.dart';
import 'package:jysp/Database/Models/MPnMemoryPoolNode.dart';
import 'package:jysp/Database/Models/MPnPendingPoolNode.dart';
import 'package:jysp/Database/Models/MPnRulePoolNode.dart';
import 'package:jysp/MVC/Controllers/FragmentPoolController/Enums.dart';
import 'package:jysp/MVC/Controllers/FragmentPoolController/FragmentPoolController.dart';
import 'package:jysp/MVC/Request/Sqlite/RSqliteCurd.dart';
import 'package:jysp/Tools/TDebug.dart';
import 'package:uuid/uuid.dart';

class RPoolNode {
  ///

  /// 读取当前池的全部节点
  Future<bool> retrievePoolNodes(FragmentPoolController fragmentPoolController, PoolType toPoolType) async {
    try {
      // 虽然清除后再重新 addAll，但清除的是 MBase 数据，而 list widget 的 index 没有被重置，因此 clear data 后仍保持相同的 state
      fragmentPoolController.getPoolTypeNodesList(toPoolType).clear();
      fragmentPoolController.getPoolTypeNodesList(toPoolType).addAll(
            await () async {
              return await fragmentPoolController.poolTypeSwitchFuture<List<MMFragmentPoolNode<MBase>>>(
                toPoolType: toPoolType,
                pendingPoolCB: () async {
                  final List<MPnPendingPoolNode> models =
                      await MBase.queryRowsAsModels<MPnPendingPoolNode>(tableName: MPnPendingPoolNode.tableName, where: null, whereArgs: null, connectTransaction: null);
                  final List<MMFragmentPoolNode<MPnPendingPoolNode>> mmodels = <MMFragmentPoolNode<MPnPendingPoolNode>>[];
                  for (final MPnPendingPoolNode model in models) {
                    mmodels.add(MMFragmentPoolNode<MPnPendingPoolNode>(model: model));
                  }
                  return mmodels;
                },
                memoryPoolCB: () async {
                  final List<MPnMemoryPoolNode> models =
                      await MBase.queryRowsAsModels<MPnMemoryPoolNode>(tableName: MPnMemoryPoolNode.tableName, where: null, whereArgs: null, connectTransaction: null);
                  final List<MMFragmentPoolNode<MPnMemoryPoolNode>> mmodels = <MMFragmentPoolNode<MPnMemoryPoolNode>>[];
                  for (final MPnMemoryPoolNode model in models) {
                    mmodels.add(MMFragmentPoolNode<MPnMemoryPoolNode>(model: model));
                  }
                  return mmodels;
                },
                completePoolCB: () async {
                  final List<MPnCompletePoolNode> models =
                      await MBase.queryRowsAsModels<MPnCompletePoolNode>(tableName: MPnCompletePoolNode.tableName, where: null, whereArgs: null, connectTransaction: null);
                  final List<MMFragmentPoolNode<MPnCompletePoolNode>> mmodels = <MMFragmentPoolNode<MPnCompletePoolNode>>[];
                  for (final MPnCompletePoolNode model in models) {
                    mmodels.add(MMFragmentPoolNode<MPnCompletePoolNode>(model: model));
                  }
                  return mmodels;
                },
                rulePoolCB: () async {
                  final List<MPnRulePoolNode> models = await MBase.queryRowsAsModels<MPnRulePoolNode>(tableName: MPnRulePoolNode.tableName, where: null, whereArgs: null, connectTransaction: null);
                  final List<MMFragmentPoolNode<MPnRulePoolNode>> mmodels = <MMFragmentPoolNode<MPnRulePoolNode>>[];
                  for (final MPnRulePoolNode model in models) {
                    mmodels.add(MMFragmentPoolNode<MPnRulePoolNode>(model: model));
                  }
                  return mmodels;
                },
              );
            }(),
          );
      return true;
    } catch (e) {
      dLog(() => 'retrievePoolNodes err: ', () => e);
      return false;
    }
  }

  /// 在当前池内插入新节点
  Future<bool> insertNewNode({required FragmentPoolController fragmentPoolController, required String name, required Offset position}) async {
    try {
      final MBase newNodeModel = fragmentPoolController.poolTypeSwitch<MBase>(
        pendingPoolCB: () => MPnPendingPoolNode.createModel(
          aiid_v: null,
          uuid_v: const Uuid().v4(),
          recommend_raw_rule_aiid_v: null,
          recommend_raw_rule_uuid_v: null,
          type_v: PendingPoolNodeType.ordinary,
          name_v: name,
          position_v: '${position.dx},${position.dy}',
          created_at_v: DateTime.now().millisecondsSinceEpoch,
          updated_at_v: DateTime.now().millisecondsSinceEpoch,
        ),
        memoryPoolCB: () => MPnMemoryPoolNode.createModel(
          aiid_v: null,
          uuid_v: const Uuid().v4(),
          using_raw_rule_aiid_v: null,
          using_raw_rule_uuid_v: null,
          type_v: MemoryPoolNodeType.ordinary,
          name_v: name,
          position_v: '${position.dx},${position.dy}',
          created_at_v: DateTime.now().millisecondsSinceEpoch,
          updated_at_v: DateTime.now().millisecondsSinceEpoch,
        ),
        completePoolCB: () => MPnCompletePoolNode.createModel(
          aiid_v: null,
          uuid_v: const Uuid().v4(),
          used_raw_rule_aiid_v: null,
          used_raw_rule_uuid_v: null,
          type_v: CompletePoolNodeType.ordinary,
          name_v: name,
          position_v: '${position.dx},${position.dy}',
          created_at_v: DateTime.now().millisecondsSinceEpoch,
          updated_at_v: DateTime.now().millisecondsSinceEpoch,
        ),
        rulePoolCB: () => MPnRulePoolNode.createModel(
          aiid_v: null,
          uuid_v: const Uuid().v4(),
          type_v: RulePoolNodeType.ordinary,
          name_v: name,
          position_v: '${position.dx},${position.dy}',
          created_at_v: DateTime.now().millisecondsSinceEpoch,
          updated_at_v: DateTime.now().millisecondsSinceEpoch,
        ),
      );

      // 插入 new node
      final MBase? insertReuslt = await RSqliteCurd<MBase>.byModel(newNodeModel).toInsertRow(connectTransaction: null);

      // 让 state 变化
      if (insertReuslt != null) {
        // 不能把 newNodeModel 插入，而是把 insertReuslt 插入，因为前者没有 id
        fragmentPoolController.getPoolTypeNodesList<MBase>().add(MMFragmentPoolNode<MBase>(model: insertReuslt));
        return true;
      }

      return false;
    } catch (e) {
      dLog(() => 'createNewNode err:', () => e);
      return false;
    }
  }
}
