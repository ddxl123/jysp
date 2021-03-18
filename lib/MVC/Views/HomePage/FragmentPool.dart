import 'package:flutter/material.dart';
import 'package:jysp/MVC/Controllers/FragmentPoolController.dart';
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
    context.read<FragmentPoolController>().isIniting = true;
    WidgetsBinding.instance!.addPostFrameCallback(
      (timeStamp) {
        context.read<FragmentPoolController>().isIniting = false;
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
    context.select<FragmentPoolController, bool>((value) => value.doRebuild);

    if (context.read<FragmentPoolController>().isIniting) {
      return Text("initing...");
    }
    // _toPosition();
    return Stack(
      children: <Widget>[
        for (int childrenIndex = 0; childrenIndex < context.read<FragmentPoolController>().fragmentPoolNodes.length; childrenIndex++)
          () {
            return SingleNode(index: childrenIndex);
          }()
      ],
    );
  }
}
