import 'package:flutter/material.dart';
import 'package:jysp/database/merge_models/MMFragmentsAboutPoolNode.dart';
import 'package:jysp/database/models/MFragmentsAboutPendingPoolNode.dart';
import 'package:jysp/database/models/MPnPendingPoolNode.dart';
import 'package:jysp/mvc/controllers/HomePageController.dart';
import 'package:jysp/mvc/controllers/fragment_pool_controller/FragmentPoolController.dart';
import 'package:jysp/mvc/views/home_page/fragment_pool/fragment_pool_common/FragmentButtonCommon.dart';
import 'package:jysp/mvc/views/home_page/fragment_pool/fragment_pool_common/FreeBoxCommon.dart';
import 'package:jysp/mvc/views/home_page/fragment_pool/fragment_pool_common/PoolNodeCommon.dart';
import 'package:jysp/mvc/views/home_page/fragment_pool/fragment_pool_common/PoolNodeSheetCommon.dart';
import 'package:jysp/mvc/views/home_page/fragment_pool/fragment_pool_common/fragment_pool_toast_route_commons/NodeJustCreatedCommon.dart';
import 'package:jysp/tools/Helper.dart';
import 'package:jysp/tools/TDebug.dart';
import 'package:jysp/tools/free_box/FreeBoxController.dart';
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
      poolNodesCommon: FreeBoxStack(
        builder: (BuildContext context, SetState setState) {
          thisFragmentPoolController.poolNodesSetState ??= putSetState(setState);
          return <FreeBoxPositioned>[
            for (int i = 0; i < thisFragmentPoolController.poolNodes.length; i++)
              FreeBoxPositioned(
                boxPosition: stringToOffset(thisFragmentPoolController.poolNodes[i].get_box_position),
                child: PoolNodeCommon(
                  poolType: thisPoolType,
                  poolNodeMModel: thisFragmentPoolController.poolNodes[i],
                  sheetPageBuilder: () => PoolNodeSheetCommon(
                    poolNodeMModel: thisFragmentPoolController.poolNodes[i],
                    fragmentsTableName: MFragmentsAboutPendingPoolNode.tableName,
                    fragmentsForeignKeyNameAIIDForNode: MFragmentsAboutPendingPoolNode.pn_pending_pool_node_aiid,
                    fragmentsForeignKeyNameUUIDForNode: MFragmentsAboutPendingPoolNode.pn_pending_pool_node_uuid,
                    columns: <String>[MFragmentsAboutPendingPoolNode.id, MFragmentsAboutPendingPoolNode.title],
                    buttonsBuilder: (MMFragmentsAboutPoolNode bodyDataElement, BuildContext btnContext, SetState btnSetState) {
                      return FragmentButtonCommon(mmFragmentsAboutPoolNode: bodyDataElement);
                    },
                  ),
                ),
              ),
          ];
        },
      ),
      onLongPressStart: (PointerDownEvent event) {
        Navigator.push(
          context,
          NodeJustCreatedCommon(
            context,
            poolType: thisPoolType,
            screenPosition: event.localPosition,
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
