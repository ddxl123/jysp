// import 'package:flutter/material.dart';
// import 'package:jysp/NotNeedTools/DownloadQueue/DownloadQueueController/DownloadQueueController.dart';
// import 'package:provider/provider.dart';

// class DownloadList extends StatefulWidget {
//   @override
//   _DownloadListState createState() => _DownloadListState();
// }

// class _DownloadListState extends State<DownloadList> {
//   ///

//   @override
//   Widget build(BuildContext context) {
//     return FutureBuilder(
//       future: context.read<DownloadQueueController>().future(),
//       builder: (BuildContext context, AsyncSnapshot snapshot) {
//         switch (snapshot.connectionState) {
//           case ConnectionState.waiting:
//             return Center(child: Text("加载中..."));
//           case ConnectionState.done:
//             return CustomScrollView(
//               physics: BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
//               slivers: [
//                 SliverList(
//                   delegate: SliverChildBuilderDelegate(
//                     (_, index) {
//                       return context.read<DownloadQueueController>().baseDownloadModuleGroupUse[index].widget;
//                     },
//                     childCount: context.read<DownloadQueueController>().baseDownloadModuleGroupUse.length,
//                   ),
//                 ),
//               ],
//             );
//           default:
//             return Center(child: Text("unknown connectionState"));
//         }
//       },
//     );
//   }

//   ///
// }
