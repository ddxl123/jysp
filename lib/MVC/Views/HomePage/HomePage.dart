import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:jysp/MVC/Controllers/FragmentPoolController/FragmentPoolController.dart';
import 'package:jysp/MVC/Views/HomePage/FragmentPool.dart';
import 'package:jysp/FragmentPool/FragmentPoolChoice.dart';
import 'package:jysp/MVC/Views/HomePage/ToastRoutes/NodeJustCreatedRoute.dart';
import 'package:jysp/Tools/FreeBox/FreeBox.dart';
import 'package:jysp/Tools/TDebug.dart';
import 'package:jysp/Tools/Toast/ShowToast.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    dLog(() => 'HomePage build');
    return Material(
      child: Stack(
        children: <Widget>[
          FreeBox(
            freeBoxController: context.read<FragmentPoolController>().freeBoxController,
            backgroundColor: Colors.green,
            viewableWidth: double.maxFinite,
            viewableHeight: double.maxFinite,
            freeMoveScaleLayerBuilder: (_) => FragmentPool(),
            fixedLayerBuilder: (_) => Stack(
              children: <Widget>[
                _toZeroButton(),
                _addNode(),
                _bottomWidgets(),
              ],
            ),
            onLongPressStart: (ScaleStartDetails details) {
              dLog(() => 'details.focalPoint', () => details.focalPoint);
              showToastRoute(context, NodeJustCreatedRoute(context, screenPosition: details.focalPoint));
            },
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
          context.read<FragmentPoolController>().freeBoxController.targetSlide(
                targetOffset: Offset.zero,
                targetScale: 1.0,
              );
        },
        child: const Icon(Icons.adjust),
      ),
    );
  }

  /// 添加节点
  Widget _addNode() {
    return Positioned(
      top: MediaQueryData.fromWindow(window).padding.top,
      right: 0,
      child: TextButton(child: const Text('+', style: TextStyle(color: Colors.red, fontSize: 20)), onPressed: () {}),
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
          children: <Widget>[
            Expanded(child: TextButton(onPressed: () {}, child: const Text('发现'))),
            Expanded(
              child: FragmentPoolChoice(
                fragmentPoolController: context.read<FragmentPoolController>(),
                freeBoxController: context.read<FragmentPoolController>().freeBoxController,
              ),
            ),
            Expanded(child: TextButton(onPressed: () {}, child: const Text('我'))),
          ],
        ),
      ),
    );
  }
}
