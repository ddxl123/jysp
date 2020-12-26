import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:jysp/FragmentPool/FragmentPool/FragmentPool.dart';
import 'package:jysp/FragmentPool/FragmentPool/FragmentPoolController.dart';
import 'package:jysp/FragmentPool/FragmentPoolChoice.dart';
import 'package:jysp/FragmentPool/FragmentPoolEnum.dart';
import 'package:jysp/FreeBox/FreeBoxController.dart';
import 'package:jysp/FreeBox/FreeBox.dart';

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
            freeMoveScaleLayerChild: FragmentPool(fragmentPoolController: _fragmentPoolController),
            fixedLayerChild: Stack(
              children: <Widget>[
                _toZeroWidget(),
                _bottomWidget(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// 将镜头移至Zero的按钮
  Widget _toZeroWidget() {
    return Positioned(
      bottom: 50,
      left: 0,
      child: FlatButton(
        onPressed: () {
          _freeBoxController.targetSlide(_fragmentPoolController.node0Position);
        },
        child: Icon(Icons.adjust),
      ),
    );
  }

  Widget _bottomWidget() {
    return Positioned(
      bottom: 0,
      child: Container(
        /// Row在Stack中默认不是撑满宽度
        width: MediaQueryData.fromWindow(window).size.width,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Expanded(child: FlatButton(onPressed: () {}, child: Text("发现"))),
            Expanded(child: FragmentPoolChoice(fragmentPoolController: _fragmentPoolController)),
            Expanded(child: FlatButton(onPressed: () {}, child: Text("我"))),
          ],
        ),
      ),
    );
  }
}
