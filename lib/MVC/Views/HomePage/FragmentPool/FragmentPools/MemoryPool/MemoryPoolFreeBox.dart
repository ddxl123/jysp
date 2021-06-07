import 'package:flutter/material.dart';
import 'package:jysp/Database/MergeModels/MMFragmentsAboutPoolNode.dart';
import 'package:jysp/Database/Models/MFragmentsAboutMemoryPoolNode.dart';
import 'package:jysp/MVC/Controllers/FragmentPoolController/FragmentPoolController.dart';
import 'package:jysp/MVC/Controllers/HomePageController.dart';
import 'package:jysp/MVC/Views/HomePage/FragmentPool/FragmentPoolCommon/FragmentButtonCommon.dart';
import 'package:jysp/MVC/Views/HomePage/FragmentPool/FragmentPoolCommon/FreeBoxCommon.dart';
import 'package:jysp/MVC/Views/HomePage/FragmentPool/FragmentPoolCommon/PoolNodeCommon.dart';
import 'package:jysp/MVC/Views/HomePage/FragmentPool/FragmentPoolCommon/PoolNodeSheetCommon.dart';
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
      poolNodesCommon: FreeBoxStack(
        builder: (BuildContext context, SetState setState) {
          thisFragmentPoolController.poolNodesSetState ??= putSetState(setState);
          return <FreeBoxPositioned>[
            for (int i = 0; i < thisFragmentPoolController.poolNodes.length; i++)
              FreeBoxPositioned(
                boxPosition: stringToOffset(thisFragmentPoolController.poolNodes[i].get_box_position!),
                child: PoolNodeCommon(
                  poolType: thisPoolType,
                  poolNodeMModel: thisFragmentPoolController.poolNodes[i],
                  sheetPageBuilder: () => PoolNodeSheetCommon(
                    poolNodeMModel: thisFragmentPoolController.poolNodes[i],
                    fragmentsTableName: MFragmentsAboutMemoryPoolNode.tableName,
                    fragmentsForeignKeyNameAIIDForNode: MFragmentsAboutMemoryPoolNode.pn_memory_pool_node_aiid,
                    fragmentsForeignKeyNameUUIDForNode: MFragmentsAboutMemoryPoolNode.pn_memory_pool_node_uuid,
                    columns: <String>[MFragmentsAboutMemoryPoolNode.id, MFragmentsAboutMemoryPoolNode.title],
                    buttonsBuilder: (MMFragmentsAboutPoolNode bodyDataElement, BuildContext btnContext, SetState btnSetState) {
                      return FragmentButtonCommon(mmFragmentsAboutPoolNode: bodyDataElement);
                    },
                  ),
                ),
              ),
          ];
        },
      ),
      onLongPressStart: (PointerDownEvent event) {},
    );
  }
}
