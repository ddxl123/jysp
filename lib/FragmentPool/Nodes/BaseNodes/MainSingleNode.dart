import 'package:flutter/material.dart';
import 'package:jysp/FragmentPool/FragmentPoolController.dart';
import 'package:jysp/FragmentPool/FragmentPoolEnum.dart';

class MainSingleNode extends StatefulWidget {
  MainSingleNode({
    Key key,
    @required this.index,
    @required this.thisRouteName,
    @required this.fragmentPoolController,
  }) : super(key: key);

  final int index;
  final String thisRouteName;
  final FragmentPoolController fragmentPoolController;

  @override
  MainSingleNodeState createState() => MainSingleNodeState();
}

class MainSingleNodeState extends State<MainSingleNode> {
  ///

  /// 获取每个 node 的宽高
  void _getLayout() {
    if (widget.fragmentPoolController.fragmentPoolRefreshStatus == FragmentPoolRefreshStatus.getLayout) {
      /// 防止被执行多次, 这里不能写这行, 否则第一个 node 就被禁止了, 应该在 end 里写
      // widget.fragmentPoolController.fragmentPoolRefreshStatus = FragmentPoolRefreshStatus.willSetLayout;

      /// 当前帧被 [build] 完成后调用
      WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
        Size size = (this.context.findRenderObject() as RenderBox).size;

        /// 给 [nodeLayoutMapTemp] 添加 [Node] ,并重置 [nodeLayoutMapTemp],在这之前 [nodeLayoutMapTemp] 已被 [clear] 过了。
        widget.fragmentPoolController.nodeLayoutMapTemp[widget.thisRouteName] = widget.fragmentPoolController.defaultLayoutPropertyMap(size: size);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    _getLayout();
    if (!widget.fragmentPoolController.nodeLayoutMap.containsKey(widget.thisRouteName)) {
      widget.fragmentPoolController.nodeLayoutMap[widget.thisRouteName] = widget.fragmentPoolController.defaultLayoutPropertyMap(size: null);
    }
    return Positioned(
      left: widget.fragmentPoolController.nodeLayoutMap[widget.thisRouteName]["layout_left"],
      top: widget.fragmentPoolController.nodeLayoutMap[widget.thisRouteName]["layout_top"],
      child: CustomPaint(
        painter: SingleNodeLine(
          path: () {
            /// 以下皆相对 path
            Path path = Path();
            if (widget.thisRouteName != "0") {
              path.moveTo(0, widget.fragmentPoolController.nodeLayoutMap[widget.thisRouteName]["layout_height"] / 2);
              path.lineTo(-40, widget.fragmentPoolController.nodeLayoutMap[widget.thisRouteName]["layout_height"] / 2);
              double fatherCenterTop = widget.fragmentPoolController.nodeLayoutMap[widget.fragmentPoolController.nodeLayoutMap[widget.thisRouteName]["father_route"]]["layout_top"] +
                  widget.fragmentPoolController.nodeLayoutMap[widget.fragmentPoolController.nodeLayoutMap[widget.thisRouteName]["father_route"]]["layout_height"] / 2;
              double thisCenterTop = widget.fragmentPoolController.nodeLayoutMap[widget.thisRouteName]["layout_top"];

              path.lineTo(-40, fatherCenterTop - thisCenterTop);
              path.lineTo(-80, fatherCenterTop - thisCenterTop);
            }
            return path;
          }(),
        ),
        child: TextButton(child: Text("aaa"), onPressed: () {}),
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
