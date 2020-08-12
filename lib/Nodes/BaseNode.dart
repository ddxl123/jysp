import 'package:flutter/material.dart';
import 'package:jysp/Nodes/SingleNodes/FolderNode.dart';
import 'package:jysp/Nodes/SingleNodes/FragmentNode.dart';
import 'package:jysp/Nodes/MainNode.dart';

abstract class BaseNode extends StatefulWidget {
  BaseNode(
    this.sn,
    this.snState,
  );

  final MainNode sn;
  final MainNodeState snState;
}

///
///
///
///
///
class IfNode extends BaseNode {
  IfNode(MainNode sn, MainNodeState snState) : super(sn, snState);

  @override
  _IfNodeState createState() => _IfNodeState();
}

class _IfNodeState extends State<IfNode> {
  @override
  Widget build(BuildContext context) {
    if (widget.sn.fragmentPoolDateList[widget.sn.fragmentPoolDateMap[widget.snState.thisRoute]["index"]]["type"] == 1) {
      return FolderNode(widget.sn, widget.snState);
    } else {
      return FragmentNode(widget.sn, widget.snState);
    }
  }
}
