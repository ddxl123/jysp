import 'package:flutter/material.dart';
import 'package:jysp/FragmentPool/Nodes/BaseNodes/BaseNode.dart';
import 'package:jysp/FragmentPool/Nodes/SingleNodes/OrdinaryNode.dart';
import 'package:jysp/FragmentPool/Nodes/SingleNodes/CollectionNode.dart';
import 'package:jysp/Global/GlobalData.dart';

class IfNode extends BaseNode {
  IfNode(int currentIndex, String thisRouteName, int childCount) : super(currentIndex, thisRouteName, childCount);

  @override
  State<StatefulWidget> createState() => _IfNodeState();
}

class _IfNodeState extends State<IfNode> {
  @override
  Widget build(BuildContext context) {
    switch (GlobalData.instance.userSelfInitFragmentPoolNodes[widget.currentIndex]["type"]) {
      case 0:
        return OrdinaryNode(widget.currentIndex, widget.thisRouteName, widget.childCount);
      case 1:
        return CollectionNode(widget.currentIndex, widget.thisRouteName, widget.childCount);
        break;
      default:
        return Container(
          child: Text("node_type异常"),
        );
    }
  }
}
