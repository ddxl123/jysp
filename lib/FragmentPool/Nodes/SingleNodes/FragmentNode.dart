import 'package:flutter/material.dart';
import 'package:jysp/FragmentPool/Nodes/BaseNodes/BaseNode.dart';
import 'package:jysp/FragmentPool/Nodes/BaseNodes/MainSingleNodeData.dart';
import 'package:jysp/FragmentPool/Nodes/ToolNodes/NodeMixin.dart';
import 'package:jysp/FragmentPool/Nodes/ToolNodes/NodeSheetRoute.dart';
import 'package:jysp/Tools/CustomButton.dart';

class FragmentNode extends BaseNode {
  FragmentNode(MainSingleNodeData mainSingleNodeData) : super(mainSingleNodeData);

  @override
  State<StatefulWidget> createState() => _FragmentNode();
}

class _FragmentNode extends State<FragmentNode> with NodeMixin {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.blue,
      child: CustomButton(
        onPressed: () {
          Navigator.of(context).push(
            NodeSheetRoute(
              mainSingleNodeData: widget.mainSingleNodeData,
              sliver1Builder: (_) {
                return SliverToBoxAdapter(
                  child: FlatButton(
                    child: Text("addChildNode"),
                    onPressed: () {
                      nodeAddFragment(mainSingleNodeData: widget.mainSingleNodeData);
                    },
                  ),
                );
              },
            ),
          );
        },
        child: Text(widget.mainSingleNodeData.fragmentPoolDataList[widget.mainSingleNodeData.thisIndex]["pool_display_name"]),
      ),
    );
  }
}
