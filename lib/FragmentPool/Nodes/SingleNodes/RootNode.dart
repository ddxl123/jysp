import 'package:flutter/material.dart';
import 'package:jysp/FragmentPool/Nodes/BaseNodes/MainSingleNodeData.dart';
import 'package:jysp/FragmentPool/Nodes/ToolNodes/NodeMixin.dart';
import 'package:jysp/FragmentPool/Nodes/BaseNodes/BaseNode.dart';
import 'package:jysp/FragmentPool/Nodes/ToolNodes/ShowNodeSheet.dart';
import 'package:jysp/Tools/CustomButton.dart';
import 'package:jysp/Tools/LoadingPage.dart';

class RootNode extends BaseNode {
  RootNode(MainSingleNodeData singleNodeData) : super(singleNodeData);

  @override
  State<StatefulWidget> createState() => _RootNodeState();
}

class _RootNodeState extends State<RootNode> with NodeMixin {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 500,
      child: CustomButton(
        onPressed: onPressed,
        child: Text(widget.mainSingleNodeData.fragmentPoolDataList[widget.mainSingleNodeData.thisIndex]["pool_display_name"]),
      ),
    );
  }

  void onPressed() {
    showNodeSheet(
      relyContext: context,
      mainSingleNodeData: widget.mainSingleNodeData,
      sliver1Builder: (sheetContext) {
        return SliverToBoxAdapter(
          child: FlatButton(
            onPressed: () {
              Navigator.of(sheetContext).push(MaterialPageRoute(builder: (_) => LoadingPage()));
            },
            child: Text("To loading"),
          ),
        );
      },
      sliver2Builder: (_) {
        return SliverList(
          delegate: SliverChildBuilderDelegate(
            (_, index) {
              return Container(
                color: Colors.yellow,
                child: Text(index.toString()),
              );
            },
            childCount: 50,
          ),
        );
      },
    );
  }
}
