import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:jysp/FragmentPool/FragmentPool.dart';
import 'package:jysp/Tools/FreeBox.dart';
import 'package:jysp/Global/GlobalData.dart';

/// 进入HOME页，获取本地数据→获取云端数据
class HomePage extends StatefulWidget {
  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  FreeBoxController _freeBoxController1 = FreeBoxController();
  FreeBoxController _freeBoxController2 = FreeBoxController();

  @override
  void dispose() {
    _freeBoxController1.dispose();
    _freeBoxController2.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Stack(
        children: [
          FreeBox(
            backgroundColor: Colors.green,
            freeBoxController: _freeBoxController2,
            freeMoveScaleLayerChild: FragmentPool(freeBoxController: _freeBoxController2),
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
          _freeBoxController1.startZeroSliding();
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
            Expanded(child: FlatButton(onPressed: () {}, child: Text("我的"))),
            _selectFragmentPool(),
            Expanded(child: FlatButton(onPressed: () {}, child: Text("发现"))),
          ],
        ),
      ),
    );
  }

  Widget _selectFragmentPool() {
    return Expanded(
      child: StatefulBuilder(
        builder: (ctx, reBuild) {
          String selectedFragmentPool = "待定池";
          switch (GlobalData.instance.selectedFragmentPool) {
            case SelectedFragmentPool.pendingPool:
              selectedFragmentPool = "待定池";
              break;
            case SelectedFragmentPool.memoryPool:
              selectedFragmentPool = "ssss";
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
              Navigator.push(ctx, FragmentPoolChoice(ctx: ctx, reBuild: reBuild));
            },
          );
        },
      ),
    );
  }
}

class FragmentPoolChoice extends OverlayRoute {
  FragmentPoolChoice({this.ctx, this.reBuild});
  BuildContext ctx;
  Function(Function()) reBuild;

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
                      offstage: GlobalData.instance.selectedFragmentPool == SelectedFragmentPool.pendingPool ? true : false,
                      child: FlatButton(
                        color: Colors.white,
                        child: Text("待定池"),
                        onPressed: () {
                          GlobalData.instance.selectedFragmentPool = SelectedFragmentPool.pendingPool;
                          reBuild(() {});
                          Navigator.removeRoute(_, this);
                        },
                      ),
                    ),
                    Offstage(
                      offstage: GlobalData.instance.selectedFragmentPool == SelectedFragmentPool.memoryPool ? true : false,
                      child: FlatButton(
                        color: Colors.white,
                        child: Text("记忆池"),
                        onPressed: () {
                          GlobalData.instance.selectedFragmentPool = SelectedFragmentPool.memoryPool;
                          reBuild(() {});
                          Navigator.removeRoute(_, this);
                        },
                      ),
                    ),
                    Offstage(
                      offstage: GlobalData.instance.selectedFragmentPool == SelectedFragmentPool.completePool ? true : false,
                      child: FlatButton(
                        color: Colors.white,
                        child: Text("完成池"),
                        onPressed: () {
                          GlobalData.instance.selectedFragmentPool = SelectedFragmentPool.completePool;
                          reBuild(() {});
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
