import 'dart:async';

import 'package:flutter/material.dart';
import 'package:jysp/Database/Base/MBase.dart';
import 'package:jysp/Database/Models/MPnCompletePoolNode.dart';
import 'package:jysp/Database/Models/MPnMemoryPoolNode.dart';
import 'package:jysp/Database/Models/MPnPendingPoolNode.dart';
import 'package:jysp/Database/Models/MPnRulePoolNode.dart';
import 'package:jysp/Database/Models/MUpload.dart';
import 'package:jysp/G/GSqlite/GSqlite.dart';
import 'package:jysp/MVC/Controllers/FragmentPoolController/Enums.dart';
import 'package:jysp/MVC/Controllers/FragmentPoolController/FragmentPoolController.dart';
import 'package:jysp/Tools/TDebug.dart';
import 'package:sqflite/sqlite_api.dart';
import 'package:uuid/uuid.dart';

class RPoolNode {
  ///

  /// 读取当前池的全部节点
  Future<bool> retrievePoolNodes(FragmentPoolController fragmentPoolController, PoolType toPoolType) async {
    try {
      // 虽然清除后再重新 addAll，但清除的是 MBase 数据，而 list widget 没有被重置，因此 clear data 后仍保持相同的 state
      fragmentPoolController.getPoolTypeNodesList(toPoolType).clear();
      fragmentPoolController.getPoolTypeNodesList(toPoolType).addAll(
            await () async {
              return await fragmentPoolController.poolTypeSwitchFuture<List<MBase>>(
                toPoolType: toPoolType,
                pendingPoolCB: () async {
                  return await MPnPendingPoolNode.queryRowsAsModels();
                },
                memoryPoolCB: () async {
                  return await MPnMemoryPoolNode.queryRowsAsModels();
                },
                completePoolCB: () async {
                  return await MPnCompletePoolNode.queryRowsAsModels();
                },
                rulePoolCB: () async {
                  return await MPnRulePoolNode.queryRowsAsModels();
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
      final MBase model = fragmentPoolController.poolTypeSwitch<MBase>(
        pendingPoolCB: () => MPnPendingPoolNode.createModel(
          atid_v: null,
          uuid_v: const Uuid().v4(),
          recommend_raw_rule_atid_v: null,
          recommend_raw_rule_uuid_v: null,
          type_v: PendingPoolNodeType.ordinary,
          name_v: name,
          position_v: '${position.dx},${position.dy}',
          created_at_v: DateTime.now().millisecondsSinceEpoch,
          updated_at_v: DateTime.now().millisecondsSinceEpoch,
        ),
        memoryPoolCB: () => MPnMemoryPoolNode.createModel(
          atid_v: null,
          uuid_v: const Uuid().v4(),
          using_raw_rule_atid_v: null,
          using_raw_rule_uuid_v: null,
          type_v: MemoryPoolNodeType.ordinary,
          name_v: name,
          position_v: '${position.dx},${position.dy}',
          created_at_v: DateTime.now().millisecondsSinceEpoch,
          updated_at_v: DateTime.now().millisecondsSinceEpoch,
        ),
        completePoolCB: () => MPnCompletePoolNode.createModel(
          atid_v: null,
          uuid_v: const Uuid().v4(),
          used_raw_rule_atid_v: null,
          used_raw_rule_uuid_v: null,
          type_v: CompletePoolNodeType.ordinary,
          name_v: name,
          position_v: '${position.dx},${position.dy}',
          created_at_v: DateTime.now().millisecondsSinceEpoch,
          updated_at_v: DateTime.now().millisecondsSinceEpoch,
        ),
        rulePoolCB: () => MPnRulePoolNode.createModel(
          atid_v: null,
          uuid_v: const Uuid().v4(),
          type_v: RulePoolNodeType.ordinary,
          name_v: name,
          position_v: '${position.dx},${position.dy}',
          created_at_v: DateTime.now().millisecondsSinceEpoch,
          updated_at_v: DateTime.now().millisecondsSinceEpoch,
        ),
      );

      final Batch batch = db.batch();
      // 插入 new node
      batch.insert(model.getCurrentTableName, model.getRowJson);
      // 插入 upload
      batch.insert(
        MUpload.getTableName,
        MUpload.asJsonNoId(
          atid_v: null,
          uuid_v: null,
          table_name_v: model.getCurrentTableName,
          row_atid_v: null,
          row_uuid_v: const Uuid().v4(),
          upload_status_v: UploadStatus.notUploaded,
          created_at_v: DateTime.now().millisecondsSinceEpoch,
          updated_at_v: DateTime.now().millisecondsSinceEpoch,
          curd_status_v: null,
          row_id_v: null,
          updated_columns_v: '',
        ),
      );
      await batch.commit();
      // 让 state 变化
      fragmentPoolController.getPoolTypeNodesList().add(model);
      return true;
    } catch (e) {
      dLog(() => 'createNewNode err:', () => e);
      return false;
    }
  }

  /// 删除当前池内的指定节点
  Future<bool> deleteNode({required FragmentPoolController fragmentPoolController, required MBase model}) async {
    try {
      // 如果是 create 的话，直接覆盖原来状态
      if (model.get_curd_status == Curd.C) {}
      if (model.get_atid != null && model.get_uuid == null) {}
      await db.delete(model.getCurrentTableName, where: 'id=?', whereArgs: [model.get_id]);
    } catch (e) {
      dLog(() => 'deleteNode err: ', () => e);
      return false;
    }
  }
}
