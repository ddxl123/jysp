enum FragmentPoolRefreshStatus {
  none,
  willLayout,
  willGetData,
  willGetLayout,
  willSetLayout,
  setLayoutDone,
  willRunLayout,
}
enum FragmentPoolType {
  pendingPool,
  memoryPool,
  completePool,
  wikiPool,
}

extension FragmentPoolSelectedTypeExt on FragmentPoolType {
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
      default:
        throw Exception("Index is unknown!");
    }
  }
}

enum FragmentPoolNodeType {
  none,

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
