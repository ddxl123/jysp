import 'package:flutter/material.dart';
import 'package:jysp/Database/Models/MFragmentsAboutMemoryPoolNode.dart';
import 'package:jysp/MVC/Controllers/FragmentPoolController/FragmentPoolController.dart';
import 'package:jysp/MVC/Controllers/HomePageController.dart';
import 'package:jysp/MVC/Views/HomePage/FragmentPool/FragmentPoolCommon/FreeBoxCommon.dart';
import 'package:jysp/MVC/Views/HomePage/FragmentPool/FragmentPoolCommon/PoolNodeCommon.dart';
import 'package:jysp/Tools/FreeBox/FreeBoxController.dart';
import 'package:jysp/Tools/Helper.dart';
import 'package:provider/provider.dart';

class MemoryPoolFreeBox extends StatefulWidget {
  @override
  _MemoryPoolFreeBoxState createState() => _MemoryPoolFreeBoxState();
}

class _MemoryPoolFreeBoxState extends State<MemoryPoolFreeBox> {
  @override
  Widget build(BuildContext context) {
    const PoolType thisPoolType = PoolType.memoryPool;
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
                  fragmentsTableName: MFragmentsAboutMemoryPoolNode.tableName,
                  columns: <String>[MFragmentsAboutMemoryPoolNode.title],
                ),
              ),
          ];
        },
      ),
    );
  }
}
