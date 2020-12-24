import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:jysp/FragmentPool/FragmentPool.dart';
import 'package:jysp/FragmentPool/FragmentPoolEnum.dart';
import 'package:jysp/FragmentPool/FragmentPoolState.dart';
import 'package:jysp/FreeBox/FreeBoxController.dart';
import 'package:jysp/G/G.dart';
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
  FragmentPoolState _fragmentPoolState = FragmentPoolState();

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
            freeMoveScaleLayerChild: FragmentPool(fragmentPoolState: _fragmentPoolState),
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
          _freeBoxController.targetSlide(_fragmentPoolState.node0Position);
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
            _selectFragmentPool(),
            Expanded(child: FlatButton(onPressed: () {}, child: Text("我"))),
          ],
        ),
      ),
    );
  }

  Widget _selectFragmentPool() {
    return Expanded(
      child: StatefulBuilder(
        builder: (ctx, rebuild) {
          String selectedFragmentPool = "待定池";
          switch (G.fragmentPool.selectedFragmentPool) {
            case SelectedFragmentPool.pendingPool:
              selectedFragmentPool = "待定池";
              break;
            case SelectedFragmentPool.memoryPool:
              selectedFragmentPool = "记忆池";
              break;
            case SelectedFragmentPool.completePool:
              selectedFragmentPool = "完成池";
              break;
            default:
              selectedFragmentPool = "待定池";
          }
          return FlatButton(
            color: Colors.white,
            child: Text(selectedFragmentPool),
            onPressed: () {
              Navigator.push(ctx, FragmentPoolChoice(ctx: ctx, rebuild: rebuild));
            },
          );
        },
      ),
    );
  }
}

class FragmentPoolChoice extends OverlayRoute {
  FragmentPoolChoice({this.ctx, this.rebuild});
  BuildContext ctx;
  Function(Function()) rebuild;

  @override
  Iterable<OverlayEntry> createOverlayEntries() {
    return [
      OverlayEntry(
        builder: (_) {
          Size size = (ctx.findRenderObject() as RenderBox).size;
          return Stack(
            alignment: AlignmentDirectional.center,
            children: [
              Positioned(
                child: Listener(
                  child: Container(
                    color: Colors.black12,
                  ),
                  onPointerUp: (event) {
                    Navigator.removeRoute(_, this);
                  },
                ),
              ),
              Positioned(
                bottom: size.height,
                child: Column(
                  children: [
                    Offstage(
                      offstage: G.fragmentPool.selectedFragmentPool == SelectedFragmentPool.pendingPool ? true : false,
                      child: FlatButton(
                        color: Colors.white,
                        child: Text("待定池"),
                        onPressed: () {
                          G.fragmentPool.selectedFragmentPool = SelectedFragmentPool.pendingPool;
                          rebuild(() {});
                          Navigator.removeRoute(_, this);
                        },
                      ),
                    ),
                    Offstage(
                      offstage: G.fragmentPool.selectedFragmentPool == SelectedFragmentPool.memoryPool ? true : false,
                      child: FlatButton(
                        color: Colors.white,
                        child: Text("记忆池"),
                        onPressed: () {
                          G.fragmentPool.selectedFragmentPool = SelectedFragmentPool.memoryPool;
                          rebuild(() {});
                          Navigator.removeRoute(_, this);
                        },
                      ),
                    ),
                    Offstage(
                      offstage: G.fragmentPool.selectedFragmentPool == SelectedFragmentPool.completePool ? true : false,
                      child: FlatButton(
                        color: Colors.white,
                        child: Text("完成池"),
                        onPressed: () {
                          G.fragmentPool.selectedFragmentPool = SelectedFragmentPool.completePool;
                          rebuild(() {});
                          Navigator.removeRoute(_, this);
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    ];
  }
}
