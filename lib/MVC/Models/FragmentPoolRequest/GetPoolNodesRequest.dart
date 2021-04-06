import 'package:jysp/Database/models/MDownloadQueueModule.dart';
import 'package:jysp/Database/models/MPnCompletePoolNode.dart';
import 'package:jysp/Database/models/MPnMemoryPoolNode.dart';
import 'package:jysp/Database/models/MPnPendingPoolNode.dart';
import 'package:jysp/Database/models/MPnRulePoolNode.dart';
import 'package:jysp/G/GSqlite/GSqlite.dart';
import 'package:jysp/MVC/Controllers/FragmentPoolController/Enums.dart';
import 'package:jysp/MVC/Controllers/FragmentPoolController/FragmentPoolController.dart';

class GetPoolNodesRequest {
  Future<bool> getPoolNodes(FragmentPoolController fragmentPoolController, PoolType toPoolType) async {
    switch (toPoolType) {
      case PoolType.pendingPool:
        // 检查【下载队列】表中是否已下载
        List<Map<String, Object?>> download_is_ok = await GSqlite.db.query(
          MDownloadQueueModule.getTableName,
          where: MDownloadQueueModule.module_name + "=?",
          whereArgs: ["pending_pool_nodes"],
        );
        if (download_is_ok.isEmpty || download_is_ok.first[MDownloadQueueModule.download_is_ok] == 0) {
          fragmentPoolController.pendingPoolNodes.clear();
          fragmentPoolController.pendingPoolNodes.add(
            MPnPendingPoolNode.createModel(
              pn_pending_pool_node_id_v: null,
              pn_pending_pool_node_uuid_v: null,
              recommend_raw_rule_id_v: null,
              recommend_raw_rule_uuid_v: null,
              type_v: PendingPoolNodeType.nodeIsZero,
              name_v: "未下载",
              position_v: "0,0",
              created_at_v: null,
              updated_at_v: null,
              curd_status_v: null,
            ),
          );
        }
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
  }
}
