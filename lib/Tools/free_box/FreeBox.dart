import 'package:flutter/material.dart';
import 'package:jysp/tools/CustomButton.dart';
import 'package:jysp/tools/Helper.dart';
import 'package:jysp/tools/TDebug.dart';
import 'package:jysp/tools/free_box/FreeBoxController.dart';

/// [boxWidth]：不能为 [double.infinity] 或 [double.maxFinite]
class FreeBox extends StatefulWidget {
  const FreeBox({
    required this.freeBoxController,
    this.boxBodyBackgroundColor = Colors.green,
    this.boxOutsideBackgroundColor = Colors.red,
    required this.boxWidth,
    required this.boxHeight,
    required this.freeMoveScaleLayerBuilder,
    required this.fixedLayerBuilder,
    this.onLongPressStart,
  }) : assert(boxWidth != double.maxFinite && boxHeight != double.maxFinite);

  /// 控制器
  final FreeBoxController freeBoxController;

  /// 整体内容物的背景颜色
  final Color boxBodyBackgroundColor;

  /// 内容物外的背景颜色
  final Color boxOutsideBackgroundColor;

  /// 视口宽度
  final double boxWidth;

  /// 视口高度
  final double boxHeight;

  /// 自由缩放层。必须使用 Stack + freeBoxPositioned()。
  final FreeBoxStack freeMoveScaleLayerBuilder;

  /// 固定层。必须使用 Stack + Postion。
  final Stack Function(SetState flbSetState) fixedLayerBuilder;

  final void Function(PointerDownEvent event)? onLongPressStart;

  @override
  State<StatefulWidget> createState() {
    return _FreeBox();
  }
}

class _FreeBox extends State<FreeBox> with TickerProviderStateMixin {
  ///

  @override
  void initState() {
    super.initState();

    initSliding();
  }

  @override
  void dispose() {
    widget.freeBoxController.inertialSlideAnimationController.dispose();
    widget.freeBoxController.targetSlideAnimationController.dispose();
    super.dispose();
  }

  void initSliding() {
    dLog(() => 'aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa');
    widget.freeBoxController.inertialSlideAnimationController = AnimationController(vsync: this);
    widget.freeBoxController.targetSlideAnimationController = AnimationController(vsync: this);
    // widget.freeBoxController.onLongPressStart = widget.onLongPressStart;
    widget.freeBoxController.freeBoxSetState ??= setState;
    widget.freeBoxController.targetSlide(targetOffset: Offset.zero, targetScale: 1.0, rightnow: true);
  }

  @override
  Widget build(BuildContext context) {
    return _box();
  }

  Widget _box() {
    return CustomButton(
      isAlwaysOnDown: false,
      isAlwaysOnUp: true,
      isAlwaysOnLongPressed: false,
      onDown: (PointerDownEvent downEvent) {
        dLog(() => 'box downEvent:$downEvent');
      },
      onLongPressed: widget.onLongPressStart,
      child: Container(
        alignment: Alignment.topLeft,
        // 整个 box 的大小
        width: widget.boxWidth,
        height: widget.boxHeight,
        color: widget.boxOutsideBackgroundColor, //整个 box 的背景颜色
        child: Stack(
          children: <Positioned>[
            /// 自由移动缩放层
            _freeMoveScaleLayer(),
            _fixedLayer(),
          ],
        ),
      ),
    );
  }

  Positioned _freeMoveScaleLayer() {
    return Positioned(
      // [内容物区] 的左上角是依据该 Positioned 的左上角，因此需设它偏移
      // top: - context.read<FragmentPoolController>().freeBoxController.leftTopOffsetFilling.dx,
      // left: - context.read<FragmentPoolController>().freeBoxController.leftTopOffsetFilling.dy,
      top: 0,
      child: Container(
        // 自由缩放触发区从 box 的左上角开始
        alignment: Alignment.topLeft,
        // 可触发自由缩放的区域的大小。若比 box 小，则内容物会溢出显示但无法触发；若比 box 大，则会收容内容物。
        // 若内容物位置处于该大小区域外，则该内容物会消失。
        width: widget.boxWidth + 1000000,
        height: widget.boxHeight + 1000000,
        // 因为触发区始终比整个 box 大，因此颜色会覆盖掉 box 的背景颜色
        color: widget.boxOutsideBackgroundColor,
        child: GestureDetector(
          behavior: HitTestBehavior.translucent, // 让透明部分也能触发事件
          onScaleStart: widget.freeBoxController.onScaleStart,
          onScaleUpdate: widget.freeBoxController.onScaleUpdate,
          onScaleEnd: widget.freeBoxController.onScaleEnd,
          child: Transform.translate(
            offset: widget.freeBoxController.offset,
            child: Transform.scale(
              alignment: Alignment.topLeft,
              scale: widget.freeBoxController.scale,
              // [内容物s]
              child: StatefulBuilder(
                builder: (BuildContext context, SetState nrwSetState) {
                  return Container(
                    color: widget.boxBodyBackgroundColor,
                    child: widget.freeMoveScaleLayerBuilder,
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }

  Positioned _fixedLayer() {
    return Positioned(
      top: 0,
      width: widget.boxWidth,
      height: widget.boxHeight,
      child: StatefulBuilder(
        builder: (BuildContext context, SetState flSetState) {
          return widget.fixedLayerBuilder(flSetState);
        },
      ),
    );
  }
}
