import 'package:flutter/material.dart';
import 'package:jysp/FragmentPool/Nodes/BaseNodes/MainSingleNodeData.dart';
import 'package:jysp/FragmentPool/Nodes/ToolNodes/ShowNodeSheet.dart';

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

  ///
  ///
  ///
  ///
  ///
  Widget ff(BuildContext context) {
    return SliverToBoxAdapter();
  }

  void showNodeSheet({
    @required BuildContext relyContext,
    @required MainSingleNodeData mainSingleNodeData,
    Widget Function(BuildContext) sliver1Builder,
    Widget Function(BuildContext) sliver2Builder,
    Widget Function(BuildContext) sliver3Builder,
    Widget Function(BuildContext) sliver4Builder,
  }) {
    OverlayState overlayState = Overlay.of(relyContext);
    OverlayEntry overlayEntry;
    overlayEntry = OverlayEntry(
      builder: (BuildContext overlayEntryContext) {
        return ShowNodeSheet(
          relyContext: relyContext,
          mainSingleNodeData: mainSingleNodeData,
          overlayEntry: overlayEntry,
          sliver1Builder: sliver1Builder ?? (_) => SliverToBoxAdapter(),
          sliver2Builder: sliver2Builder ?? (_) => SliverToBoxAdapter(),
          sliver3Builder: sliver3Builder ?? (_) => SliverToBoxAdapter(),
          sliver4Builder: sliver4Builder ?? (_) => SliverToBoxAdapter(),
        );
      },
    );
    overlayState.insert(overlayEntry);
  }
}
