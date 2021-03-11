import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:jysp/FragmentPool/FragmentPoolChoice.dart';
import 'package:jysp/LWCR/Controller/FragmentPoolController.dart';
import 'package:jysp/LWCR/Controller/FreeBoxController.dart';
import 'package:jysp/LWCR/LifeCycle/FragmentPoolLC.dart';
import 'package:jysp/LWCR/LifeCycle/FreeBoxLC.dart';
import 'package:jysp/Tools/RebuildHandler.dart';

class HomePage extends StatefulWidget {
  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  FreeBoxController _freeBoxController = FreeBoxController(Colors.green, double.maxFinite, double.maxFinite);
  FragmentPoolController _fragmentPoolController = FragmentPoolController();

  @override
  void dispose() {
    _freeBoxController.dispose();
    _fragmentPoolController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Stack(
        children: [
          FreeBoxLC(
            freeBoxController: _freeBoxController,
            freeMoveScaleLayerChild: FragmentPoolLC(fragmentPoolController: _fragmentPoolController, freeBoxController: _freeBoxController),
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
      child: TextButton(
        onPressed: () {
          _freeBoxController.targetSlide(
            targetOffset: Offset.zero,
            targetScale: 1.0,
          );
        },
        child: Icon(Icons.adjust),
      ),
    );
  }

  /// 加载屏障
  Widget _loadingBarrier() {
    return RebuildHandleWidget<LoadingBarrierHandlerEnum>(
      rebuildHandler: _fragmentPoolController.isLoadingBarrierRebuildHandler,
      builder: (handler) {
        if (handler.handleCode == LoadingBarrierHandlerEnum.enabled) {
          return Positioned(
            child: Container(
              alignment: Alignment.center,
              color: Color(0x7fffffff),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("加载中..."),
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
            Expanded(child: TextButton(onPressed: () {}, child: Text("发现"))),
            Expanded(child: FragmentPoolChoice(fragmentPoolController: _fragmentPoolController, freeBoxController: _freeBoxController)),
            Expanded(child: TextButton(onPressed: () {}, child: Text("我"))),
          ],
        ),
      ),
    );
  }
}
