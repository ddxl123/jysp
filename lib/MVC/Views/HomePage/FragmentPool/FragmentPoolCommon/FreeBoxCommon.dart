import 'package:flutter/material.dart';
import 'package:jysp/MVC/Controllers/HomePageController.dart';
import 'package:jysp/Tools/FreeBox/FreeBox.dart';
import 'package:provider/provider.dart';

class FreeBoxCommon extends StatefulWidget {
  const FreeBoxCommon({required this.poolNodesCommon, required this.onLongPressStart});
  final Widget poolNodesCommon;
  final void Function(ScaleStartDetails) onLongPressStart;

  @override
  _FreeBoxCommonState createState() => _FreeBoxCommonState();
}

class _FreeBoxCommonState extends State<FreeBoxCommon> {
  @override
  Widget build(BuildContext context) {
    return FreeBox(
      freeBoxController: context.read<HomePageController>().getCurrentFragmentPoolController().freeBoxController,
      backgroundColor: Colors.green,
      viewableWidth: double.maxFinite,
      viewableHeight: double.maxFinite,
      freeMoveScaleLayerBuilder: (_) => widget.poolNodesCommon,
      fixedLayerBuilder: (_) => Stack(
        children: <Widget>[
          _toZeroButton(),
        ],
      ),
      onLongPressStart: (ScaleStartDetails details) {
        widget.onLongPressStart(details);
      },
    );
  }

  /// 将镜头移至Zero的按钮
  Widget _toZeroButton() {
    return Positioned(
      bottom: 50,
      left: 0,
      child: TextButton(
        onPressed: () {
          context.read<HomePageController>().getCurrentFragmentPoolController().freeBoxController.targetSlide(targetOffset: Offset.zero, targetScale: 1.0);
        },
        child: const Icon(Icons.adjust),
      ),
    );
  }
}
