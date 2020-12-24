import 'package:flutter/material.dart';
import 'package:jysp/FragmentPool/Nodes/BaseNodes/BaseNode.dart';
import 'package:jysp/FragmentPool/Nodes/NodeSheet/SheetLoadingArea.dart';
import 'package:jysp/FragmentPool/Nodes/NodeSheet/SheetSlivers.dart';
import 'package:jysp/G/G.dart';
import 'package:jysp/Pages/SheetPage.dart';
import 'package:jysp/Tools/CustomButton.dart';
import 'package:jysp/Tools/LoadingAnimation.dart';

class OrdinaryNode extends BaseNode {
  OrdinaryNode(int currentIndex, String thisRouteName, Map nodeLayoutMap) : super(currentIndex, thisRouteName, nodeLayoutMap);

  @override
  State<StatefulWidget> createState() => _OrdinaryNodeState();
}

class _OrdinaryNodeState extends State<OrdinaryNode> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.yellow,
      child: CustomButton(
        onPressed: () {
          Navigator.of(context).push(
            () {
              GlobalKey<_OrdinaryListState> key = GlobalKey<_OrdinaryListState>();
              return SheetRoute(
                slivers: (SheetPageController _sheetPageController) {
                  return [
                    SheetSliverHeader(widget.currentIndex, widget.thisRouteName, widget.nodeLayoutMap),
                    OrdinaryList(key: key),
                    SheetLoadingArea(
                      sheetPageController: _sheetPageController,
                      wait: Duration(seconds: 1),
                      startFuture: (LoadingController loadingController) {
                        /// TODO: 待定问题：route被dispose后异步仍然在继续
                        /// 不用担心被同时重复调用多次，因为 [toLoading][toSuccess][toFail] 中被限制如果同时多次，则被限制于一次。
                        // TODO: 直接获取本地数据(即当前node list中的数据),若本地与云端数据不同(用户不知道)，则用户手动点击 [刷新] 按钮同时进行当前页数据以及碎片池数据的刷新。
                        key.currentState._list.clear();
                        for (var i = 0; i < widget.nodeLayoutMap[widget.thisRouteName]["child_count"]; i++) {
                          key.currentState._list.add(G.fragmentPool.fragmentPoolPendingNodes[widget.nodeLayoutMap[widget.thisRouteName + "-" + i.toString()]["current_index"]]["name"]);
                        }
                        key.currentState.setState(() {});
                        loadingController.toSuccess();
                      },
                      isOnce: true,
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

class OrdinaryList extends StatefulWidget {
  OrdinaryList({Key key}) : super(key: key);

  @override
  _OrdinaryListState createState() => _OrdinaryListState();
}

class _OrdinaryListState extends State<OrdinaryList> {
  List _list = [];
  @override
  Widget build(BuildContext context) {
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (_, index) {
          return Container(
            child: Text(_list[index].toString()),
            height: 50,
          );
        },
        childCount: _list.length,
      ),
    );
  }
}
