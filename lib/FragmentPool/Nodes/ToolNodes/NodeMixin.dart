import 'package:jysp/FragmentPool/Nodes/BaseNodes/MainSingleNodeData.dart';

mixin NodeMixin {
  void nodeAddFragment({MainSingleNodeData mainSingleNodeData}) {
    mainSingleNodeData.resetLayout(() {
      mainSingleNodeData.fragmentPoolDataList.add({
        "route": () {
          int childCount = 0;
          for (int i = 0; i < mainSingleNodeData.fragmentPoolDataList.length; i++) {
            if (mainSingleNodeData.fragmentPoolLayoutDataMap.containsKey(mainSingleNodeData.thisRouteName + "-$i")) {
              childCount++;
            } else {
              break;
            }
          }
          return mainSingleNodeData.thisRouteName + "-$childCount";
        }(),
        "type": 1,
        "pool_display_name": "${mainSingleNodeData.thisRouteName},hhhhh",
      });
    });
  }
}
