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
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                  alignment: Alignment.center,
                  child: Text("这是FragmentNode"),
                ),
              ],
            ),
          ],
        ),
      ),
    ];
  }
}
