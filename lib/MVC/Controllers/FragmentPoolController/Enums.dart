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
}

extension NodeSelectedTypeExt on NodeType {
  String get value {
    switch (index) {
      case 0:
        return 'root';
      case 1:
        return '待定组';
      case 2:
        return '待定组集';
      case 3:
        return '待定碎片';
      case 4:
        return '记忆组';
      case 5:
        return '记忆组集';
      case 6:
        return '记忆碎片';
      case 7:
        return '完成组';
      case 8:
        return '完成组集';
      case 9:
        return '完成碎片';
      case 10:
        return '百科组';
      case 11:
        return '百科组集';
      case 12:
        return '百科碎片';
      default:
        throw Exception('Index is unknown!');
    }
  }
}

/// 1. 当 [PoolType.index] 时，获取的是 [int]。
/// 2. 当 [PoolType.value] 时，获取的是 [string]。
enum PoolType {
  pendingPool, // 0
  memoryPool, // 1
  completePool, // 2
  rulePool, // 3
}

extension PoolSelectedTypeExt on PoolType {
  String get text {
    switch (index) {
      case 0:
        return '待定池';
      case 1:
        return '记忆池';
      case 2:
        return '完成池';
      case 3:
        return '规则池';
      case 4:
      default:
        throw Exception('Index is unknown!');
    }
  }
}

enum PoolRefreshStatus {
  none,
  refreshLayout,
  getLayout,
  setLayout,
  buildLayout,
}
