import 'package:flutter/material.dart';
import 'package:jysp/FragmentPool/FragmentPool.dart';
import 'package:jysp/FragmentPool/Nodes/BaseNodes/BaseNode.dart';
import 'package:jysp/FragmentPool/Nodes/ToolNodes/NodeMixin.dart';
import 'package:jysp/Global/GlobalData.dart';
import 'package:jysp/Tools/CustomButton.dart';

class CollectionNode extends BaseNode {
  CollectionNode(int currentIndex, String thisRouteName, int childCount) : super(currentIndex, thisRouteName, childCount);

  @override
  State<StatefulWidget> createState() => _CollectionNode();
}

class _CollectionNode extends State<CollectionNode> with NodeMixin {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.blue,
      child: CustomButton(
        color: Colors.yellow,
        onPressed: () {
          // Navigator.of(context).push(
          //   SheetRoute(
          //     mainSingleNodeData: widget.mainSingleNodeData,
          //     sliver1Builder: (_) {
          //       return SliverToBoxAdapter(
          //         child: FlatButton(
          //           child: Text("addChildNode"),
          //           onPressed: () {
          //             nodeAddFragment(mainSingleNodeData: widget.mainSingleNodeData);
          //           },
          //         ),
          //       );
          //     },
          //   ),
          // );
        },
        child: Text(GlobalData.instance.userSelfInitFragmentPoolNodes[widget.currentIndex]["text"]),
      ),
    );
  }
}
