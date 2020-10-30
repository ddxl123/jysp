import 'package:flutter/material.dart';
import 'package:jysp/FragmentPool/Nodes/BaseNodes/BaseNode.dart';
import 'package:jysp/Global/GlobalData.dart';
import 'package:jysp/Nodesheet/SheetPagePersistentDelegate.dart';

class SheetSliverHeader extends BaseNode {
  SheetSliverHeader(int currentIndex, String thisRouteName, Map nodeLayoutMap) : super(currentIndex, thisRouteName, nodeLayoutMap);

  @override
  _SheetSliverHeaderState createState() => _SheetSliverHeaderState();
}

class _SheetSliverHeaderState extends State<SheetSliverHeader> {
  @override
  Widget build(BuildContext context) {
    return SliverPersistentHeader(
      pinned: true,
      delegate: SheetPagePersistentDelegate(
        minHeight: 40.0,
        maxHeight: 40.0,
        child: Container(
          color: Colors.yellow,
          child: Row(
            children: [
              SizedBox(width: 20),
              Text("${GlobalData.instance.userSelfInitFragmentPoolNodes[widget.currentIndex]["text"]}：", style: TextStyle(fontSize: 18)),
              Expanded(child: Container()),
              Text("×", style: TextStyle(fontSize: 30)),
              SizedBox(width: 20),
            ],
          ),
        ),
      ),
    );
  }
}
