// import 'package:flutter/material.dart';
// import 'package:jysp/FragmentPool/Nodes/BaseNodes/IfNode.dart';
// import 'package:jysp/Global/GlobalData.dart';
// import 'package:jysp/FragmentPool/FragmentPool.dart';

// class MainSingleNode extends StatefulWidget {
//   MainSingleNode({
//     Key key,
//     @required this.index,
//     @required this.thisRouteName,
//     @required this.nodeLayoutMap,
//     @required this.nodeLayoutMapTemp,
//     @required this.isResetingLayout,
//     @required this.isResetingLayoutProperty,
//     @required this.reLayoutHandle,
//   }) : super(key: key);

//   final int index;
//   final String thisRouteName;
//   final Map nodeLayoutMap;
//   final Map nodeLayoutMapTemp;
//   final Function(bool) isResetingLayout;
//   final bool Function() isResetingLayoutProperty;
//   final Function reLayoutHandle;

//   @override
//   MainSingleNodeState createState() => MainSingleNodeState();
// }

// class MainSingleNodeState extends State<MainSingleNode> {
//   /// 因为每次新增的 [Node] 是不会被调用 [didUpdateWidget] 的,即无法 [reSetLayout] 对其进行初始化布局属性
//   /// 因此需在每个 [Node] 中进行 [initState] 并调用 [reSetLayout] 进行初始化布局属性
//   @override
//   void initState() {
//     super.initState();
//     resetLayoutProperty();
//   }

//   @override
//   void didUpdateWidget(MainSingleNode oldWidget) {
//     super.didUpdateWidget(oldWidget);

//     /// 当调用 [父Wideget的reLayout] 时才调用 [reGetLayout],而 [父Widget被rebuild] 时不会调用
//     /// 否则虽然第二帧没变化，但是第二帧的
//     widget.isResetingLayoutProperty()
//         ? resetLayoutProperty()

//         /// 第一帧调用 [resetLayoutProperty] ,第二帧才调用下面
//         : resetLayoutDone();
//   }

//   /// 默认布局数据
//   Map<dynamic, dynamic> _defaultLayoutPropertyMap({Size size}) {
//     return {
//       "child_count": 0,
//       "layout_width": size == null ? 10 : size.width, // 不设置它为0是为了防止出现bug观察不出来
//       "layout_height": size == null ? 10 : size.height,
//       "layout_left": -10000.0,
//       "layout_top": -10000.0,
//       "container_height": size == null ? 10 : size.height,
//       "vertical_center_offset": 0.0
//     };
//   }

//   /// 第一帧开始及完成：重置布局属性
//   void resetLayoutProperty() {
//     WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
//       Size size = (this.context.findRenderObject() as RenderBox).size;

//       /// 给 [nodeLayoutMap] 添加 [Node]
//       /// 重置 [Node属性],在这之前 [nodeLayoutMap] 已被 [clear] 过了
//       widget.nodeLayoutMap[widget.thisRouteName] = _defaultLayoutPropertyMap(size: size);

//       /// 若全部的 [Node属性] 都被重置完成，则开始进行 [布局]
//       if (widget.index == GlobalData.instance.userSelfInitFragmentPoolNodes.length - 1) {
//         print("resetLayoutPropertyDone");
//         widget.reLayoutHandle();
//         // 在这之后，在 [reLayoutHandle] 中会继续调用 [resetLayoutDone]
//       }
//     });
//   }

//   /// 第二帧开始及完成：重置布局完成
//   void resetLayoutDone() {
//     WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
//       if (widget.index == GlobalData.instance.userSelfInitFragmentPoolNodes.length - 1) {
//         print("resetLayoutDone");
//         widget.isResetingLayout(false);
//       }
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Positioned(
//       left: widget.nodeData(widget.index, NeedType.getCurrentMap, key: "layout_left"),
//       top: widget.nodeData(widget.index, NeedType.getCurrentMap, key: "layout_top"),
//       child: CustomPaint(
//           painter: SingleNodeLine(
//             path: () {
//               /// 以下皆相对 path
//               Path path = Path();
//               if (widget.nodeData(widget.index, NeedType.getCurrentRouteName) != "0") {
//                 path.moveTo(0, widget.nodeData(widget.index, NeedType.getCurrentMap, key: "layout_height") / 2);
//                 path.lineTo(-40, widget.nodeData(widget.index, NeedType.getCurrentMap, key: "layout_height") / 2);
//                 double fatherCenterTop = widget.nodeData(widget.index, NeedType.getFatherMap, key: "layout_top") + (widget.nodeData(widget.index, NeedType.getFatherMap, key: "layout_height") / 2);
//                 double thisCenterTop = widget.nodeData(widget.index, NeedType.getCurrentMap, key: "layout_top");

//                 path.lineTo(-40, fatherCenterTop - thisCenterTop);
//                 path.lineTo(-80, fatherCenterTop - thisCenterTop);
//               }
//               return path;
//             }(),
//           ),
//           child: IfNode(widget.index, widget.nodeData)),
//     );
//   }
// }

// class SingleNodeLine extends CustomPainter {
//   SingleNodeLine({@required this.path});
//   final Path path;
//   @override
//   void paint(Canvas canvas, Size size) {
//     final Paint paint = Paint();
//     paint.color = Colors.white;
//     paint.style = PaintingStyle.stroke;
//     paint.strokeWidth = 4.0;
//     canvas.drawPath(path, paint);
//   }

//   @override
//   bool shouldRepaint(CustomPainter oldDelegate) => false;
// }
