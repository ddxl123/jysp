// import 'package:flutter/material.dart';
// import 'package:jysp/FragmentPool/FragmentPool.dart';
// import 'package:jysp/FragmentPool/Nodes/BaseNodes/BaseNode.dart';
// import 'package:jysp/FragmentPool/Nodes/ToolNodes/NodeMixin.dart';
// import 'package:jysp/Pages/SheetPage.dart';
// import 'package:jysp/Global/GlobalData.dart';
// import 'package:jysp/Tools/CustomButton.dart';
// import 'package:jysp/sheet/SheetMixin.dart';

// class RootNode extends BaseNode {
//   RootNode(int currentIndex, nodeData) : super(currentIndex, nodeData);

//   @override
//   State<StatefulWidget> createState() => _RootNodeState();
// }

// class _RootNodeState extends State<RootNode> with SheetMixin, NodeMixin {
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       height: 500,
//       child: CustomButton(
//         onPressed: _onPressed,
//         color: Colors.red,
//         child: Text(GlobalData.instance.userSelfInitFragmentPool[widget.currentIndex]["pool_display_name"]),
//       ),
//     );
//   }

//   void _onPressed() {
//     Navigator.of(context).push(
//       SheetRoute(
//         slivers: (ScrollController scrollController) {
//           return [
//             mixinTopWidget(),
//             mixinTopPaddingWidget(scrollController),
//             SliverToBoxAdapter(
//               child: FlatButton(
//                 onPressed: () {
//                   nodeAddFragment(widget.currentIndex, widget.nodeData);
//                 },
//                 child: Text("data"),
//               ),
//             ),
//             mixinFixedWidget(),
//             mixinMappingWidget(),
//             mixinBottomWidget(),
//           ];
//         },
//       ),
//     );
//     // Navigator.of(context).push(
//     //   SheetRoute(
//     //     mainSingleNodeData: widget.mainSingleNodeData,
//     //     sliver1Builder: (_) {
//     //       return SliverToBoxAdapter(
//     //         child: FlatButton(
//     //           child: Text("To loading"),
//     //           onPressed: () {
//     //             Navigator.of(context).push(LoadingPage());
//     //           },
//     //         ),
//     //       );
//     //     },
//     //     sliver2Builder: (_) {
//     //       return SliverList(
//     //         delegate: SliverChildBuilderDelegate(
//     //           (_, index) {
//     //             return Container(
//     //               color: Colors.yellow,
//     //               child: Text(index.toString()),
//     //             );
//     //           },
//     //           childCount: 50,
//     //         ),
//     //       );
//     //     },
//     //   ),
//     // );
//   }
// }
