import 'package:flutter/material.dart';
import 'package:jysp/SingleNode/FolderNode.dart';
import 'package:jysp/SingleNode/SingleNode.dart';

class IfNode extends StatelessWidget {
  IfNode({
    Key key,
    @required this.sn,
    @required this.snState,
  }) : super(key: key);
  final SingleNode sn;
  final SingleNodeState snState;

  @override
  Widget build(BuildContext context) {
    if (sn.fragmentPoolDateList[sn.fragmentPoolDateMap[snState.thisRoute]["index"]]["type"] == 1) {
      return FolderNode(sn: sn, snState: snState);
    } else {
      return Text("data");
    }
  }
}
