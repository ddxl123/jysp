import 'package:flutter/material.dart';
import 'package:jysp/FragmentPool/Nodes/BaseNodes/IfNode.dart';
import 'package:jysp/Global/GlobalData.dart';

class MainSingleNode extends StatefulWidget {
  MainSingleNode({
    Key key,
    @required this.index,
    @required this.thisRouteName,
    @required this.nodeLayoutMap,
    @required this.nodeLayoutMapTemp,
    @required this.isResetingLayout,
    @required this.isResetingLayoutProperty,
    @required this.reLayoutHandle,
  }) : super(key: key);

  final int index;
  final String thisRouteName;
  final Map nodeLayoutMap;
  final Map nodeLayoutMapTemp;
  final bool Function(bool) isResetingLayout;
  final bool Function(bool) isResetingLayoutProperty;
  final Function reLayoutHandle;

  @override
  MainSingleNodeState createState() => MainSingleNodeState();
}

class MainSingleNodeState extends State<MainSingleNode> {
  /// 因为每次新增的 [Node] 是不会被调用 [didUpdateWidget] 的,即无法 [reSetLayout] 对其进行初始化布局属性
  /// 因此需在每个 [Node] 中进行 [initState] 并调用 [reSetLayout] 进行初始化布局属性
  @override
  void initState() {
    super.initState();
    resetLayoutProperty();
    widget.nodeLayoutMap[widget.thisRouteName] = _defaultLayoutPropertyMap(size: null);
  }

  @override
  void didUpdateWidget(MainSingleNode oldWidget) {
    super.didUpdateWidget(oldWidget);

    /// 只有当第一帧刚开始被 [rebuild] 时，才调用 [resetLayoutProperty]
    widget.isResetingLayoutProperty(null) ? resetLayoutProperty() : () {}();
  }

  /// 第一帧开始及完成：重置布局属性
  void resetLayoutProperty() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      Size size = (this.context.findRenderObject() as RenderBox).size;

      /// 给 [nodeLayoutMapTemp] 添加 [Node] ,并重置 [nodeLayoutMapTemp],在这之前 [nodeLayoutMapTemp] 已被 [clear] 过了。
      widget.nodeLayoutMapTemp[widget.thisRouteName] = _defaultLayoutPropertyMap(size: size);

      /// 若全部的 [Node] 都被重置完成。
      if (widget.index == GlobalData.instance.userSelfInitFragmentPoolNodes.length - 1) {
        widget.reLayoutHandle();
        widget.isResetingLayoutProperty(false);
        resetLayoutDone();
      }
    });
  }

  /// 第二帧开始及完成：重置布局完成
  void resetLayoutDone() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      /// 若全部的 [Node] 都被 [rebuild] 完成
      if (widget.index == GlobalData.instance.userSelfInitFragmentPoolNodes.length - 1) {
        widget.isResetingLayout(false);
      }
    });
  }

  /// 默认布局数据
  Map<dynamic, dynamic> _defaultLayoutPropertyMap({Size size}) {
    return {
      "child_count": 0,
      "father_route": "0",
      "layout_width": size == null ? 10 : size.width, // 不设置它为0是为了防止出现bug观察不出来
      "layout_height": size == null ? 10 : size.height,
      "layout_left": -10000.0,
      "layout_top": -10000.0,
      "container_height": size == null ? 10 : size.height,
      "vertical_center_offset": 0.0
    };
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: widget.nodeLayoutMap[widget.thisRouteName]["layout_left"],
      top: widget.nodeLayoutMap[widget.thisRouteName]["layout_top"],
      child: CustomPaint(
          painter: SingleNodeLine(
            path: () {
              /// 以下皆相对 path
              Path path = Path();
              if (widget.thisRouteName != "0") {
                path.moveTo(0, widget.nodeLayoutMap[widget.thisRouteName]["layout_height"] / 2);
                path.lineTo(-40, widget.nodeLayoutMap[widget.thisRouteName]["layout_height"] / 2);
                double fatherCenterTop = widget.nodeLayoutMap[widget.nodeLayoutMap[widget.thisRouteName]["father_route"]]["layout_top"] +
                    widget.nodeLayoutMap[widget.nodeLayoutMap[widget.thisRouteName]["father_route"]]["layout_height"] / 2;
                double thisCenterTop = widget.nodeLayoutMap[widget.thisRouteName]["layout_top"];

                path.lineTo(-40, fatherCenterTop - thisCenterTop);
                path.lineTo(-80, fatherCenterTop - thisCenterTop);
              }
              return path;
            }(),
          ),
          child: IfNode(widget.index, widget.thisRouteName, widget.nodeLayoutMap[widget.thisRouteName]["child_count"])),
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
