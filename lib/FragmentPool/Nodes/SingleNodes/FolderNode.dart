import 'dart:math';

import 'package:flutter/material.dart';
import 'package:jysp/FragmentPool/Nodes/BaseNode.dart';
import 'package:jysp/FragmentPool/Nodes/MainNode.dart';
import 'package:jysp/FragmentPool/NodeMixin.dart';

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
