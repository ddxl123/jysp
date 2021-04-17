import 'package:jysp/Database/models/MPnCompletePoolNode.dart';
import 'package:jysp/Database/models/MPnMemoryPoolNode.dart';
import 'package:jysp/Database/models/MPnPendingPoolNode.dart';
import 'package:jysp/Database/models/MPnRulePoolNode.dart';
import 'package:jysp/MVC/Controllers/FragmentPoolController/Enums.dart';
import 'package:jysp/MVC/Controllers/FragmentPoolController/FragmentPoolController.dart';
import 'package:jysp/Tools/TDebug.dart';

class GetPoolNodesRequest {
  Future<bool> getPoolNodes(FragmentPoolController fragmentPoolController, PoolType toPoolType) async {
    try {
      switch (toPoolType) {
        case PoolType.pendingPool:
          fragmentPoolController.pendingPoolNodes.clear();
          fragmentPoolController.pendingPoolNodes.addAll(await MPnPendingPoolNode.getAllRowsAsModel());
          return true;
        case PoolType.memoryPool:
          fragmentPoolController.memoryPoolNodes.clear();
          fragmentPoolController.memoryPoolNodes.addAll(await MPnMemoryPoolNode.getAllRowsAsModel());
          return true;
        case PoolType.completePool:
          fragmentPoolController.completePoolNodes.clear();
          fragmentPoolController.completePoolNodes.addAll(await MPnCompletePoolNode.getAllRowsAsModel());
          return true;
        case PoolType.rulePool:
          fragmentPoolController.rulePoolNodes.clear();
          fragmentPoolController.rulePoolNodes.addAll(await MPnRulePoolNode.getAllRowsAsModel());
          return true;
        default:
          return false;
      }
    } catch (e) {
      dLog(() => e);
      return false;
    }
  }
}
