import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:jysp/FragmentPool/Nodes/BaseNodes/BaseNode.dart';
import 'package:jysp/FragmentPool/Nodes/NodeSheet/SheetLoadingArea.dart';
import 'package:jysp/FragmentPool/Nodes/NodeSheet/SheetSlivers.dart';
import 'package:jysp/G/G.dart';
import 'package:jysp/Pages/SheetPage.dart';
import 'package:jysp/Tools/CustomButton.dart';
import 'package:jysp/Tools/LoadingAnimation.dart';

class CollectionNode extends BaseNode {
  CollectionNode(int currentIndex, String thisRouteName, Map nodeLayoutMap) : super(currentIndex, thisRouteName, nodeLayoutMap);

  @override
  State<StatefulWidget> createState() => _CollectionNode();
}

class _CollectionNode extends State<CollectionNode> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.blue,
      child: CustomButton(
        onPressed: () {
          Navigator.of(context).push(
            () {
              GlobalKey<_CollectionListState> key = GlobalKey<_CollectionListState>();
              return SheetRoute(
                slivers: (SheetPageController _sheetPageController) {
                  return [
                    SheetSliverHeader(widget.currentIndex, widget.thisRouteName, widget.nodeLayoutMap),
                    CollectionList(key: key),
                    SheetLoadingArea(
                      sheetPageController: _sheetPageController,
                      wait: Duration(seconds: 1),
                      startFuture: (LoadingController loadingController) {
                        /// TODO: 先排序，再获取，新添加的放在最后
                        DefaultAssetBundle.of(context).loadString("assets/get_db/pool_node_fragment.json").then((value) {
                          Map val = json.decode(value);
                          int newts = key.currentState._list.length == 0 ? 0 : key.currentState._list[key.currentState._list.length - 1]["timestamp"] + 1;
                          if (val["fragments"].length != newts) {
                            for (var i = newts; i < newts + 10; i++) {
                              if (i > val["fragments"].length - 1) {
                                break;
                              }
                              key.currentState._list.add(val["fragments"][i]);
                            }
                            key.currentState.setState(() {});
                          }
                          loadingController.toSuccess();
                        });
                      },
                      isOnce: false,
                    ),
                  ];
                },
              );
            }(),
          );
        },
        child: Text(G.fragmentPool.fragmentPoolPendingNodes[widget.currentIndex]["name"]),
      ),
    );
  }
}

class CollectionList extends StatefulWidget {
  CollectionList({Key key}) : super(key: key);

  @override
  _CollectionListState createState() => _CollectionListState();
}

class _CollectionListState extends State<CollectionList> {
  List _list = [];
  @override
  Widget build(BuildContext context) {
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (_, index) {
          return Container(
            child: Text(_list[index]["title"].toString()),
            height: 50,
          );
        },
        childCount: _list.length,
      ),
    );
  }
}
