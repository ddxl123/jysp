import 'package:flutter/material.dart';
import 'package:jysp/Database/MergeModels/MMPoolNode.dart';
import 'package:jysp/MVC/Controllers/HomePageController.dart';
import 'package:provider/provider.dart';

class PoolNodesCommon extends StatefulWidget {
  const PoolNodesCommon({required this.poolNodeCommon});
  final Widget Function(MMPoolNode poolNodeMModel) poolNodeCommon;

  @override
  _PoolNodesCommonState createState() => _PoolNodesCommonState();
}

class _PoolNodesCommonState extends State<PoolNodesCommon> {
  @override
  void initState() {
    super.initState();
    context.read<HomePageController>().getCurrentFragmentPoolController().needInitStateForSetState = setState;
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        for (int i = 0;
            i <
                context.select<HomePageController, int>(
                  (HomePageController value) => value.getCurrentFragmentPoolController().poolNodes.length,
                );
            i++)
          //
          widget.poolNodeCommon(
            context.select<HomePageController, MMPoolNode>(
              (HomePageController value) => value.getCurrentFragmentPoolController().poolNodes[i],
            ),
          ),
      ],
    );
  }
}
