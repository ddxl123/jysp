import 'dart:async';

import 'package:jysp/Database/models/MPnCompletePoolNode.dart';
import 'package:jysp/Database/models/MPnMemoryPoolNode.dart';
import 'package:jysp/Database/models/MPnPendingPoolNode.dart';
import 'package:jysp/Database/models/MPnRulePoolNode.dart';
import 'package:jysp/G/G.dart';
import 'package:jysp/G/GSqlite/GSqlite.dart';
import 'package:jysp/MVC/Controllers/FragmentPoolController/Enums.dart';
import 'package:jysp/MVC/Controllers/FragmentPoolController/FragmentPoolController.dart';
import 'package:jysp/Tools/TDebug.dart';

class RPoolNode {
  Future<bool> getPoolNodes(FragmentPoolController fragmentPoolController, PoolType toPoolType) async {
    try {
      return await G.poolTypeSwitchFuture<bool>(
        toPoolType: toPoolType,
        pendingPoolCB: () async {
          fragmentPoolController.pendingPoolNodes.clear();
          fragmentPoolController.pendingPoolNodes.addAll(await MPnPendingPoolNode.getAllRowsAsModel());
          return true;
        },
        memoryPoolCB: () async {
          fragmentPoolController.memoryPoolNodes.clear();
          fragmentPoolController.memoryPoolNodes.addAll(await MPnMemoryPoolNode.getAllRowsAsModel());
          return true;
        },
        completePoolCB: () async {
          fragmentPoolController.completePoolNodes.clear();
          fragmentPoolController.completePoolNodes.addAll(await MPnCompletePoolNode.getAllRowsAsModel());
          return true;
        },
        rulePoolCB: () async {
          fragmentPoolController.rulePoolNodes.clear();
          fragmentPoolController.rulePoolNodes.addAll(await MPnRulePoolNode.getAllRowsAsModel());
          return true;
        },
        unknownCB: () async {
          return false;
        },
      );
    } catch (e) {
      dLog(() => e);
      return false;
    }
  }

  Future<bool> saveNewNode(PoolType toPoolType) async {
    return await G.poolTypeSwitchFuture<bool>(
      toPoolType: toPoolType,
      pendingPoolCB: () async {
        await GSqlite.db.insert(table, values);
        return true;
      },
      memoryPoolCB: memoryPoolCB,
      completePoolCB: completePoolCB,
      rulePoolCB: rulePoolCB,
      unknownCB: unknownCB,
    );
  }
}
