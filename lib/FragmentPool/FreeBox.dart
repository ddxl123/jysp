import 'package:flutter/material.dart';

class FreeBox extends StatefulWidget {
  FreeBox({
    @required this.children,
    @required this.backgroundColor,
    this.boxWidth = double.maxFinite,
    this.boxHeight = double.maxFinite,
    this.eventWidth = double.maxFinite,
    this.eventHeight = double.maxFinite,
    this.freeBoxController,
  });
  final List<Widget> children;
  final Color backgroundColor;
  final double boxWidth;
  final double boxHeight;
  final double eventWidth;
  final double eventHeight;
  FreeBoxController freeBoxController;

  @override
  State<StatefulWidget> createState() {
    freeBoxController = freeBoxController ?? FreeBoxController();
    return _FreeBox();
  }
}

class _FreeBox extends State<FreeBox> {
  double _scale = 1;
  double _lastScale = 1;
  Offset _offset = Offset(0, 0);
  Offset _lastOffset = Offset(0, 0);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onScaleStart: (details) {
        _lastScale = 1;
        _lastOffset = details.localFocalPoint;
        onScaleStartOther();
      },
      onScaleUpdate: (details) {
        double deltaScale = details.scale - _lastScale;
        _scale *= 1 + deltaScale;
        _lastScale = details.scale;

        Offset pivotDeltaOffset = (_offset - details.localFocalPoint) * deltaScale;
        _offset += pivotDeltaOffset;

        Offset deltaOffset = details.localFocalPoint - _lastOffset;
        _offset += deltaOffset;
        _lastOffset = details.localFocalPoint;

        onScaleUpdateOther();
        setState(() {});
      },
      onScaleEnd: (details) {
        onScaleEndOther();
      },
      child: Container(
        alignment: Alignment.center,
        color: widget.backgroundColor,
        //视觉区域、触摸区域
        width: widget.boxWidth,
        height: widget.boxHeight,
        child: Stack(
          children: <Widget>[
            Positioned(
              //内部事件区域
              width: widget.eventWidth,
              height: widget.eventHeight,
              child: Transform.translate(
                offset: _offset,
                child: Transform.scale(
                  alignment: Alignment.topLeft,
                  scale: _scale,
                  child: Stack(
                    children: widget.children,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void onScaleStartOther() {
    widget.freeBoxController.onScaleStartEventBindOnce.forEach((key, value) {
      value();
    });
    widget.freeBoxController.onScaleStartEventBindOnce.clear();
  }

  void onScaleUpdateOther() {
    widget.freeBoxController.onScaleUpdateEventBindOnce.forEach((key, value) {
      value();
    });
    widget.freeBoxController.onScaleUpdateEventBindOnce.clear();
  }

  void onScaleEndOther() {
    widget.freeBoxController.onScaleEndEventBindOnce.forEach((key, value) {
      value();
    });
    widget.freeBoxController.onScaleEndEventBindOnce.clear();
  }

  @override
  void initState() {
    super.initState();
    widget.freeBoxController.moveTo = this.moveTo;
  }

  /// [*scale] 是为了获取被缩放后的实际位置
  void moveTo(Offset choicePosition, Offset toMediaPosition) {
    _offset = choicePosition * _scale + toMediaPosition;
    print(_offset.toString() + ":" + _scale.toString());
    setState(() {});
  }
}

class FreeBoxController {
  Function(Offset position, Offset mediaCenter) moveTo;

  Map<String, Function> onScaleStartEventBindOnce = {};
  Map<String, Function> onScaleUpdateEventBindOnce = {};
  Map<String, Function> onScaleEndEventBindOnce = {};
  void eventBindOnce({String startBindKey, Function startBindOnce, String updateBindKey, Function updateBindOnce, String endBindKey, Function endBindOnce}) {
    if (startBindOnce != null) {
      onScaleStartEventBindOnce[startBindKey ?? startBindOnce.hashCode.toString()] = startBindOnce;
    }
    if (updateBindOnce != null) {
      onScaleUpdateEventBindOnce[updateBindKey ?? updateBindOnce.hashCode.toString()] = updateBindOnce;
    }
    if (endBindOnce != null) {
      onScaleEndEventBindOnce[endBindKey ?? endBindOnce.hashCode.toString()] = endBindOnce;
    }
  }
}
