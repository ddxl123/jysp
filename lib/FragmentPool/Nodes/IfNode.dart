import 'package:flutter/material.dart';
import 'package:jysp/FragmentPool/Nodes/BaseNode.dart';
import 'package:jysp/FragmentPool/Nodes/MainNode.dart';
import 'package:jysp/FragmentPool/Nodes/SingleNodes/FolderNode.dart';
import 'package:jysp/FragmentPool/Nodes/SingleNodes/FragmentNode.dart';
import 'package:jysp/FragmentPool/Nodes/SingleNodes/RootNode.dart';

class IfNode extends BaseNode {
  IfNode(MainNode mainNode, MainNodeState mainNodeState) : super(mainNode, mainNodeState);

  @override
  _IfNodeState createState() => _IfNodeState();
}

class _IfNodeState extends State<IfNode> {
  @override
  Widget build(BuildContext context) {
    switch (widget.mainNode.fragmentPoolDateList[widget.mainNode.fragmentPoolDateMap[widget.mainNodeState.thisRoute]["index"]]["type"]) {
      case 0:
        return RootNode(widget.mainNode, widget.mainNodeState);
      case 1:
        return FolderNode(widget.mainNode, widget.mainNodeState);
        break;
      case 2:
        return FragmentNode(widget.mainNode, widget.mainNodeState);
      default:
        return Container(
          child: Text("未知"),
        );
    }
  }
}
