import 'package:flutter/material.dart';
import 'package:jysp/FragmentPool/SingleNode/SingleNode.dart';

class SingleNodeLine extends CustomPainter {
  Path path;
  SingleNodeLine(SingleNode widget) {
    /// 以下皆相对 path
    this.path = Path();
    if (widget.thisBranchName != "0") {
      path.moveTo(0, widget.fragmentPoolController.nodeLayoutMap[widget.thisBranchName]["layout_height"] / 2);
      path.lineTo(-40, widget.fragmentPoolController.nodeLayoutMap[widget.thisBranchName]["layout_height"] / 2);
      double fatherCenterTop = widget.fragmentPoolController.nodeLayoutMap[widget.fragmentPoolController.nodeLayoutMap[widget.thisBranchName]["father_branch"]]["layout_top"] +
          widget.fragmentPoolController.nodeLayoutMap[widget.fragmentPoolController.nodeLayoutMap[widget.thisBranchName]["father_branch"]]["layout_height"] / 2;
      double thisCenterTop = widget.fragmentPoolController.nodeLayoutMap[widget.thisBranchName]["layout_top"];

      path.lineTo(-40, fatherCenterTop - thisCenterTop);
      path.lineTo(-80, fatherCenterTop - thisCenterTop);
    }
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
