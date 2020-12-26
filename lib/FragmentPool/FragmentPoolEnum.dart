enum FragmentPoolRefreshStatus {
  none,
  willRefresh,
  getLayout,
  willSetLayout,
  setLayout,
  runLayout,
}
enum FragmentPoolSelectedType {
  none,
  pendingPool,
  memoryPool,
  completePool,
  wikiPool,
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
