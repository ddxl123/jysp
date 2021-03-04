enum PoolRefreshStatus {
  none,
  refreshLayout,
  getLayout,
  setLayout,
  buildLayout,
}

/// 1. 当 [PoolType.index] 时，获取的是 [int]。
/// 2. 当 [PoolType.value] 时，获取的是 [string]。
/// 3. 当 [PoolType.indexs.toList] 时，获取的是角标数组。
enum PoolType {
  pendingPool,
  memoryPool,
  completePool,
  wikiPool,
  indexs,
}

extension PoolSelectedTypeExt on PoolType {
  List<int> get toList => [0, 1, 2, 3];
  String get value {
    switch (this.index) {
      case 0:
        return "待定池";
      case 1:
        return "记忆池";
      case 2:
        return "完成池";
      case 3:
        return "百科池";
      case 4:
      default:
        throw Exception("Index is unknown!");
    }
  }
}

enum NodeType {
  root,

  pendingGroup,
  pendingGroupCol,
  pendingNode,

  memoryGroup,
  memoryGroupCol,
  memoryNode,

  completeGroup,
  completeGroupCol,
  completeNode,

  wikiGroup,
  wikiGroupCol,
  wikiNode,
}

enum OutType {
  id,
  pool_type,
  node_type,
  route_exception,
  route_no_father,
  route_repeat,
  name,
}
