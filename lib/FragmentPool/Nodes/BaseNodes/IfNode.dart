import 'package:flutter/material.dart';
import 'package:jysp/FragmentPool/Nodes/BaseNodes/BaseNode.dart';
import 'package:jysp/FragmentPool/Nodes/SingleNodes/CollectionNode.dart';
import 'package:jysp/FragmentPool/Nodes/SingleNodes/OrdinaryNode.dart';
import 'package:jysp/G/G.dart';

class IfNode extends BaseNode {
  IfNode(int currentIndex, String thisRouteName, Map nodeLayoutMap) : super(currentIndex, thisRouteName, nodeLayoutMap);

  @override
  State<StatefulWidget> createState() => _IfNodeState();
}

class _IfNodeState extends State<IfNode> {
  @override
  Widget build(BuildContext context) {
    switch (G.fragmentPool.fragmentPoolPendingNodes[widget.currentIndex]["node_type"]) {
      case 0:
        return OrdinaryNode(widget.currentIndex, widget.thisRouteName, widget.nodeLayoutMap);
      case 1:
        return CollectionNode(widget.currentIndex, widget.thisRouteName, widget.nodeLayoutMap);
        break;
      default:
        return Container(
          child: Text("node_type异常"),
        );
    }
  }
}
