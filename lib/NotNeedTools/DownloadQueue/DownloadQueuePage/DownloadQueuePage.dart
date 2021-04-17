// import 'package:flutter/material.dart';
// import 'package:jysp/G/G.dart';
// import 'package:jysp/NotNeedTools/DownloadQueue/DownloadQueuePage/DownloadBottom.dart';
// import 'package:jysp/NotNeedTools/DownloadQueue/DownloadQueuePage/DownloadList.dart';

// class DownloadQueuePage extends OverlayRoute {
//   ///

//   DownloadQueuePage({required this.widget});
//   Widget Function(Widget) widget;

//   @override
//   Iterable<OverlayEntry> createOverlayEntries() {
//     return [
//       OverlayEntry(
//         builder: (_) {
//           return widget(
//             Builder(
//               builder: (ctx) {
//                 return Material(
//                   type: MaterialType.transparency,
//                   child: Stack(
//                     children: [
//                       _background(),
//                       _body(),
//                     ],
//                   ),
//                 );
//               },
//             ),
//           );
//         },
//       )
//     ];
//   }

//   Widget _background() {
//     return Opacity(
//       opacity: 0.5,
//       child: Container(
//         alignment: Alignment.center,
//         color: Colors.black,
//       ),
//     );
//   }

//   Widget _body() {
//     return Positioned(
//       child: Center(
//         child: Container(
//           width: 300,
//           decoration: BoxDecoration(
//             color: Colors.yellow,
//             borderRadius: BorderRadius.circular(10),
//             boxShadow: [
//               BoxShadow(offset: Offset(10, 10), blurRadius: 10, spreadRadius: -10),
//             ],
//           ),
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               // 这里的占比是根据父容器大小的占比
//               Flexible(child: _title()),
//               Flexible(child: DownloadList()),
//               Flexible(child: DownloadBottom()),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _title() {
//     return Container(
//       padding: EdgeInsets.fromLTRB(20, 10, 0, 10),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: [
//           Container(
//             child: Text(
//               "下载队列：",
//               style: TextStyle(fontSize: 16),
//             ),
//           ),
//           TextButton.icon(
//             style: TextButton.styleFrom(
//               padding: EdgeInsets.all(0),
//               tapTargetSize: MaterialTapTargetSize.shrinkWrap,
//             ),
//             icon: Icon(Icons.close),
//             label: Text(""),
//             onPressed: () {
//               Navigator.pop(G.globalKey.currentContext!);
//             },
//           ),
//         ],
//       ),
//     );
//   }

//   @override
//   // ignore: must_call_super
//   // bool didPop(result) {
//   //   return true;
//   // }

//   @override
//   void dispose() {
//     super.dispose();
//   }

//   ///
// }
