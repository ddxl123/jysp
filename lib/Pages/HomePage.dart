import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:jysp/FragmentPool/FragmentPool.dart';
import 'package:jysp/FragmentPool/FragmentPoolController.dart';
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
            Expanded(
                child: FlatButton(
                    onPressed: () {
                      _fragmentPoolController.refreshLayout();
                    },
                    child: Text("发现"))),
            _selectFragmentPool(),
            Expanded(
                child: FlatButton(
                    onPressed: () {
                      _fragmentPoolController.fragmentPoolNodes.removeLast();
                    },
                    child: Text("我"))),
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
          switch (_fragmentPoolController.fragmentPoolSelectedType) {
            case FragmentPoolSelectedType.pendingPool:
              selectedFragmentPool = "待定池";
              break;
            case FragmentPoolSelectedType.memoryPool:
              selectedFragmentPool = "记忆池";
              break;
            case FragmentPoolSelectedType.completePool:
              selectedFragmentPool = "完成池";
              break;
            default:
              selectedFragmentPool = "待定池";
          }
          return FlatButton(
            color: Colors.white,
            child: Text(selectedFragmentPool),
            onPressed: () {
              Navigator.push(ctx, FragmentPoolChoice(ctx: ctx, rebuild: rebuild, fragmentPoolController: _fragmentPoolController));
            },
          );
        },
      ),
    );
  }
}

class FragmentPoolChoice extends OverlayRoute {
  FragmentPoolChoice({@required this.ctx, @required this.rebuild, @required this.fragmentPoolController});
  BuildContext ctx;
  Function(Function()) rebuild;
  FragmentPoolController fragmentPoolController;

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
                      offstage: fragmentPoolController.fragmentPoolSelectedType == FragmentPoolSelectedType.pendingPool ? true : false,
                      child: FlatButton(
                        color: Colors.white,
                        child: Text("待定池"),
                        onPressed: () {
                          fragmentPoolController.fragmentPoolSelectedType = FragmentPoolSelectedType.pendingPool;
                          rebuild(() {});
                          Navigator.removeRoute(_, this);
                        },
                      ),
                    ),
                    Offstage(
                      offstage: fragmentPoolController.fragmentPoolSelectedType == FragmentPoolSelectedType.memoryPool ? true : false,
                      child: FlatButton(
                        color: Colors.white,
                        child: Text("记忆池"),
                        onPressed: () {
                          fragmentPoolController.fragmentPoolSelectedType = FragmentPoolSelectedType.memoryPool;
                          rebuild(() {});
                          Navigator.removeRoute(_, this);
                        },
                      ),
                    ),
                    Offstage(
                      offstage: fragmentPoolController.fragmentPoolSelectedType == FragmentPoolSelectedType.completePool ? true : false,
                      child: FlatButton(
                        color: Colors.white,
                        child: Text("完成池"),
                        onPressed: () {
                          fragmentPoolController.fragmentPoolSelectedType = FragmentPoolSelectedType.completePool;
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
