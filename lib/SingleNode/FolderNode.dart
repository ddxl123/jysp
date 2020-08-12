import 'package:flutter/material.dart';
import 'package:jysp/SingleNode/BaseNode.dart';
import 'package:jysp/SingleNode/MainNode.dart';

class FolderNode extends BaseNode {
  FolderNode(MainNode sn, MainNodeState snState) : super(sn, snState);

  @override
  State<StatefulWidget> createState() => _FolderNodeState();
}

class _FolderNodeState extends State<FolderNode> {
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
                            widget.sn.fragmentPoolDateList.add({
                              "route": () {
                                int childCount = 0;
                                for (int i = 0; i < widget.sn.fragmentPoolDateList.length; i++) {
                                  if (widget.sn.fragmentPoolDateMapClone.containsKey(widget.snState.thisRoute + "-$i")) {
                                    childCount++;
                                  } else {
                                    break;
                                  }
                                }
                                return widget.snState.thisRoute + "-$childCount";
                              }(),
                              "type": 1,
                              "out_display_name": "${widget.snState.thisRoute},hhhhh",
                            });
                            widget.sn.doChange();
                          },
                          child: Text("添加子级"),
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
