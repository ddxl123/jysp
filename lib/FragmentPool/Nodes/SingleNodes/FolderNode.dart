import 'dart:math';

import 'package:flutter/material.dart';
import 'package:jysp/FragmentPool/Nodes/BaseNodes/BaseNode.dart';
import 'package:jysp/FragmentPool/Nodes/BaseNodes/MainNode.dart';
import 'package:jysp/FragmentPool/Nodes/ToolNodes/NodeMixin.dart';

class FolderNode extends BaseNode {
  FolderNode(MainNode mainNode, MainNodeState mainNodeState) : super(mainNode, mainNodeState);

  @override
  State<StatefulWidget> createState() => _FolderNodeState();
}

class _FolderNodeState extends State<FolderNode> with NodeMixin {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.yellow,
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
