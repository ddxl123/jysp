import 'package:flutter/material.dart';
import 'package:jysp/LWCR/Controller/FreeBoxController.dart';
import 'package:jysp/LWCR/WidgetBuild/FreeBoxWB.dart';

class FreeBox extends StatefulWidget {
  FreeBox({
    this.freeBoxController,
    this.freeMoveScaleLayerChild = const SizedBox(),
    this.fixedLayerChild = const SizedBox(),
  });
  final FreeBoxController freeBoxController;

  /// 自由缩放层。可使用任意 Widget
  final Widget freeMoveScaleLayerChild;

  /// 固定层。可使用任意 Widget
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
  Widget build(BuildContext context) => FreeBoxWB(widget);
}
