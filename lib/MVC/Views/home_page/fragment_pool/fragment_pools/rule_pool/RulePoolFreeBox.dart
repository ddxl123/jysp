import 'package:flutter/material.dart';
import 'package:jysp/database/merge_models/MMFragmentsAboutPoolNode.dart';
import 'package:jysp/database/models/MFragmentsAboutRulePoolNode.dart';
import 'package:jysp/mvc/controllers/HomePageController.dart';
import 'package:jysp/mvc/controllers/fragment_pool_controller/FragmentPoolController.dart';
import 'package:jysp/mvc/views/home_page/fragment_pool/fragment_pool_common/FragmentButtonCommon.dart';
import 'package:jysp/mvc/views/home_page/fragment_pool/fragment_pool_common/FreeBoxCommon.dart';
import 'package:jysp/mvc/views/home_page/fragment_pool/fragment_pool_common/PoolNodeCommon.dart';
import 'package:jysp/mvc/views/home_page/fragment_pool/fragment_pool_common/PoolNodeSheetCommon.dart';
import 'package:jysp/tools/Helper.dart';
import 'package:jysp/tools/free_box/FreeBoxController.dart';
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
      poolNodesCommon: FreeBoxStack(
        builder: (BuildContext context, SetState fbsSetState) {
          thisFragmentPoolController.poolNodesSetState ??= fbsSetState;
          return <FreeBoxPositioned>[
            for (int i = 0; i < thisFragmentPoolController.poolNodes.length; i++)
              FreeBoxPositioned(
                boxPosition: stringToOffset(thisFragmentPoolController.poolNodes[i].get_box_position!),
                child: PoolNodeCommon(
                  poolType: thisPoolType,
                  poolNodeMModel: thisFragmentPoolController.poolNodes[i],
                  sheetPageBuilder: () => PoolNodeSheetCommon(
                    poolNodeMModel: thisFragmentPoolController.poolNodes[i],
                    fragmentsTableName: MFragmentsAboutRulePoolNode.tableName,
                    fragmentsForeignKeyNameAIIDForNode: MFragmentsAboutRulePoolNode.pn_rule_pool_node_aiid,
                    fragmentsForeignKeyNameUUIDForNode: MFragmentsAboutRulePoolNode.pn_rule_pool_node_uuid,
                    columns: <String>[MFragmentsAboutRulePoolNode.id, MFragmentsAboutRulePoolNode.title],
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
