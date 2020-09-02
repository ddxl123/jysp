import 'package:flutter/material.dart';
import 'package:jysp/FragmentPool/Nodes/BaseNodes/MainNode.dart';
import 'package:jysp/FragmentPool/Nodes/ToolNodes/ShowNodeSheet.dart';

mixin NodeMixin {
  void nodeAddFragment(MainNode mainNode, MainNodeState mainNodeState) {
    mainNode.fragmentPoolDateList.add({
      "route": () {
        int childCount = 0;
        for (int i = 0; i < mainNode.fragmentPoolDateList.length; i++) {
          if (mainNode.fragmentPoolDateMapClone.containsKey(mainNodeState.thisRouteName + "-$i")) {
            childCount++;
          } else {
            break;
          }
        }
        return mainNodeState.thisRouteName + "-$childCount";
      }(),
      "type": 1,
      "pool_display_name": "${mainNodeState.thisRouteName},hhhhh",
    });
    mainNode.freeBoxController.setStateForChildren();
  }

  ///
  ///
  ///
  ///
  ///
  void showNodeSheet({
    @required BuildContext context,
    @required MainNode mainNode,
    @required MainNodeState mainNodeState,
    Widget sliver1 = const SliverToBoxAdapter(),
    Widget sliver2 = const SliverToBoxAdapter(),
    Widget sliver3 = const SliverToBoxAdapter(),
    Widget sliver4 = const SliverToBoxAdapter(),
  }) {
    OverlayState overlayState = Overlay.of(context);
    OverlayEntry overlayEntry;
    overlayEntry = OverlayEntry(
      builder: (BuildContext context) {
        return ShowNodeSheet(
          mainNode: mainNode,
          mainNodeState: mainNodeState,
          overlayEntry: overlayEntry,
          sliver1: sliver1,
          sliver2: sliver2,
          sliver3: sliver3,
          sliver4: sliver4,
        );
      },
    );
    overlayState.insert(overlayEntry);
  }
}
