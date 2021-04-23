import 'dart:ui';

import 'package:flutter/material.dart';

abstract class SmallRoute<T> extends OverlayRoute<T> {
  ///

  BuildContext? context;

  Function(Function()) setState = (_) {};

  /// 背景不透明度
  double get backgroundOpacity;

  /// 背景颜色
  Color get backgroundColor;

  /// 是否点击背景 up 时 pop 当前 route
  bool get isUpPop;

  /// body 是否放在屏幕中心
  bool get isBodyCenter;

  @override
  Iterable<OverlayEntry> createOverlayEntries() {
    return <OverlayEntry>[
      OverlayEntry(
        builder: (_) {
          return SmallWidget<T>(this);
        },
      ),
    ];
  }

  ///初始化
  void init();

  /// rebuild
  void rebuild();

  /// body
  List<Positioned> body();

  ///
}

class SmallWidget<T> extends StatefulWidget {
  const SmallWidget(this.smallRoute);
  final SmallRoute<T> smallRoute;

  @override
  _SmallWidgetState<T> createState() => _SmallWidgetState<T>();
}

class _SmallWidgetState<T> extends State<SmallWidget<T>> {
  @override
  void initState() {
    super.initState();
    widget.smallRoute.init();
    widget.smallRoute.context ??= context;
    widget.smallRoute.setState = setState;
  }

  @override
  Widget build(BuildContext context) {
    widget.smallRoute.rebuild();
    return Material(
      type: MaterialType.transparency,
      child: Stack(
        alignment: widget.smallRoute.isBodyCenter ? AlignmentDirectional.center : AlignmentDirectional.topStart,
        children: <Widget>[
          background(),
          ...widget.smallRoute.body(),
        ],
      ),
    );
  }

  /// 背景
  Widget background() {
    return Positioned(
      top: 0,
      width: MediaQueryData.fromWindow(window).size.width,
      height: MediaQueryData.fromWindow(window).size.height,
      child: Listener(
        onPointerUp: (_) {
          if (widget.smallRoute.isUpPop) {
            Navigator.pop(context);
          }
        },
        child: Opacity(
          opacity: widget.smallRoute.backgroundOpacity,
          child: Container(color: widget.smallRoute.backgroundColor),
        ),
      ),
    );
  }
}
