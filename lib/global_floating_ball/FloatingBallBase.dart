import 'package:flutter/material.dart';
import 'package:jysp/tools/CustomButton.dart';
import 'package:jysp/tools/toast/ToastRoute.dart';

abstract class FloatingBallBase {
  FloatingBallBase() {
    _position = initPosition;
    _firstRoutes = firstRoutes;

    overlayEntry = OverlayEntry(
      maintainState: true,
      builder: (BuildContext floatingBallContext) {
        return Positioned(
          top: _position.dy,
          left: _position.dx,
          child: Listener(
            onPointerMove: (PointerMoveEvent pointerMoveEvent) {
              _position += pointerMoveEvent.delta;
              overlayEntry.markNeedsBuild();
            },
            child: CustomButton(
              backgroundColor: Colors.transparent,
              downBackgroundColor: Colors.transparent,
              onUp: (PointerUpEvent pointerUpEvent) {
                Navigator.push(floatingBallContext, _firstRoutes(floatingBallContext));
              },
              child: Material(
                type: MaterialType.transparency,
                child: Container(
                  width: radius,
                  height: radius,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(100),
                    color: Colors.red,
                  ),
                  child: Text(floatingBallName),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  late final OverlayEntry overlayEntry;

  /// 悬浮球的名称
  String get floatingBallName;

  /// 悬浮球的当前位置
  late Offset _position;

  /// 悬浮球的初始化位置
  Offset get initPosition;

  /// 悬浮球的半径
  double get radius;

  /// home route
  late ToastRoute Function(BuildContext floatingBallContext) _firstRoutes;

  /// 只会被调用一次，即转交给 _route。
  ToastRoute firstRoutes(BuildContext floatingBallContext);
}
