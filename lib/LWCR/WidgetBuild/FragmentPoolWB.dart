import 'package:flutter/material.dart';
import 'package:jysp/FragmentPool/SingleNode/SingleNode.dart';
import 'package:jysp/LWCR/LifeCycle/FragmentPoolLC.dart';
import 'package:jysp/LWCR/WidgetBuild/WidgetBuildBase.dart';

class FragmentPoolWB extends WidgetBuildBase<FragmentPoolLC> {
  FragmentPoolWB(FragmentPoolLC widget) : super(widget);

  void _toPosition() {
    WidgetsBinding.instance!.addPostFrameCallback(
      (timeStamp) {
        /// 滑动至上次保存的 offset 和 scale,
        /// 若上次没有保存, 则使用这次的 node0
        widget.freeBoxController.targetSlide(
          targetOffset: widget.fragmentPoolController.viewSelectedType[widget.fragmentPoolController.getCurrentPoolType]!["offset"] ??
              widget.fragmentPoolController.viewSelectedType[widget.fragmentPoolController.getCurrentPoolType]!["node0"],
          targetScale: widget.fragmentPoolController.viewSelectedType[widget.fragmentPoolController.getCurrentPoolType]!["scale"] ?? 1.0,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    if (widget.fragmentPoolController.isIniting) {
      return Text("initing...");
    }
    _toPosition();
    return Stack(
      children: <Widget>[
        for (int childrenIndex = 0; childrenIndex < widget.fragmentPoolController.fragmentPoolNodes.length; childrenIndex++)
          () {
            return SingleNode(
              index: childrenIndex,
              fragmentPoolController: widget.fragmentPoolController,
            );
          }()
      ],
    );
  }
}
