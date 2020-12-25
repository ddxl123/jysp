import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:jysp/FreeBox/FreeBoxController.dart';

class FreeBox extends StatefulWidget {
  FreeBox({
    @required this.backgroundColor,
    this.viewableWidth = double.maxFinite,
    this.viewableHeight = double.maxFinite,
    this.freeBoxController,
    this.freeMoveScaleLayerChild = const SizedBox(),
    this.fixedLayerChild = const SizedBox(),
  });
  final Color backgroundColor;
  final double viewableWidth;
  final double viewableHeight;
  final FreeBoxController freeBoxController;

  /// 可使用任意 Widget
  final Widget freeMoveScaleLayerChild;

  /// 可使用任意 Widget
  final Widget fixedLayerChild;

  @override
  State<StatefulWidget> createState() {
    return _FreeBox();
  }
}

class _FreeBox extends State<FreeBox> with TickerProviderStateMixin {
  @override
  void initState() {
    super.initState();

    initInertialSliding();
  }

  void initInertialSliding() {
    widget.freeBoxController.inertialSlideAnimationController = AnimationController(vsync: this);
    widget.freeBoxController.targetSlideAnimationController = AnimationController(vsync: this);
    widget.freeBoxController.addListener(() {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: widget.backgroundColor, //可视区域背景颜色
      /// [FreeBox可视区域] 宽高
      width: widget.viewableWidth,
      height: widget.viewableHeight,
      child: Stack(
        children: [
          /// 自由移动缩放层
          _freeMoveScaleLayer(),
          _fixedLayer(),
        ],
      ),
    );
  }

  Widget _freeMoveScaleLayer() {
    return Positioned(
      top: 0,

      /// [内容物可视区域]。要比FreeBox可视区域宽高大，不然溢出可视了。但不能只大一点，必须无限大，因为若内容物很大，但内容物可视区域却很小，会把溢出部分切除。
      width: double.maxFinite,
      height: double.maxFinite,
      child: GestureDetector(
        behavior: HitTestBehavior.translucent, //让透明背景也可以触发手势事件
        onScaleStart: widget.freeBoxController.onScaleStart,
        onScaleUpdate: widget.freeBoxController.onScaleUpdate,
        onScaleEnd: widget.freeBoxController.onScaleEnd,
        child: Transform.translate(
          offset: widget.freeBoxController.offset,
          child: Transform.scale(
            alignment: Alignment.topLeft,
            scale: widget.freeBoxController.scale,
            child: widget.freeMoveScaleLayerChild,
          ),
        ),
      ),
    );
  }

  Widget _fixedLayer() {
    return Positioned(child: widget.fixedLayerChild);
  }
}
