import 'package:flutter/material.dart';
import 'package:jysp/FragmentPool/Nodes/BaseNodes/BaseNode.dart';
import 'package:jysp/G/G.dart';
import 'package:jysp/Tools/BasePersistentDelegate.dart';
import 'package:jysp/Tools/CustomButton.dart';

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
      delegate: BasePersistentDelegate(
        minHeight: 40.0,
        maxHeight: 40.0,
        child: Container(
          color: Colors.yellow,
          child: Row(
            children: [
              SizedBox(width: 20),
              Text("${G.fragmentPool.fragmentPoolPendingNodes[widget.currentIndex]["name"]}：", style: TextStyle(fontSize: 18)),
              Expanded(child: Container()),
              CustomButton(
                upBackgroundColor: Colors.transparent,
                downBackgroundColor: Colors.transparent,
                child: Text("添加"),
                onPressed: () {},
              ),
              SizedBox(width: 20),
              CustomButton(
                upBackgroundColor: Colors.transparent,
                downBackgroundColor: Colors.transparent,
                child: Text("删除"),
                onPressed: () {},
              ),
              SizedBox(width: 20),
              CustomButton(
                upBackgroundColor: Colors.transparent,
                downBackgroundColor: Colors.transparent,
                child: Text("×", style: TextStyle(fontSize: 30)),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
              SizedBox(width: 20),
            ],
          ),
        ),
      ),
    );
  }
}
