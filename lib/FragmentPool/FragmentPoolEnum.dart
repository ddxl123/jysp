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
  pendingPool, // 0
  memoryPool, // 1
  completePool, // 2
  wikiPool, // 3
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
  root, // 0

  pendingGroup, // 1
  pendingGroupCol, // 2
  pendingFragment, // 3

  memoryGroup, // 4
  memoryGroupCol, // 5
  memoryFragment, // 6

  completeGroup, // 7
  completeGroupCol, // 8
  completeFragment, // 9

  wikiGroup, // 10
  wikiGroupCol, // 11
  wikiFragment, // 12

  indexs,
}

extension NodeSelectedTypeExt on NodeType {
  List<int> get toList => [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12];
  String get value {
    switch (this.index) {
      case 0:
        return "root";
      case 1:
        return "待定组";
      case 2:
        return "待定组集";
      case 3:
        return "待定碎片";
      case 4:
        return "记忆组";
      case 5:
        return "记忆组集";
      case 6:
        return "记忆碎片";
      case 7:
        return "完成组";
      case 8:
        return "完成组集";
      case 9:
        return "完成碎片";
      case 10:
        return "百科组";
      case 11:
        return "百科组集";
      case 12:
        return "百科碎片";
      default:
        throw Exception("Index is unknown!");
    }
  }
}

enum OutType {
  id_exception,
  id_repeat,
  pool_type,
  node_type,
  name,
}
