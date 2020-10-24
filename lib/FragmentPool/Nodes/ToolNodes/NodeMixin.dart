import 'package:jysp/Global/GlobalData.dart';
import 'package:jysp/FragmentPool/FragmentPool.dart';

mixin NodeMixin {
  void addOrdinalNode(int currentIndex, String thisRouteName, int childCount) {
    /// TODO: 需要异步操作
    GlobalData.instance.startResetLayout(() {
      GlobalData.instance.userSelfInitFragmentPoolNodes.add({
        "node_type_id": null,
        "type": 0,
        "route": thisRouteName + "-$childCount",
        "text": thisRouteName + "-$childCount",
        "background_color": "FFEF5350",
      });
    });
  }
}
