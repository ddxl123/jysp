import 'package:flutter/material.dart';
import 'package:jysp/Nodes/BaseNode.dart';
import 'package:jysp/Nodes/MainNode.dart';
import 'package:jysp/Nodes/NodeMixins.dart';

class FolderNode extends BaseNode {
  FolderNode(MainNode sn, MainNodeState snState) : super(sn, snState);

  @override
  State<StatefulWidget> createState() => _FolderNodeState();
}

class _FolderNodeState extends State<FolderNode> with NodeMixins {
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
                        FlatButton(
                          onPressed: () {
                            addFragment(widget);
                          },
                          child: Text("添加碎片"),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        FlatButton(
                          onPressed: () {},
                          child: Text("添加父级"),
                        ),
                      ],
                    )
                  ],
                );
              });
        },
        child: Text(widget.sn.fragmentPoolDateList[widget.sn.index]["out_display_name"]),
      ),
    );
  }
}
