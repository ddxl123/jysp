import 'package:flutter/material.dart';
import 'package:jysp/Tools/FreeBox/FreeBoxController.dart';
import 'package:jysp/Tools/TDebug.dart';

class FreeBox extends StatefulWidget {
  const FreeBox({
    required this.freeBoxController,
    required this.backgroundColor,
    required this.viewableWidth,
    required this.viewableHeight,
    required this.freeMoveScaleLayerBuilder,
    required this.fixedLayerBuilder,
    this.onLongPressStart,
  });

  /// 控制器
  final FreeBoxController freeBoxController;

  /// 背景颜色
  final Color backgroundColor;

  /// 视口宽度
  final double? viewableWidth;

  /// 视口高度
  final double? viewableHeight;

  /// 自由缩放层。必须使用 Stack + Postion。但要注意 Postion 的 top/left 为 0 时，本非按照父容器的顶部/左部，而是按照屏幕的顶部/左部。原因是【内容物】的大小是无限大的。
  final Widget Function(BuildContext freeBoxProxyContext) freeMoveScaleLayerBuilder;

  /// 固定层。必须使用 Stack + Postion。
  final Widget Function(BuildContext freeBoxProxyContext) fixedLayerBuilder;

  final Function(ScaleStartDetails)? onLongPressStart;

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

  void initSliding() {
    widget.freeBoxController.inertialSlideAnimationController = AnimationController(vsync: this);
    widget.freeBoxController.targetSlideAnimationController = AnimationController(vsync: this);
    widget.freeBoxController.onLongPressStart = widget.onLongPressStart;
    widget.freeBoxController.addListener(() {
      setState(() {});
      dLog(() => 'aaaa');
    });
  }

  @override
  void dispose() {
    widget.freeBoxController.inertialSlideAnimationController.dispose();
    widget.freeBoxController.targetSlideAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // dLog(() => "FreeBox build");
    return _box();
  }

  Widget _box() {
    return Container(
      alignment: Alignment.center,
      width: widget.viewableWidth,
      height: widget.viewableHeight,
      child: Container(
        alignment: Alignment.center,
        color: widget.backgroundColor, //可视区域背景颜色
        /// [FreeBox可视区域] 宽高
        child: Stack(
          children: <Widget>[
            /// 自由移动缩放层
            _freeMoveScaleLayer(),
            _fixedLayer(),
          ],
        ),
      ),
    );
  }

  Widget _freeMoveScaleLayer() {
    return Positioned(
      // [内容物区] 的左上角是依据该 Positioned 的左上角，因此需设它偏移
      // top: - context.read<FragmentPoolController>().freeBoxController.leftTopOffsetFilling.dx,
      // left: - context.read<FragmentPoolController>().freeBoxController.leftTopOffsetFilling.dy,

      width: double.maxFinite,
      height: double.maxFinite,

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

            // [内容物区]。要比 [FreeBox可视区域] 宽高大，必须无限大，因为若可视区域很大，但可触发区域却很小，会把溢出部分切除，虽然仍可视，但不可触发Transform。
            child: widget.freeMoveScaleLayerBuilder(context),
          ),
        ),
      ),
    );
  }

  Widget _fixedLayer() {
    return Positioned(child: widget.fixedLayerBuilder(context));
  }
}
