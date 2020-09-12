import 'package:flutter/material.dart';
import 'package:jysp/FragmentPool/Nodes/BaseNodes/MainSingleNodeData.dart';
import 'package:jysp/FragmentPool/Nodes/ToolNodes/NodeMixin.dart';
import 'package:jysp/FragmentPool/Nodes/BaseNodes/BaseNode.dart';
import 'package:jysp/FragmentPool/Nodes/ToolNodes/NodeSheetRoute.dart';
import 'package:jysp/Tools/CustomButton.dart';
import 'package:jysp/Pages/LoadingPage.dart';

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
        onPressed: _onPressed,
        child: Text(widget.mainSingleNodeData.fragmentPoolDataList[widget.mainSingleNodeData.thisIndex]["pool_display_name"]),
      ),
    );
  }

  void _onPressed() {
    Navigator.of(context).push(
      NodeSheetRoute(
        mainSingleNodeData: widget.mainSingleNodeData,
        sliver1Builder: (_) {
          return SliverToBoxAdapter(
            child: FlatButton(
              child: Text("To loading"),
              onPressed: () {
                Navigator.of(context).push(LoadingPage());
              },
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
      ),
    );
  }
}
