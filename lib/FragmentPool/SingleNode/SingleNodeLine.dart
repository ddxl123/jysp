import 'package:flutter/material.dart';

class SingleNodeLine extends CustomPainter {
  SingleNodeLine() {
    /// 以下皆相对 path
    path = Path();
    return;
  }
  late Path path;
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
