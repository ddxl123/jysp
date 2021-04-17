import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:jysp/MVC/Controllers/FragmentPoolController/Enums.dart';
import 'package:jysp/MVC/Controllers/FragmentPoolController/FragmentPoolController.dart';
import 'package:jysp/MVC/Views/HomePage/SingleNode.dart';
import 'package:jysp/MVC/Views/HomePage/SnCompletePoolNode.dart';
import 'package:jysp/MVC/Views/HomePage/SnMemoryPoolNode.dart';
import 'package:jysp/MVC/Views/HomePage/SnPendingPoolNode.dart';
import 'package:jysp/MVC/Views/HomePage/SnRulePoolNode.dart';
import 'package:jysp/Tools/FreeBox/FreeBoxController.dart';
import 'package:provider/provider.dart';

class FragmentPool extends StatefulWidget {
  @override
  _FragmentPoolState createState() => _FragmentPoolState();
}

class _FragmentPoolState extends State<FragmentPool> {
  @override
  void initState() {
    super.initState();
    context.read<FragmentPoolController>().needInitStateForIsIniting = true;
    context.read<FragmentPoolController>().needInitStateForSetState = setState;
    // 初始化 build widget 完成后，进入默认的碎片池中
    WidgetsBinding.instance!.addPostFrameCallback(
      (timeStamp) {
        context.read<FragmentPoolController>().needInitStateForIsIniting = false;
        context.read<FragmentPoolController>().toPool(
              freeBoxController: context.read<FreeBoxController>(),
              toPoolType: context.read<FragmentPoolController>().getCurrentPoolType,
              toPoolTypeResult: (resultCode) {},
            );
      },
    );
  }

  void _toPosition() {
    WidgetsBinding.instance!.addPostFrameCallback(
      (timeStamp) {
        /// 滑动至上次保存的 offset 和 scale,
        /// 若上次没有保存, 则使用这次的 node0
        context.read<FreeBoxController>().targetSlide(
              targetOffset: context.read<FragmentPoolController>().viewSelectedType[context.read<FragmentPoolController>().getCurrentPoolType]!["offset"] ??
                  context.read<FragmentPoolController>().viewSelectedType[context.read<FragmentPoolController>().getCurrentPoolType]!["node0"],
              targetScale: context.read<FragmentPoolController>().viewSelectedType[context.read<FragmentPoolController>().getCurrentPoolType]!["scale"] ?? 1.0,
            );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    if (context.read<FragmentPoolController>().needInitStateForIsIniting) {
      return Text("initing...");
    }
    // _toPosition();

    switch (context.read<FragmentPoolController>().getCurrentPoolType) {
      case PoolType.pendingPool:
        return Stack(
          children: [
            for (var i = 0; i < context.read<FragmentPoolController>().pendingPoolNodes.length; i++) SnPendingPoolNode(index: i),
          ],
        );
      case PoolType.memoryPool:
        return Stack(
          children: [
            for (var i = 0; i < context.read<FragmentPoolController>().memoryPoolNodes.length; i++) SnMemoryPoolNode(index: i),
          ],
        );
      case PoolType.completePool:
        return Stack(
          children: [
            for (var i = 0; i < context.read<FragmentPoolController>().completePoolNodes.length; i++) SnCompletePoolNode(index: i),
          ],
        );
      case PoolType.rulePool:
        return Stack(
          children: [
            for (var i = 0; i < context.read<FragmentPoolController>().rulePoolNodes.length; i++) SnRulePoolNode(index: i),
          ],
        );
      default:
        return Stack(
          children: [
            Positioned(
              top: MediaQueryData.fromWindow(window).size.height / 2,
              left: MediaQueryData.fromWindow(window).size.width / 2,
              child: Text("PoolType unknown"),
            ),
          ],
        );
    }
  }
}
