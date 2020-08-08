import 'dart:convert';

import 'package:flutter/material.dart';

class SingleNode extends StatefulWidget {
  SingleNode({
    Key key,
    @required this.fragmentPoolDateList,
    @required this.fragmentPoolDateMap,
    @required this.index,
  }) : super(key: key);

  final List<Map<dynamic, dynamic>> fragmentPoolDateList;
  final Map<String, dynamic> fragmentPoolDateMap;
  final int index;

  @override
  SingleNodeState createState() => SingleNodeState();
}

class SingleNodeState extends State<SingleNode> {
  String _thisRoute;

  /// 获取 [布局大小]
  void reGetLayoutSize() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      Map<dynamic, dynamic> listItem = widget.fragmentPoolDateList[widget.index];
      widget.fragmentPoolDateMap[listItem["route"]]["this"] = this;

      /// 获取 [布局大小]
      Size size = (this.context.findRenderObject() as RenderBox).size;
      widget.fragmentPoolDateMap[listItem["route"]]["layout_width"] = size.width;
      widget.fragmentPoolDateMap[listItem["route"]]["layout_height"] = size.height;
    });
  }

  @override
  void initState() {
    super.initState();
    reGetLayoutSize();
  }

  @override
  void didUpdateWidget(SingleNode oldWidget) {
    super.didUpdateWidget(oldWidget);
    reGetLayoutSize();
  }

  @override
  Widget build(BuildContext context) {
    _thisRoute = widget.fragmentPoolDateList[widget.index]["route"];
    return Positioned(
      left: widget.fragmentPoolDateMap[_thisRoute]["layout_left"] ?? 0.0,
      top: widget.fragmentPoolDateMap[_thisRoute]["layout_top"] ?? 0.0,
      child: CustomPaint(
        painter: SingleNodeLine(
          path: () {
            /// 以下皆相对 path
            Path path = Path();
            if (_thisRoute != "0") {
              path.moveTo(0, widget.fragmentPoolDateMap[_thisRoute]["layout_height"] / 2);
              path.lineTo(-40, widget.fragmentPoolDateMap[_thisRoute]["layout_height"] / 2);
              double fatherCenterTop = widget.fragmentPoolDateMap[_thisRoute.substring(0, _thisRoute.length - 2)]["layout_top"] +
                  (widget.fragmentPoolDateMap[_thisRoute.substring(0, _thisRoute.length - 2)]["layout_height"] / 2);
              double thisCenterTop = widget.fragmentPoolDateMap[_thisRoute]["layout_top"];

              path.lineTo(-40, fatherCenterTop - thisCenterTop);
              path.lineTo(-80, fatherCenterTop - thisCenterTop);
            }
            return path;
          }(),
        ),
        child: Container(
          color: Colors.yellow,
          child: FlatButton(
            onPressed: () {
              setState(() {});
            },
            child: Text(widget.fragmentPoolDateList[widget.index]["out_display_name"]),
          ),
        ),
      ),
    );
  }
}

class SingleNodeLine extends CustomPainter {
  SingleNodeLine({@required this.path});
  final Path path;
  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint();
    paint.color = Colors.blue;
    paint.style = PaintingStyle.stroke;
    paint.strokeWidth = 4.0;
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
