import 'package:flutter/material.dart';
import 'package:jysp/Database/Models/MPnPendingPoolNode.dart';
import 'package:jysp/MVC/Views/HomePage/FragmentPool/FragmentPoolCommon/FreeBoxCommon.dart';
import 'package:jysp/MVC/Views/HomePage/FragmentPool/FragmentPoolCommon/NodeJustCreatedCommon.dart';
import 'package:jysp/MVC/Views/HomePage/FragmentPool/FragmentPools/PendingPool/PendingPoolNodes.dart';
import 'package:uuid/uuid.dart';

class PendingPoolFreeBox extends StatefulWidget {
  @override
  _PendingPoolFreeBoxState createState() => _PendingPoolFreeBoxState();
}

class _PendingPoolFreeBoxState extends State<PendingPoolFreeBox> {
  @override
  Widget build(BuildContext context) {
    return FreeBoxCommon(
      poolNodesCommon: PendingPoolNodes(),
      onLongPressStart: (ScaleStartDetails details) {
        Navigator.push(
          context,
          NodeJustCreatedCommon(
            context,
            screenPosition: details.focalPoint,
            newNodeModelCallback: (Offset poolPositon, String name) {
              return MPnPendingPoolNode.createModel(
                aiid_v: null,
                uuid_v: const Uuid().v4(),
                recommend_rule_aiid_v: null,
                recommend_rule_uuid_v: null,
                type_v: PendingPoolNodeType.ordinary,
                name_v: name,
                position_v: '${details.focalPoint.dx},${details.focalPoint.dy}',
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
