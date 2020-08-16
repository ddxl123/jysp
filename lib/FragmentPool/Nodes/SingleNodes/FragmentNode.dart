import 'package:flutter/material.dart';
import 'package:jysp/FragmentPool/Nodes/BaseNode.dart';
import 'package:jysp/FragmentPool/Nodes/MainNode.dart';
import 'package:jysp/FragmentPool/NodeMixin.dart';

class FragmentNode extends BaseNode {
  FragmentNode(MainNode mainNode, MainNodeState mainNodeState) : super(mainNode, mainNodeState);

  @override
  State<StatefulWidget> createState() => _FragmentNode();
}

class _FragmentNode extends State<FragmentNode> with NodeMixin {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.blue,
      child: FlatButton(
        onPressed: () {
          nodeShowBottomSheet(
            context: context,
            mainNode: widget.mainNode,
            mainNodeState: widget.mainNodeState,
          );
        },
        child: Text(widget.mainNode.fragmentPoolDateList[widget.mainNode.index]["pool_display_name"]),
      ),
    );
  }
}
