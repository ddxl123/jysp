import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:jysp/FragmentPool/FragmentPool/FragmentPoolController.dart';
import 'package:jysp/FragmentPool/FragmentPoolEnum.dart';
import 'package:jysp/FragmentPool/SingleNode/SingleNode.dart';
import 'package:jysp/FreeBox/FreeBoxController.dart';
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
      dPrint("-----------------------:" + widget.fragmentPoolController.getCurrentFragmentPoolType.toString());
      dPrint("-----------------------:" + widget.fragmentPoolController.viewSelectedType.toString());
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
  Widget build(BuildContext context) {
    /// 检测 nodes 数量是否为0, 若为0则生成一个
    if (widget.fragmentPoolController.fragmentPoolNodes.isEmpty) {
      widget.fragmentPoolController.fragmentPoolNodes.add(widget.fragmentPoolController.nullNode);
    }
    return Stack(
      children: <Widget>[
        for (int childrenIndex = 0; childrenIndex <= widget.fragmentPoolController.fragmentPoolNodes.length; childrenIndex++)
          () {
            if (childrenIndex == widget.fragmentPoolController.fragmentPoolNodes.length) {
              return End(fragmentPoolController: widget.fragmentPoolController);
            }
            return SingleNode(
              index: childrenIndex,
              thisRouteName: widget.fragmentPoolController.fragmentPoolNodes[childrenIndex]["route"],
              fragmentPoolController: widget.fragmentPoolController,
            );
          }()
      ],
    );
  }
}

///
///
/// 完成最好的 build 调用
class End extends StatefulWidget {
  End({@required this.fragmentPoolController});
  final FragmentPoolController fragmentPoolController;

  @override
  _EndState createState() => _EndState();
}

class _EndState extends State<End> {
  /// 每个 node 的宽高都被获取完成后
  void _getLayout() {
    if (widget.fragmentPoolController.getFragmentPoolRefreshStatus == FragmentPoolRefreshStatus.willGetLayout) {
      /// 防止被执行多次
      widget.fragmentPoolController.setFragmentPoolRefreshStatus = FragmentPoolRefreshStatus.willSetLayout;
      dPrint("3-willSetLayout");

      /// 每个 node 都被 [build] 完成后调用
      WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
        widget.fragmentPoolController.setFragmentPoolRefreshStatus = FragmentPoolRefreshStatus.setLayoutDone;
        dPrint("4-setLayoutDone");
        widget.fragmentPoolController.setLayout();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    _getLayout();
    return Container();
  }
}
