import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:jysp/FragmentPool/FragmentPoolEnum.dart';
import 'package:jysp/LWCR/Controller/FragmentPoolController.dart';
import 'package:jysp/LWCR/Controller/FreeBoxController.dart';
import 'package:jysp/LWCR/WidgetBuild/FragmentPoolWB.dart';
import 'package:jysp/Tools/TDebug.dart';

class FragmentPoolLC extends StatefulWidget {
  FragmentPoolLC({@required this.fragmentPoolController, @required this.freeBoxController});
  final FragmentPoolController fragmentPoolController;
  final FreeBoxController freeBoxController;

  @override
  _FragmentPoolLCState createState() => _FragmentPoolLCState();
}

class _FragmentPoolLCState extends State<FragmentPoolLC> {
  @override
  void initState() {
    super.initState();
    widget.fragmentPoolController.isInitFragmentPool = true;
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      widget.fragmentPoolController.addListener(_controllerListener);
      widget.fragmentPoolController.isInitFragmentPool = false;
      widget.fragmentPoolController.toPool(
        freeBoxController: widget.freeBoxController,
        toPoolType: widget.fragmentPoolController.getCurrentPoolType,
        toPoolTypeResult: (int resultCode) {},
      );
    });
  }

  @override
  void dispose() {
    widget.fragmentPoolController.removeListener(_controllerListener);
    widget.fragmentPoolController.dispose();
    super.dispose();
  }

  /// 监听函数
  void _controllerListener() {
    if (widget.fragmentPoolController.getPoolRefreshStatus == PoolRefreshStatus.refreshLayout) {
      widget.fragmentPoolController.setPoolRefreshStatus = PoolRefreshStatus.getLayout;
      dLog(() => "2-getLayout");
      setState(() {});
    }
    if (widget.fragmentPoolController.getPoolRefreshStatus == PoolRefreshStatus.buildLayout) {
      widget.fragmentPoolController.setPoolRefreshStatus = PoolRefreshStatus.none;
      dLog(() => "5-none");
      _doneHandle();
      setState(() {});
    }
  }

  void _doneHandle() {
    /// 获取当前池的 [route=="0"] 坐标
    Offset transformZeroOffset = Offset(widget.fragmentPoolController.nodeLayoutMap["0"]["layout_left"] - widget.fragmentPoolController.nodeLayoutMap["0"]["layout_width"] / 2,
        -(widget.fragmentPoolController.nodeLayoutMap["0"]["layout_top"] + widget.fragmentPoolController.nodeLayoutMap["0"]["layout_height"] / 2));
    Offset mediaCenter = Offset(MediaQueryData.fromWindow(window).size.width / 2, MediaQueryData.fromWindow(window).size.height / 2);
    widget.fragmentPoolController.viewSelectedType[widget.fragmentPoolController.getCurrentPoolType]["node0"] = transformZeroOffset + mediaCenter;

    /// 滑动至上次保存的 offset 和 scale,
    /// 若上次没有保存, 则使用这次的 node0
    widget.freeBoxController.targetSlide(
      targetOffset: widget.fragmentPoolController.viewSelectedType[widget.fragmentPoolController.getCurrentPoolType]["offset"] ??
          widget.fragmentPoolController.viewSelectedType[widget.fragmentPoolController.getCurrentPoolType]["node0"],
      targetScale: widget.fragmentPoolController.viewSelectedType[widget.fragmentPoolController.getCurrentPoolType]["scale"] ?? 1.0,
    );
  }

  @override
  Widget build(BuildContext context) => FragmentPoolWB(widget);
}
