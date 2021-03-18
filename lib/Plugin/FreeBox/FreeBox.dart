import 'package:flutter/material.dart';
import 'package:jysp/Plugin/FreeBox/FreeBoxController.dart';
import 'package:jysp/Tools/TDebug.dart';
import 'package:provider/provider.dart';

class FreeBox extends StatefulWidget {
  FreeBox({
    required this.backgroundColor,
    required this.viewableWidth,
    required this.viewableHeight,
    required this.freeMoveScaleLayerBuilder,
    required this.fixedLayerBuilder,
  });

  /// 背景颜色
  final Color backgroundColor;

  /// 视口宽度
  final double viewableWidth;

  /// 视口高度
  final double viewableHeight;

  /// 自由缩放层。可使用任意 Widget。freeMoveScaleLayerBuilder(BuildContext freeBoxProxyContext)
  ///
  /// **注意**：必须使用 Positioned()，且 top 和 left 必须填充 [leftTopOffsetFilling]，否则看不见且不会报异常
  final Widget Function(BuildContext freeBoxProxyContext) freeMoveScaleLayerBuilder;

  /// 固定层。可使用任意 Widget。freeMoveScaleLayerBuilder(BuildContext freeBoxProxyContext)
  final Widget Function(BuildContext freeBoxProxyContext) fixedLayerBuilder;

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
    context.read<FreeBoxController>().inertialSlideAnimationController = AnimationController(vsync: this);
    context.read<FreeBoxController>().targetSlideAnimationController = AnimationController(vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    dLog(() => "FreeBox build");
    return _box();
  }

  Widget _box() {
    return Container(
      alignment: Alignment.center,
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
      // [内容物区] 的左上角是依据该 Positioned 的左上角，因此需设它偏移
      top: -context.read<FreeBoxController>().leftTopOffsetFilling.dx,
      left: -context.read<FreeBoxController>().leftTopOffsetFilling.dy,

      width: double.maxFinite,
      height: double.maxFinite,

      child: GestureDetector(
        behavior: HitTestBehavior.translucent, // 让透明部分也能触发事件
        onScaleStart: context.read<FreeBoxController>().onScaleStart,
        onScaleUpdate: context.read<FreeBoxController>().onScaleUpdate,
        onScaleEnd: context.read<FreeBoxController>().onScaleEnd,
        child: Transform.translate(
          offset: context.select<FreeBoxController, Offset>((value) => value.offset),
          child: Transform.scale(
            alignment: Alignment.topLeft,
            scale: context.select<FreeBoxController, double>((value) => value.scale),

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
