import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:jysp/FragmentPool/FragmentPool/FragmentPool.dart';
import 'package:jysp/FragmentPool/FragmentPool/FragmentPoolController.dart';
import 'package:jysp/FragmentPool/FragmentPoolChoice.dart';
import 'package:jysp/FreeBox/FreeBoxController.dart';
import 'package:jysp/FreeBox/FreeBox.dart';
import 'package:jysp/Tools/RebuildHandler.dart';

///
///
/// 必需模块：[nodes]、[我中的内容]
///
///
class HomePage extends StatefulWidget {
  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  FreeBoxController _freeBoxController = FreeBoxController();
  FragmentPoolController _fragmentPoolController = FragmentPoolController();

  @override
  void dispose() {
    _freeBoxController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Stack(
        children: [
          FreeBox(
            backgroundColor: Colors.green,
            freeBoxController: _freeBoxController,
            freeMoveScaleLayerChild: FragmentPool(fragmentPoolController: _fragmentPoolController, freeBoxController: _freeBoxController),
            fixedLayerChild: Stack(
              children: <Widget>[
                _toZeroButton(),
                _loadingBarrier(),
                _bottomWidgets(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// 将镜头移至Zero的按钮
  Widget _toZeroButton() {
    return Positioned(
      bottom: 50,
      left: 0,
      child: FlatButton(
        onPressed: () {
          _freeBoxController.targetSlide(
            targetOffset: _fragmentPoolController.viewSelectedType[_fragmentPoolController.getCurrentFragmentPoolType]["node0"],
            targetScale: 1.0,
          );
        },
        child: Icon(Icons.adjust),
      ),
    );
  }

  Widget _loadingBarrier() {
    return RebuildHandleWidget(
      rebuildHandler: _fragmentPoolController.isLoadingBarrierRebuildHandler,
      builder: (handler) {
        if (handler.handleCode == 1) {
          return Positioned(
            child: Container(
              alignment: Alignment.center,
              color: Color(0x7fffffff),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("加载中..."),
                  TextButton(
                    child: Text("取消"),
                    onPressed: () {
                      _fragmentPoolController.interruptRefreshLayout();
                    },
                  ),
                ],
              ),
            ),
          );
        } else {
          return Container();
        }
      },
    );
  }

  Widget _bottomWidgets() {
    return Positioned(
      bottom: 0,
      child: Container(
        /// Row在Stack中默认不是撑满宽度
        width: MediaQueryData.fromWindow(window).size.width,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Expanded(child: FlatButton(onPressed: () {}, child: Text("发现"))),
            Expanded(child: FragmentPoolChoice(fragmentPoolController: _fragmentPoolController, freeBoxController: _freeBoxController)),
            Expanded(
                child: FlatButton(
                    onPressed: () {
                      // _fragmentPoolController.fragmentPoolNodes.removeLast();
                      _fragmentPoolController.interruptRefreshLayout();
                    },
                    child: Text("我"))),
          ],
        ),
      ),
    );
  }
}
