// import 'dart:ui';

// import 'package:flutter/material.dart';
// import 'package:jysp/Tools/CustomButton.dart';
// import 'package:jysp/sheet/SheetPagePersistentDelegate.dart';

// mixin SheetMixin {
//   ///
//   ///
//   ///
//   ///
//   ///
//   /// 是否把 [Mapping] 隐藏 n
//   bool _isOffstageMapping = false;
//   Function(Function()) _setStateMappingWidget;

//   /// 顶部
//   Widget mixinFixedWidget() {
//     return StatefulBuilder(
//       builder: (_, rebuild) {
//         return SliverPersistentHeader(
//           pinned: true,
//           delegate: SheetPagePersistentDelegate(
//             minHeight: 50.0,
//             maxHeight: 50.0,
//             child: Row(
//               children: [
//                 Expanded(
//                   child: CustomButton(
//                     child: Row(
//                       children: [
//                         SizedBox(width: 5),
//                         Icon(Icons.remove_red_eye),
//                         SizedBox(width: 5),
//                         Expanded(
//                           child: Text(
//                             "池显样式:  ",
//                             maxLines: 1,
//                             overflow: TextOverflow.ellipsis,
//                           ),
//                         ),
//                       ],
//                     ),
//                     onPressed: () {
//                       _setStateMappingWidget(() {
//                         _isOffstageMapping = !_isOffstageMapping;
//                       });
//                     },
//                     color: Colors.yellow,
//                   ),
//                 ),
//                 CustomButton(
//                   child: Container(
//                     padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
//                     child: Icon(Icons.more_horiz),
//                   ),
//                   onPressed: () {},
//                   color: Colors.yellow,
//                 ),
//               ],
//             ),
//           ),
//         );
//       },
//     );
//   }

//   /// [Node] 映射栏
//   Widget mixinMappingWidget() {
//     // double layoutWidth = widget.mainSingleNodeData.fragmentPoolLayoutDataMap[widget.mainSingleNodeData.thisRouteName]["layout_width"];
//     // double layoutHeight = widget.mainSingleNodeData.fragmentPoolLayoutDataMap[widget.mainSingleNodeData.thisRouteName]["layout_height"];
//     // String poolDisplayName = widget.mainSingleNodeData.fragmentPoolDataList[widget.mainSingleNodeData.thisIndex]["pool_display_name"].toString();
//     double layoutWidth = 100;
//     double layoutHeight = 100;
//     String poolDisplayName = "100";
//     return StatefulBuilder(
//       builder: (_, rebuild) {
//         _setStateMappingWidget = rebuild;
//         if (_isOffstageMapping) {
//           return SliverToBoxAdapter();
//         }
//         if (layoutHeight >= MediaQueryData.fromWindow(window).size.height / 2) {
//           /// 不会被固定在顶部
//           return SliverToBoxAdapter(
//             child:
//                 // 设置高度
//                 Container(
//               height: layoutHeight + 40,
//               child: mixinMappingMain(layoutWidth, layoutHeight, poolDisplayName),
//             ),
//           );
//         } else {
//           /// 会被固定在顶部
//           return SliverPersistentHeader(
//             //// 加上 [pinned==true] 会有折叠/吸顶效果
//             pinned: true, // 滑到顶时会固定
//             floating: true, // 到顶的位置在屏幕的下拉栏下方紧贴
//             delegate:
//                 // 设置高度伸缩范围
//                 SheetPagePersistentDelegate(
//               minHeight: 0.0,
//               maxHeight: layoutHeight + 40.0,
//               child: mixinMappingMain(layoutWidth, layoutHeight, poolDisplayName),
//             ),
//           );
//         }
//       },
//     );
//   }

//   Widget mixinMappingMain(double layoutWidth, double layoutHeight, String poolDisplayName) {
//     return
//         //// 横向滚动区后面的背景，因为滚动是 [BouncingScrollPhysics] 的
//         Container(
//       color: Colors.pink,
//       child:
//           // 横向滚动区
//           ListView(
//         physics: BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
//         reverse: true,
//         scrollDirection: Axis.horizontal,
//         children: [
//           /// 需要设置最小宽度，因为这样的话才能：当[主体]宽度小于屏宽时，让[主体]居中，不然的话会居右，因为 [reverse==true]
//           Container(
//             constraints: BoxConstraints(minWidth: MediaQueryData.fromWindow(window).size.width),
//             padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
//             alignment: Alignment.center,
//             child:
//                 //// 映射 [Node] 主体
//                 Container(
//               alignment: Alignment.center,
//               color: Colors.yellow,
//               width: layoutWidth,
//               height: layoutHeight,
//               child: Text(poolDisplayName),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   /// 底部加载区
//   // Widget mixinBottomWidget(SheetPageController sheetPageController) {
//   //   if (sheetPageController.isInLoadingArea) {
//   //     sheetPageController.loadingController.toLoading();
//   //   } else {
//   //     sheetPageController.loadingController.toSuccess();
//   //   }
//   //   return SliverFillRemaining(
//   //     hasScrollBody: true,
//   //     child: Container(
//   //       color: Colors.white,
//   //       child: LoadingAnimation(loadingController: sheetPageController.loadingController),
//   //     ),
//   //   );
//   // }
// }
