import 'package:flutter/material.dart';
import 'package:jysp/MVC/Controllers/FragmentPoolController/FragmentPoolController.dart';
import 'package:jysp/MVC/Views/HomePage/SingleNode.dart';
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
      (Duration timeStamp) {
        context.read<FragmentPoolController>().needInitStateForIsIniting = false;
        context.read<FragmentPoolController>().toPool(
              freeBoxController: context.read<FragmentPoolController>().freeBoxController,
              toPoolType: context.read<FragmentPoolController>().getCurrentPoolType,
              toPoolTypeResult: (int resultCode) {},
            );
      },
    );
  }

  void _toPosition() {
    WidgetsBinding.instance!.addPostFrameCallback(
      (Duration timeStamp) {
        /// 滑动至上次保存的 offset 和 scale,
        /// 若上次没有保存, 则使用这次的 node0
        context.read<FragmentPoolController>().freeBoxController.targetSlide(
              targetOffset: context.read<FragmentPoolController>().viewSelectedType[context.read<FragmentPoolController>().getCurrentPoolType]!['offset'] as Offset? ??
                  context.read<FragmentPoolController>().viewSelectedType[context.read<FragmentPoolController>().getCurrentPoolType]!['node0']! as Offset,
              targetScale: context.read<FragmentPoolController>().viewSelectedType[context.read<FragmentPoolController>().getCurrentPoolType]!['scale'] as double? ?? 1.0,
            );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    if (context.read<FragmentPoolController>().needInitStateForIsIniting) {
      return const Text('initing...');
    }
    // _toPosition();
    return Stack(
      children: <Widget>[
        for (int i = 0; i < context.read<FragmentPoolController>().getPoolTypeNodesList().length; i++)
          () {
            return SingleNode(mmodel: context.read<FragmentPoolController>().getPoolTypeNodesList()[i]);
          }(),
      ],
    );
  }
}
