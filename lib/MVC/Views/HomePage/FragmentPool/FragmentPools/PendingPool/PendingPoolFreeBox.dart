import 'package:flutter/material.dart';
import 'package:jysp/Database/Models/MPnPendingPoolNode.dart';
import 'package:jysp/MVC/Controllers/FragmentPoolController/FragmentPoolController.dart';
import 'package:jysp/MVC/Controllers/HomePageController.dart';
import 'package:jysp/MVC/Views/HomePage/FragmentPool/FragmentPoolCommon/FreeBoxCommon.dart';
import 'package:jysp/MVC/Views/HomePage/FragmentPool/FragmentPoolCommon/NodeJustCreatedCommon.dart';
import 'package:jysp/MVC/Views/HomePage/FragmentPool/FragmentPoolCommon/PoolNodeCommon.dart';
import 'package:jysp/Tools/FreeBox/FreeBoxController.dart';
import 'package:jysp/Tools/Helper.dart';
import 'package:jysp/Tools/TDebug.dart';
import 'package:uuid/uuid.dart';
import 'package:provider/provider.dart';

class PendingPoolFreeBox extends StatefulWidget {
  @override
  _PendingPoolFreeBoxState createState() => _PendingPoolFreeBoxState();
}

class _PendingPoolFreeBoxState extends State<PendingPoolFreeBox> {
  @override
  void dispose() {
    dLog(() => 'PendingPoolFreeBox dispose');
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    dLog(() => 'iPendingPoolFreeBox init');
  }

  @override
  Widget build(BuildContext context) {
    const PoolType thisPoolType = PoolType.pendingPool;
    final FragmentPoolController thisFragmentPoolController = context.read<HomePageController>().getFragmentPoolController(thisPoolType);
    return FreeBoxCommon(
      poolType: thisPoolType,
      poolNodesCommon: (FreeBoxPositioned freeBoxPositioned, SetState setState) {
        if (thisFragmentPoolController.poolNodesSetState != setState) {
          thisFragmentPoolController.poolNodesSetState = setState;
        }
        return Stack(
          children: <Positioned>[
            for (int i = 0; i < thisFragmentPoolController.poolNodes.length; i++)
              freeBoxPositioned(
                boxPosition: stringToOffset(thisFragmentPoolController.poolNodes[i].get_box_position),
                child: PoolNodeCommon(
                  poolType: thisPoolType,
                  poolNodeMModel: thisFragmentPoolController.poolNodes[i],
                ),
              ),
          ],
        );
      },
      onLongPressStart: (ScaleStartDetails details) {
        Navigator.push(
          context,
          NodeJustCreatedCommon(
            context,
            poolType: thisPoolType,
            screenPosition: details.focalPoint,
            newNodeModelCallback: (Offset boxPosition, String name) {
              return MPnPendingPoolNode.createModel(
                aiid_v: null,
                uuid_v: const Uuid().v4(),
                recommend_rule_aiid_v: null,
                recommend_rule_uuid_v: null,
                type_v: PendingPoolNodeType.ordinary,
                name_v: name,
                box_position_v: '${boxPosition.dx},${boxPosition.dy}',
                created_at_v: DateTime.now().millisecondsSinceEpoch,
                updated_at_v: DateTime.now().millisecondsSinceEpoch,
              );
            },
          ),
        );
      },
    );
  }
}
