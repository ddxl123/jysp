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

enum PoolRefreshStatus {
  none,
  refreshLayout,
  getLayout,
  setLayout,
  buildLayout,
}
