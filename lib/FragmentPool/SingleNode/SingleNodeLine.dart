import 'package:flutter/material.dart';
import 'package:jysp/FragmentPool/SingleNode/SingleNode.dart';

class SingleNodeLine extends CustomPainter {
  late Path path;
  SingleNodeLine(SingleNode widget) {
    /// 以下皆相对 path
    this.path = Path();
    return;
  }
  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint();
    paint.color = Colors.white;
    paint.style = PaintingStyle.stroke;
    paint.strokeWidth = 4.0;
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
