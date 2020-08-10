import 'package:flutter/material.dart';

class SingleNode extends StatefulWidget {
  SingleNode({
    Key key,
    @required this.fragmentPoolDateList,
    @required this.index,
    @required this.fragmentPoolDateMap,
    @required this.fragmentPoolDateMapClone,
    @required this.doChange,
  }) : super(key: key);

  final List<Map<dynamic, dynamic>> fragmentPoolDateList;
  final int index;
  final Map<String, dynamic> fragmentPoolDateMap;
  final Map<String, dynamic> fragmentPoolDateMapClone;
  final Function doChange;

  @override
  SingleNodeState createState() => SingleNodeState();
}

class SingleNodeState extends State<SingleNode> {
  void firstFrame() {
    /// 第一帧开始
    //// 这里的 [widget.fragmentPoolDateMap] 和 [widget.fragmentPoolDateList] 都已经被赋初始值为 {} 和 [] 了
    if (widget.fragmentPoolDateMap[widget.fragmentPoolDateList[widget.index]["route"]] == null) {
      widget.fragmentPoolDateMap[widget.fragmentPoolDateList[widget.index]["route"]] = {
        "index": widget.index,
        "this": this,
        "child_count": 0,
        "layout_height": 0.0,
        "layout_width": 0.0,
        "layout_left": 0.0,
        "layout_top": 0.0,
        "container_height": 0.0,
        "vertical_center_offset": 0.0
      };
    }

    /// 若 [widget.fragmentPoolDateMap] 有新的 [key] 而未赋值，则 [rebuild] 时会获取到为 [null] 的值
    if (widget.fragmentPoolDateMapClone[widget.fragmentPoolDateList[widget.index]["route"]] == null) {
      widget.fragmentPoolDateMapClone[widget.fragmentPoolDateList[widget.index]["route"]] = {
        "child_count": 0,
        "layout_height": 0.0,
        "layout_width": 0.0,
        "layout_left": 0.0,
        "layout_top": 0.0,
        "container_height": 0.0,
      };
    }

    /// 第一帧结束
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      /// 获取 [布局大小]
      Map<dynamic, dynamic> listItem = widget.fragmentPoolDateList[widget.index];
      Size size = (this.context.findRenderObject() as RenderBox).size;
      widget.fragmentPoolDateMap[listItem["route"]]["layout_width"] = size.width;
      widget.fragmentPoolDateMap[listItem["route"]]["layout_height"] = size.height;
      //// 必须重置,因为 [fisrtFrameEndHandle] 中并没有重新获取 [tail] ,若尾部 [layout_height] 发生变化,则会发生错误结果
      widget.fragmentPoolDateMap[listItem["route"]]["container_height"] = size.height;
    });
  }

  @override
  void initState() {
    super.initState();
    firstFrame();
  }

  @override
  void didUpdateWidget(SingleNode oldWidget) {
    super.didUpdateWidget(oldWidget);
    firstFrame();
  }

  String _thisRoute;
  String _thisFatherRoute;
  @override
  Widget build(BuildContext context) {
    _thisRoute = widget.fragmentPoolDateList[widget.index]["route"];
    List<String> spl = _thisRoute.split("-");
    _thisFatherRoute = spl.sublist(0, spl.length - 1).join("-");
    return Positioned(
      left: widget.fragmentPoolDateMapClone[_thisRoute]["layout_left"],
      top: widget.fragmentPoolDateMapClone[_thisRoute]["layout_top"],
      child: CustomPaint(
        painter: SingleNodeLine(
          path: () {
            /// 以下皆相对 path
            Path path = Path();
            if (_thisRoute != "0") {
              path.moveTo(0, widget.fragmentPoolDateMapClone[_thisRoute]["layout_height"] / 2);
              path.lineTo(-40, widget.fragmentPoolDateMapClone[_thisRoute]["layout_height"] / 2);
              double fatherCenterTop = widget.fragmentPoolDateMapClone[_thisFatherRoute]["layout_top"] + (widget.fragmentPoolDateMapClone[_thisFatherRoute]["layout_height"] / 2);
              double thisCenterTop = widget.fragmentPoolDateMapClone[_thisRoute]["layout_top"];

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
              showBottomSheet(
                  context: context,
                  builder: (_) {
                    return Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            FlatButton(
                              onPressed: () {
                                widget.fragmentPoolDateList.add({
                                  "route": () {
                                    int childCount = 0;
                                    for (int i = 0; i < widget.fragmentPoolDateList.length; i++) {
                                      if (widget.fragmentPoolDateMapClone.containsKey(_thisRoute + "-$i")) {
                                        childCount++;
                                      } else {
                                        break;
                                      }
                                    }
                                    return _thisRoute + "-$childCount";
                                  }(),
                                  "type": 1,
                                  "out_display_name": "$_thisRoute,hhhhh",
                                });
                                widget.doChange();
                              },
                              child: Text("添加子级"),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            FlatButton(
                              onPressed: () {},
                              child: Text("添加父级"),
                            ),
                          ],
                        )
                      ],
                    );
                  });
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
    paint.color = Colors.white;
    paint.style = PaintingStyle.stroke;
    paint.strokeWidth = 4.0;
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}