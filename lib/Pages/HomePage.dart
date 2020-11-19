import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:jysp/FragmentPool/FragmentPool.dart';
import 'package:jysp/FragmentPool/FreeBox.dart';
import 'package:jysp/Global/GlobalData.dart';

class HomePage extends StatefulWidget {
  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  FreeBoxController _freeBoxController = FreeBoxController();

  @override
  void dispose() {
    _freeBoxController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Stack(
        children: <Widget>[
          _freeBoxWidget(),
          _toZeroWidget(),
          _bottomWidget(),
        ],
      ),
    );
  }

  Widget _freeBoxWidget() {
    return Positioned(
      top: 0,
      child: FreeBox(
        boxWidth: 100,
        boxHeight: 100,
        eventWidth: 100,
        eventHeight: 100,
        backgroundColor: Colors.green,
        freeBoxController: _freeBoxController,
        child: FragmentPool(freeBoxController: _freeBoxController),
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
          _freeBoxController.startZeroSliding();
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
