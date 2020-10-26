import 'package:flutter/material.dart';
import 'package:jysp/FragmentPool/FragmentPool.dart';
import 'package:jysp/FragmentPool/Nodes/BaseNodes/BaseNode.dart';
import 'package:jysp/FragmentPool/Nodes/ToolNodes/NodeMixin.dart';
import 'package:jysp/Global/GlobalData.dart';
import 'package:jysp/Pages/SheetPage.dart';
import 'package:jysp/Tools/CustomButton.dart';
import 'package:jysp/sheet/SheetMixin.dart';

class CollectionNode extends BaseNode {
  CollectionNode(int currentIndex, String thisRouteName, int childCount) : super(currentIndex, thisRouteName, childCount);

  @override
  State<StatefulWidget> createState() => _CollectionNode();
}

class _CollectionNode extends State<CollectionNode> with NodeMixin, SheetMixin {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.blue,
      child: CustomButton(
        color: Colors.yellow,
        onPressed: () {
          Navigator.of(context).push(
            SheetRoute(
              slivers: (SheetPageController _sheetPageController) {
                return [
                  mixinFixedWidget(),
                  mixinMappingWidget(),
                  SliverToBoxAdapter(
                    child: Container(
                      height: 600,
                    ),
                  ),
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
