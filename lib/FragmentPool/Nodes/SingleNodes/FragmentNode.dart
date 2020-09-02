import 'package:flutter/material.dart';
import 'package:jysp/FragmentPool/Nodes/BaseNodes/BaseNode.dart';
import 'package:jysp/FragmentPool/Nodes/BaseNodes/MainNode.dart';
import 'package:jysp/FragmentPool/Nodes/ToolNodes/NodeMixin.dart';

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
          showNodeSheet(
            context: context,
            mainNode: widget.mainNode,
            mainNodeState: widget.mainNodeState,
            sliver1: SliverToBoxAdapter(
              child: FlatButton(
                child: Text("addChildNode"),
                onPressed: () {
                  nodeAddFragment(widget.mainNode, widget.mainNodeState);
                },
              ),
            ),
          );
        },
        child: Text(widget.mainNode.fragmentPoolDateList[widget.mainNode.index]["pool_display_name"]),
      ),
    );
  }
}
