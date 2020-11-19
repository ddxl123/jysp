import 'package:jysp/Global/GlobalData.dart';

mixin NodeMixin {
  void addOrdinalNode(int currentIndex, String thisRouteName, int childCount) {
    /// TODO: 需要异步操作
    GlobalData.instance.startResetLayout(() {
      GlobalData.instance.fragmentPoolPendingNodes.add({
        "_id": "",
        "user_id": "",
        "pool_type": 0,
        "node_type": 0,
        "route": thisRouteName + "-$childCount",
        "name": thisRouteName + "-$childCount",
      });
    });
  }
}
