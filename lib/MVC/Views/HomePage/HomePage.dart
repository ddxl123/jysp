import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:jysp/MVC/Controllers/FragmentPoolController.dart';
import 'package:jysp/MVC/Views/HomePage/FragmentPool.dart';
import 'package:jysp/Plugin/FreeBox/FreeBoxController.dart';
import 'package:jysp/FragmentPool/FragmentPoolChoice.dart';
import 'package:jysp/Plugin/FreeBox/FreeBox.dart';
import 'package:jysp/Tools/RebuildHandler.dart';
import 'package:jysp/Tools/TDebug.dart';
import 'package:provider/provider.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => FragmentPoolController()),
        ChangeNotifierProvider(create: (_) => FreeBoxController()),
      ],
      child: HomePageProxy(),
    );
  }
}

class HomePageProxy extends StatefulWidget {
  @override
  HomePageProxyState createState() => HomePageProxyState();
}

class HomePageProxyState extends State<HomePageProxy> {
  @override
  Widget build(BuildContext context) {
    dLog(() => "HomePage build");
    return Material(
      child: Stack(
        children: [
          FreeBox(
            backgroundColor: Colors.green,
            viewableWidth: double.maxFinite,
            viewableHeight: double.maxFinite,
            freeMoveScaleLayerBuilder: (_) => FragmentPool(),
            fixedLayerBuilder: (_) => Stack(
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
          context.read<FreeBoxController>().targetSlide(
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
      rebuildHandler: context.read<FragmentPoolController>().isLoadingBarrierRebuildHandler,
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
            Expanded(child: FragmentPoolChoice(fragmentPoolController: context.read<FragmentPoolController>(), freeBoxController: context.read<FreeBoxController>())),
            Expanded(child: TextButton(onPressed: () {}, child: Text("我"))),
          ],
        ),
      ),
    );
  }
}
