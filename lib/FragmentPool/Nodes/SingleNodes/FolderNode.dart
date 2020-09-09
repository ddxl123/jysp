import 'package:flutter/material.dart';
import 'package:jysp/FragmentPool/Nodes/BaseNodes/BaseNode.dart';
import 'package:jysp/FragmentPool/Nodes/BaseNodes/MainSingleNodeData.dart';
import 'package:jysp/FragmentPool/Nodes/ToolNodes/NodeMixin.dart';
import 'package:jysp/FragmentPool/Nodes/ToolNodes/ShowNodeSheet.dart';
import 'package:jysp/Tools/CustomButton.dart';

class FolderNode extends BaseNode {
  FolderNode(MainSingleNodeData singleNodeData) : super(singleNodeData);

  @override
  State<StatefulWidget> createState() => _FolderNodeState();
}

class _FolderNodeState extends State<FolderNode> with NodeMixin {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.yellow,
      child: CustomButton(
        onPressed: () {
          showNodeSheet(
              relyContext: context,
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
              });
        },
        child: Text(widget.mainSingleNodeData.fragmentPoolDataList[widget.mainSingleNodeData.thisIndex]["pool_display_name"]),
      ),
    );
  }
}
