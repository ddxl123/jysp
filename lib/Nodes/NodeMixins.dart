import 'package:jysp/Nodes/SingleNodes/FolderNode.dart';

mixin NodeMixins {
  void addFragment(FolderNode widget) {
    widget.sn.fragmentPoolDateList.add({
      "route": () {
        int childCount = 0;
        for (int i = 0; i < widget.sn.fragmentPoolDateList.length; i++) {
          if (widget.sn.fragmentPoolDateMapClone.containsKey(widget.snState.thisRoute + "-$i")) {
            childCount++;
          } else {
            break;
          }
        }
        return widget.snState.thisRoute + "-$childCount";
      }(),
      "type": 1,
      "out_display_name": "${widget.snState.thisRoute},hhhhh",
    });
    widget.sn.doChange();
  }
}
