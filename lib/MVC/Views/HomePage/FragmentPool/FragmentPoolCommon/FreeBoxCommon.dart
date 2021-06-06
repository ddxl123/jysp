import 'package:flutter/material.dart';
import 'package:jysp/MVC/Controllers/FragmentPoolController/FragmentPoolController.dart';
import 'package:jysp/MVC/Controllers/HomePageController.dart';
import 'package:jysp/Tools/FreeBox/FreeBox.dart';
import 'package:jysp/Tools/FreeBox/FreeBoxController.dart';
import 'package:jysp/Tools/Helper.dart';
import 'package:provider/provider.dart';

class FreeBoxCommon extends StatefulWidget {
  const FreeBoxCommon({required this.poolType, required this.poolNodesCommon, required this.onLongPressStart});
  final PoolType poolType;
  final FreeBoxStack poolNodesCommon;
  final void Function(PointerDownEvent event) onLongPressStart;

  @override
  _FreeBoxCommonState createState() => _FreeBoxCommonState();
}

class _FreeBoxCommonState extends State<FreeBoxCommon> {
  late FragmentPoolController _fragmentPoolController;

  @override
  void initState() {
    super.initState();
    _fragmentPoolController = context.read<HomePageController>().getFragmentPoolController(widget.poolType);
  }

  @override
  Widget build(BuildContext context) {
    return FreeBox(
      freeBoxController: _fragmentPoolController.freeBoxController,
      boxWidth: MediaQuery.of(context).size.width,
      boxHeight: MediaQuery.of(context).size.height,
      onLongPressStart: (PointerDownEvent event) {
        widget.onLongPressStart(event);
      },
      freeMoveScaleLayerBuilder: widget.poolNodesCommon,
      fixedLayerBuilder: (SetState setState) {
        return Stack(
          children: <Positioned>[
            _toZeroButton(),
          ],
        );
      },
    );
  }

  /// 将镜头移至Zero的按钮
  Positioned _toZeroButton() {
    return Positioned(
      bottom: 50,
      left: 0,
      child: TextButton(
        onPressed: () {
          _fragmentPoolController.freeBoxController.targetSlide(targetOffset: Offset.zero, targetScale: 1.0, rightnow: false);
        },
        child: const Icon(Icons.adjust),
      ),
    );
  }
}
