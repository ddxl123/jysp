import 'package:flutter/material.dart';

class FreeBox extends StatefulWidget {
  FreeBox({
    @required this.children,
    @required this.backgroundColor,
    @required this.boxWidth,
    @required this.boxHeight,
    @required this.eventWidth,
    @required this.eventHeight,
    this.initPosition,
  });
  final List<Widget> children;
  final Color backgroundColor;
  final double boxWidth;
  final double boxHeight;
  final double eventWidth;
  final double eventHeight;
  final Function(Function(Offset) rebuild) initPosition;

  @override
  State<StatefulWidget> createState() {
    return _FreeBox();
  }
}

class _FreeBox extends State<FreeBox> {
  double _scale = 1;
  double _lastScale = 1;

  Offset _offset = Offset(0, 0);
  Offset _lastOffset = Offset(0, 0);

  void rebuild(Offset ip) {
    _offset += ip;
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    widget.initPosition(rebuild);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onScaleStart: (details) {
        _lastScale = 1;
        _lastOffset = details.localFocalPoint;
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
        print(_offset);
        setState(() {});
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
}
