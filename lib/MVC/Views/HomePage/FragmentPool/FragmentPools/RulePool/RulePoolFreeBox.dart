import 'package:flutter/material.dart';
import 'package:jysp/MVC/Controllers/FragmentPoolController/FragmentPoolController.dart';
import 'package:jysp/MVC/Controllers/HomePageController.dart';
import 'package:jysp/MVC/Views/HomePage/FragmentPool/FragmentPoolCommon/FreeBoxCommon.dart';
import 'package:jysp/MVC/Views/HomePage/FragmentPool/FragmentPoolCommon/PoolNodeCommon.dart';
import 'package:jysp/Tools/FreeBox/FreeBoxController.dart';
import 'package:jysp/Tools/Helper.dart';
import 'package:provider/provider.dart';

class RulePoolFreeBox extends StatefulWidget {
  @override
  _RulePoolFreeBoxState createState() => _RulePoolFreeBoxState();
}

class _RulePoolFreeBoxState extends State<RulePoolFreeBox> {
  @override
  Widget build(BuildContext context) {
    const PoolType thisPoolType = PoolType.rulePool;
    final FragmentPoolController thisFragmentPoolController = context.read<HomePageController>().getFragmentPoolController(thisPoolType);
    return FreeBoxCommon(
      poolType: thisPoolType,
      onLongPressStart: (ScaleStartDetails details) {},
      poolNodesCommon: (FreeBoxPositioned freeBoxPositioned, SetState setState) {
        if (thisFragmentPoolController.poolNodesSetState != setState) {
          thisFragmentPoolController.poolNodesSetState = setState;
        }
        return Stack(
          children: <Positioned>[
            for (int i = 0; i < thisFragmentPoolController.poolNodes.length; i++)
              freeBoxPositioned(
                boxPosition: stringToOffset(thisFragmentPoolController.poolNodes[i].get_box_position!),
                child: PoolNodeCommon(
                  poolType: thisPoolType,
                  poolNodeMModel: thisFragmentPoolController.poolNodes[i],
                ),
              ),
          ],
        );
      },
    );
  }
}
