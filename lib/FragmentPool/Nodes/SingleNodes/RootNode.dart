import 'package:flutter/material.dart';
import 'package:jysp/FragmentPool/NodeMixin.dart';
import 'package:jysp/FragmentPool/Nodes/BaseNode.dart';
import 'package:jysp/FragmentPool/Nodes/MainNode.dart';

class RootNode extends BaseNode {
  RootNode(MainNode mainNode, MainNodeState mainNodeState) : super(mainNode, mainNodeState);

  @override
  State<StatefulWidget> createState() => _RootNodeState();
}

class _RootNodeState extends State<RootNode> with NodeMixin {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: FlatButton(
        onPressed: onPressed,
        child: Text(widget.mainNode.fragmentPoolDateList[widget.mainNode.index]["pool_display_name"]),
      ),
    );
  }

  void onPressed() {
    showNodeSheet(
      context: context,
      mainNode: widget.mainNode,
      mainNodeState: widget.mainNodeState,
      sliver1: SliverList(
        delegate: SliverChildBuilderDelegate(
          (_, index) {
            return Container(
              alignment: Alignment.center,
              child: Text(index.toString()),
            );
          },
          childCount: 10,
        ),
      ),
    );
  }
}
