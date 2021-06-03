import 'package:flutter/material.dart';
import 'package:jysp/Database/Models/MFragmentsAboutCompletePoolNode.dart';
import 'package:jysp/MVC/Controllers/FragmentPoolController/FragmentPoolController.dart';
import 'package:jysp/MVC/Controllers/HomePageController.dart';
import 'package:jysp/MVC/Views/HomePage/FragmentPool/FragmentPoolCommon/FreeBoxCommon.dart';
import 'package:jysp/MVC/Views/HomePage/FragmentPool/FragmentPoolCommon/PoolNodeCommon.dart';
import 'package:jysp/Tools/FreeBox/FreeBoxController.dart';
import 'package:jysp/Tools/Helper.dart';
import 'package:provider/provider.dart';

class CompletePoolFreeBox extends StatefulWidget {
  @override
  _CompletePoolFreeBoxState createState() => _CompletePoolFreeBoxState();
}

class _CompletePoolFreeBoxState extends State<CompletePoolFreeBox> {
  @override
  Widget build(BuildContext context) {
    const PoolType thisPoolType = PoolType.completePool;
    final FragmentPoolController thisFragmentPoolController = context.read<HomePageController>().getFragmentPoolController(thisPoolType);
    return FreeBoxCommon(
      poolType: thisPoolType,
      onLongPressStart: (ScaleStartDetails details) {},
      poolNodesCommon: FreeBoxStack(
        builder: (BuildContext context, SetState setState) {
          if (thisFragmentPoolController.poolNodesSetState != setState) {
            thisFragmentPoolController.poolNodesSetState = setState;
          }
          return <FreeBoxPositioned>[
            for (int i = 0; i < thisFragmentPoolController.poolNodes.length; i++)
              FreeBoxPositioned(
                boxPosition: stringToOffset(thisFragmentPoolController.poolNodes[i].get_box_position!),
                child: PoolNodeCommon(
                  poolType: thisPoolType,
                  poolNodeMModel: thisFragmentPoolController.poolNodes[i],
                  fragmentsTableName: MFragmentsAboutCompletePoolNode.tableName,
                  columns: <String>[MFragmentsAboutCompletePoolNode.title],
                ),
              ),
          ];
        },
      ),
    );
  }
}
