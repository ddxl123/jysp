import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:jysp/FragmentPool/Nodes/MainNode.dart';

mixin NodeMixin {
  void nodeAddFragment(MainNode mainNode, MainNodeState mainNodeState) {
    mainNode.fragmentPoolDateList.add({
      "route": () {
        int childCount = 0;
        for (int i = 0; i < mainNode.fragmentPoolDateList.length; i++) {
          if (mainNode.fragmentPoolDateMapClone.containsKey(mainNodeState.thisRoute + "-$i")) {
            childCount++;
          } else {
            break;
          }
        }
        return mainNodeState.thisRoute + "-$childCount";
      }(),
      "type": 1,
      "out_display_name": "${mainNodeState.thisRoute},hhhhh",
    });
    mainNode.doChange();
  }

  ///
  ///
  ///
  ///
  ///
  List<Widget> sliverList(double circularRadius, Widget uniformBottomWidget);
  PersistentBottomSheetController nodeShowBottomSheet({
    @required BuildContext context,
    @required MainNode mainNode,
    @required List<Widget> Function(double circularRadius, Widget uniformBottomWidget) sliverList,
  }) {
    double circularRadius = 35.0;

    PersistentBottomSheetController sbs = showBottomSheet(
      backgroundColor: Colors.transparent,
      context: context,
      builder: (_) {
        return Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(circularRadius),
              topRight: Radius.circular(circularRadius),
            ),
            color: Colors.white,
          ),
          child: DraggableScrollableSheet(
            initialChildSize: 0.5,
            minChildSize: 0,
            maxChildSize: (MediaQueryData.fromWindow(window).size.height - MediaQueryData.fromWindow(window).padding.top) / MediaQueryData.fromWindow(window).size.height,
            expand: false,
            builder: (context, scrollController) {
              return CustomScrollView(
                controller: scrollController,
                slivers: sliverList(
                  circularRadius,
                  SliverFillRemaining(
                    hasScrollBody: false,
                    child: Container(
                      child: FlatButton(onPressed: () {}, child: Text("no more")),
                    ),
                  ),
                ),
              );
            },
          ),
        );
      },
    );
    mainNode.freeBoxController.eventBindOnce(
      updateBindOnce: () {
        //// 这里要 [try] ,因为 [sbs] 实在没找到监听是否已经被 [close] 的函数
        try {
          sbs.close();
        } catch (e) {}
      },
      endBindOnce: () {
        //// 这里要 [try] ,因为 [sbs] 实在没找到监听是否已经被 [close] 的函数
        try {
          sbs.close();
        } catch (e) {}
      },
    );
    return sbs;
  }
}
