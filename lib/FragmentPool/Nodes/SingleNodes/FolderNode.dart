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
            sliverList: (circularRadius, uniformBottomWidget) => sliverList(circularRadius, uniformBottomWidget),
          );
        },
        child: Text(widget.mainNode.fragmentPoolDateList[widget.mainNode.index]["out_display_name"]),
      ),
    );
  }

  @override
  List<Widget> sliverList(double circularRadius, Widget uniformBottomWidget) {
    return [
      SliverToBoxAdapter(
        child: Container(
          height: circularRadius,
        ),
      ),
      SliverList(
        delegate: SliverChildBuilderDelegate(
          (_, index) {
            return Text(index.toString());
          },
          childCount: 20,
        ),
      ),
      uniformBottomWidget,
    ];
  }
}
