import 'package:flutter/material.dart';
import 'package:jysp/FragmentPool/Nodes/BaseNodes/BaseNode.dart';
import 'package:jysp/FragmentPool/Nodes/BaseNodes/MainSingleNodeData.dart';
import 'package:jysp/FragmentPool/Nodes/SingleNodes/FolderNode.dart';
import 'package:jysp/FragmentPool/Nodes/SingleNodes/FragmentNode.dart';
import 'package:jysp/FragmentPool/Nodes/SingleNodes/RootNode.dart';

class IfNode extends BaseNode {
  IfNode(MainSingleNodeData mainSingleNodeData) : super(mainSingleNodeData);

  @override
  State<StatefulWidget> createState() => _IfNodeState();
}

class _IfNodeState extends State<IfNode> {
  @override
  Widget build(BuildContext context) {
    switch (widget.mainSingleNodeData.fragmentPoolDataList[widget.mainSingleNodeData.thisRouteMap["index"]]["type"]) {
      case 0:
        return RootNode(widget.mainSingleNodeData);
      case 1:
        return FolderNode(widget.mainSingleNodeData);
        break;
      case 2:
        return FragmentNode(widget.mainSingleNodeData);
      default:
        return Container(
          child: Text("未知"),
        );
    }
  }
}
