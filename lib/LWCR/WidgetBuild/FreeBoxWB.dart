import 'package:flutter/material.dart';
import 'package:jysp/LWCR/LifeCycle/FreeBoxLC.dart';
import 'package:jysp/LWCR/WidgetBuild/WidgetBuildBase.dart';

class FreeBoxWB extends WidgetBuildBase<FreeBoxLC> {
  FreeBoxWB(FreeBoxLC widget) : super(widget);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: widget.freeBoxController.backgroundColor, //可视区域背景颜色
      /// [FreeBox可视区域] 宽高
      width: widget.freeBoxController.viewableWidth,
      height: widget.freeBoxController.viewableHeight,
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
