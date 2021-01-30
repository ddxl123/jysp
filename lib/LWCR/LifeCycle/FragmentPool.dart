import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:jysp/FragmentPool/FragmentPoolEnum.dart';
import 'package:jysp/LWCR/Controller/FragmentPoolController.dart';
import 'package:jysp/LWCR/Controller/FreeBoxController.dart';
import 'package:jysp/LWCR/WidgetBuild/FragmentPoolWB.dart';
import 'package:jysp/Tools/TDebug.dart';

class FragmentPool extends StatefulWidget {
  FragmentPool({@required this.fragmentPoolController, @required this.freeBoxController});
  final FragmentPoolController fragmentPoolController;
  final FreeBoxController freeBoxController;

  @override
  _FragmentPoolState createState() => _FragmentPoolState();
}

class _FragmentPoolState extends State<FragmentPool> {
  @override
  void initState() {
    super.initState();
    widget.fragmentPoolController.refreshLayout(
      freeBoxController: widget.freeBoxController,
      isInit: true,
      isGetData: true,
      toPoolType: null,
      toPoolTypeResult: (bool) {},
    );
    widget.fragmentPoolController.addListener(_controllerListener);
  }

  @override
  void dispose() {
    widget.fragmentPoolController.removeListener(_controllerListener);
    widget.fragmentPoolController.dispose();
    super.dispose();
  }

  /// 监听函数
  void _controllerListener() {
    if (widget.fragmentPoolController.getFragmentPoolRefreshStatus == FragmentPoolRefreshStatus.willLayout) {
      widget.fragmentPoolController.setFragmentPoolRefreshStatus = FragmentPoolRefreshStatus.willGetLayout;
      dPrint("2-willGetLayout");
      setState(() {});
    }
    if (widget.fragmentPoolController.getFragmentPoolRefreshStatus == FragmentPoolRefreshStatus.willRunLayout) {
      widget.fragmentPoolController.setFragmentPoolRefreshStatus = FragmentPoolRefreshStatus.none;
      dPrint("6-none");
      _doneHandle();
      setState(() {});
    }
  }

  void _doneHandle() {
    /// 获取当前池的 [route=="0"] 坐标
    Offset transformZeroOffset = Offset(widget.fragmentPoolController.nodeLayoutMap["0"]["layout_left"] - widget.fragmentPoolController.nodeLayoutMap["0"]["layout_width"] / 2,
        -(widget.fragmentPoolController.nodeLayoutMap["0"]["layout_top"] + widget.fragmentPoolController.nodeLayoutMap["0"]["layout_height"] / 2));
    Offset mediaCenter = Offset(MediaQueryData.fromWindow(window).size.width / 2, MediaQueryData.fromWindow(window).size.height / 2);
    widget.fragmentPoolController.viewSelectedType[widget.fragmentPoolController.getCurrentFragmentPoolType]["node0"] = transformZeroOffset + mediaCenter;

    /// 滑动至上次保存的 offset 和 scale,
    /// 若上次没有保存, 则使用这次的 node0
    widget.freeBoxController.targetSlide(
      targetOffset: widget.fragmentPoolController.viewSelectedType[widget.fragmentPoolController.getCurrentFragmentPoolType]["offset"] ??
          widget.fragmentPoolController.viewSelectedType[widget.fragmentPoolController.getCurrentFragmentPoolType]["node0"],
      targetScale: widget.fragmentPoolController.viewSelectedType[widget.fragmentPoolController.getCurrentFragmentPoolType]["scale"] ?? 1.0,
    );
  }

  @override
  Widget build(BuildContext context) => FragmentPoolWB(widget);
}
