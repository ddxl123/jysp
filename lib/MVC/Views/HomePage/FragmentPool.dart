import 'package:flutter/material.dart';
import 'package:jysp/MVC/Controllers/FragmentPoolController/Enums.dart';
import 'package:jysp/MVC/Controllers/FragmentPoolController/FragmentPoolController.dart';
import 'package:jysp/MVC/Views/HomePage/SingleNode.dart';
import 'package:jysp/Plugin/FreeBox/FreeBoxController.dart';
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
    context.read<FragmentPoolController>().needInitStateForSetState = () {
      setState(() {});
    };
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
    return Stack(
      children: <Widget>[
        for (int childrenIndex = 0;
            childrenIndex <
                () {
                  switch (context.read<FragmentPoolController>().getCurrentPoolType) {
                    case PoolType.pendingPool:
                      return context.read<FragmentPoolController>().pendingPoolNodes.length;
                    case PoolType.memoryPool:
                      return context.read<FragmentPoolController>().memoryPoolNodes.length;
                    case PoolType.completePool:
                      return context.read<FragmentPoolController>().completePoolNodes.length;
                    case PoolType.rulePool:
                      return context.read<FragmentPoolController>().rulePoolNodes.length;
                    default:
                      return 0;
                  }
                }();
            childrenIndex++)
          () {
            return SingleNode(index: childrenIndex);
          }()
      ],
    );
  }
}
