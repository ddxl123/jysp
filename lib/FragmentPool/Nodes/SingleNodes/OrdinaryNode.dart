import 'package:flutter/material.dart';
import 'package:jysp/FragmentPool/FragmentPool.dart';
import 'package:jysp/FragmentPool/Nodes/BaseNodes/BaseNode.dart';
import 'package:jysp/FragmentPool/Nodes/ToolNodes/NodeMixin.dart';
import 'package:jysp/Global/GlobalData.dart';
import 'package:jysp/Pages/SheetPage.dart';
import 'package:jysp/Tools/CustomButton.dart';
import 'package:jysp/sheet/SheetMixin.dart';

class OrdinaryNode extends BaseNode {
  OrdinaryNode(int currentIndex, String thisRouteName, int childCount) : super(currentIndex, thisRouteName, childCount);

  @override
  State<StatefulWidget> createState() => _OrdinaryNodeState();
}

class _OrdinaryNodeState extends State<OrdinaryNode> with NodeMixin, SheetMixin {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.yellow,
      child: CustomButton(
        color: Colors.grey[300],
        onPressed: () {
          Navigator.of(context).push(
            SheetRoute(
              slivers: (SheetPageController _sheetPageController) {
                return [
                  // SliverToBoxAdapter(
                  //   child: FlatButton(
                  //     onPressed: () {
                  //       addOrdinalNode(widget.currentIndex, widget.thisRouteName, widget.childCount);
                  //     },
                  //     child: Text("data"),
                  //   ),
                  // ),
                  mixinFixedWidget(),
                  mixinMappingWidget(),
                  SheetLoadingArea(sheetPageController: _sheetPageController),
                ];
              },
            ),
          );
        },
        child: Text(GlobalData.instance.userSelfInitFragmentPoolNodes[widget.currentIndex]["text"]),
      ),
    );
  }
}
