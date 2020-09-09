import 'package:flutter/material.dart';
import 'package:jysp/FragmentPool/Nodes/BaseNodes/IfNode.dart';
import 'package:jysp/FragmentPool/Nodes/BaseNodes/MainSingleNodeData.dart';
import 'package:jysp/FragmentPool/Nodes/ToolNodes/FreeBox.dart';

class MainSingleNode extends StatefulWidget {
  MainSingleNode({
    Key key,
    @required this.index,
    @required this.fragmentPoolDataList,
    @required this.fragmentPoolLayoutDataMap,
    @required this.fragmentPoolLayoutDataMapTemp,
    @required this.freeBoxController,
    @required this.isResetingLayout,
    @required this.isResetingLayoutProperty,
    @required this.resetLayout,
    @required this.reLayoutHandle,
  }) : super(key: key);

  final int index;
  final List<Map<dynamic, dynamic>> fragmentPoolDataList;
  final Map<String, dynamic> fragmentPoolLayoutDataMap;
  final Map<String, dynamic> fragmentPoolLayoutDataMapTemp;
  final FreeBoxController freeBoxController;
  final Function(bool) isResetingLayout;
  final Function resetLayout;
  final bool Function() isResetingLayoutProperty;
  final Function reLayoutHandle;

  @override
  MainSingleNodeState createState() => MainSingleNodeState();
}

class MainSingleNodeState extends State<MainSingleNode> {
  MainSingleNodeData mainSingleNodeData = MainSingleNodeData();

  /// 默认布局数据
  Map<dynamic, dynamic> defaultLayoutPropertyMap(Size size) {
    return {
      "index": widget.index,
      "this": this,
      "child_count": 0,
      "layout_width": size.width,
      "layout_height": size.height,
      "layout_left": -10000.0,
      "layout_top": -10000.0,
      "container_height": size.height,
      "vertical_center_offset": 0.0
    };
  }

  /// 给 [SingleNodeData] 赋值
  void resetSingleNodeData() {
    mainSingleNodeData.thisIndex = widget.index; // 需按值传递
    mainSingleNodeData.thisRouteName = widget.fragmentPoolDataList[widget.index]["route"]; // 需按值传递
    mainSingleNodeData.thisFatherRouteName = () {
      List<String> spl = mainSingleNodeData.thisRouteName.split("-");
      return spl.sublist(0, spl.length - 1).join("-");
    }(); // 按值传递

    /// 调用父级的 [reLayout] 会清空 [fragmentPoolLayoutDataMap] ,因此需要 [fragmentPoolLayoutDataMapTemp]
    /// 而初始化时的第一帧 [fragmentPoolLayoutDataMap] 和 [fragmentPoolLayoutDataMapTemp] 都是null,因此需要 [defaultLayoutDataMap]

    /// 无需 [singleNodeData.thisRouteMap.clear()] ,直接赋值,若要 [clear] 则必须按值传递
    // 需按地址传递
    mainSingleNodeData.thisRouteMap =
        widget.fragmentPoolLayoutDataMap[mainSingleNodeData.thisRouteName] ?? widget.fragmentPoolLayoutDataMapTemp[mainSingleNodeData.thisRouteName] ?? defaultLayoutPropertyMap(Size.zero);
    mainSingleNodeData.thisFatherRouteMap =
        widget.fragmentPoolLayoutDataMap[mainSingleNodeData.thisFatherRouteName] ?? widget.fragmentPoolLayoutDataMapTemp[mainSingleNodeData.thisFatherRouteName] ?? defaultLayoutPropertyMap(Size.zero);

    /// [fragmentPoolDataList] 在 [父widget.initState] 里就已经被初始化完成了,且是固定的,不会被 [clear],之后获取 [fragmentPoolDataList] 内的数据时无需担心报null
    /// 而 [fragmentPoolLayoutDataMap] 是一个 [布局Map] ,是需要随时 [reLayout] 的
    mainSingleNodeData.fragmentPoolDataList = widget.fragmentPoolDataList; // 需按地址传递
    mainSingleNodeData.fragmentPoolLayoutDataMap = widget.fragmentPoolLayoutDataMap; // 需按地址传递
    mainSingleNodeData.freeBoxController = widget.freeBoxController; // 需按地址传递
    mainSingleNodeData.resetLayout = widget.resetLayout; // 需按地址传递
  }

  /// 初始化布局属性
  void resetLayoutProperty() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      String thisRoute = widget.fragmentPoolDataList[widget.index]["route"];
      Size size = (this.context.findRenderObject() as RenderBox).size;

      /// 给 [fragmentPoolLayoutDataMap] 添加 [Node]
      /// 重置 [Node属性],在这之前 [fragmentPoolLayoutDataMap] 已被 [clear] 过了
      widget.fragmentPoolLayoutDataMap[thisRoute] = defaultLayoutPropertyMap(size);

      /// 若全部的 [Node属性] 都被重置完成，则开始进行 [布局]
      if (widget.index == widget.fragmentPoolDataList.length - 1) {
        print("resetLayoutPropertyDone");
        widget.reLayoutHandle();
      }
    });
  }

  /// 当重置布局完成
  void resetLayoutDone() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      if (widget.index == widget.fragmentPoolDataList.length - 1) {
        print("resetLayoutDone");
        widget.isResetingLayout(false);
      }
    });
  }

  /// 因为每次新增的 [Node] 是不会被调用 [didUpdateWidget] 的,即无法 [reSetLayout] 对其进行初始化布局属性
  /// 因此需在每个 [Node] 中进行 [initState] 并调用 [reSetLayout] 进行初始化布局属性
  @override
  void initState() {
    super.initState();
    resetLayoutProperty();
  }

  @override
  void didUpdateWidget(MainSingleNode oldWidget) {
    super.didUpdateWidget(oldWidget);

    /// 当调用 [父Wideget的reLayout] 时才调用 [reGetLayout]
    widget.isResetingLayoutProperty()
        ? resetLayoutProperty()

        /// 第一帧调用 [resetLayoutProperty] ,第二帧才调用下面
        : resetLayoutDone();
  }

  @override
  Widget build(BuildContext context) {
    resetSingleNodeData();
    return Positioned(
      left: mainSingleNodeData.thisRouteMap["layout_left"],
      top: mainSingleNodeData.thisRouteMap["layout_top"],
      child: CustomPaint(
        painter: SingleNodeLine(
          path: () {
            /// 以下皆相对 path
            Path path = Path();
            if (mainSingleNodeData.thisRouteName != "0") {
              path.moveTo(0, mainSingleNodeData.thisRouteMap["layout_height"] / 2);
              path.lineTo(-40, mainSingleNodeData.thisRouteMap["layout_height"] / 2);
              double fatherCenterTop = mainSingleNodeData.thisFatherRouteMap["layout_top"] + (mainSingleNodeData.thisFatherRouteMap["layout_height"] / 2);
              double thisCenterTop = mainSingleNodeData.thisRouteMap["layout_top"];

              path.lineTo(-40, fatherCenterTop - thisCenterTop);
              path.lineTo(-80, fatherCenterTop - thisCenterTop);
            }
            return path;
          }(),
        ),
        child: IfNode(mainSingleNodeData),
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
