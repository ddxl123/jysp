import 'package:flutter/material.dart';
import 'package:jysp/SingleNode/BaseNode.dart';
import 'package:jysp/SingleNode/MainNode.dart';

class FragmentNode extends BaseNode {
  FragmentNode(MainNode sn, MainNodeState snState) : super(sn, snState);

  @override
  State<StatefulWidget> createState() => _FragmentNode();
}

class _FragmentNode extends State<FragmentNode> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.yellow,
      child: FlatButton(
        onPressed: () {
          showBottomSheet(
              context: context,
              builder: (_) {
                return Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Container(
                          alignment: Alignment.center,
                          height: 200,
                          child: Text("这是FragmentNode"),
                        ),
                      ],
                    ),
                  ],
                );
              });
        },
        child: Text(widget.sn.fragmentPoolDateList[widget.sn.index]["out_display_name"]),
      ),
    );
  }
}
