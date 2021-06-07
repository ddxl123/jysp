import 'package:flutter/material.dart';
import 'package:jysp/Database/MergeModels/MMFragmentsAboutPoolNode.dart';
import 'package:jysp/Database/Models/MFragmentsAboutRulePoolNode.dart';
import 'package:jysp/MVC/Controllers/FragmentPoolController/FragmentPoolController.dart';
import 'package:jysp/MVC/Controllers/HomePageController.dart';
import 'package:jysp/MVC/Views/HomePage/FragmentPool/FragmentPoolCommon/FragmentButtonCommon.dart';
import 'package:jysp/MVC/Views/HomePage/FragmentPool/FragmentPoolCommon/FreeBoxCommon.dart';
import 'package:jysp/MVC/Views/HomePage/FragmentPool/FragmentPoolCommon/PoolNodeCommon.dart';
import 'package:jysp/MVC/Views/HomePage/FragmentPool/FragmentPoolCommon/PoolNodeSheetCommon.dart';
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
