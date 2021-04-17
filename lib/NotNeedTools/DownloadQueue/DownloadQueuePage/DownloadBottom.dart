// import 'package:flutter/material.dart';
// import 'package:jysp/NotNeedTools/DownloadQueue/DownloadQueueController/DownloadQueueController.dart';
// import 'package:provider/provider.dart';

// class DownloadBottom extends StatefulWidget {
//   @override
//   _DownloadBottomState createState() => _DownloadBottomState();
// }

// class _DownloadBottomState extends State<DownloadBottom> {
//   ///

//   bool selectStatus = true;

//   @override
//   Widget build(BuildContext context) {
//     return Row(
//       mainAxisAlignment: MainAxisAlignment.spaceAround,
//       children: [
//         Expanded(
//           child: TextButton(
//             child: Text(selectStatus == true ? "全选" : "全不选"),
//             onPressed: () {
//               context.read<DownloadQueueController>().selectAllOptionalModules(selectStatus);
//               selectStatus = !selectStatus;
//               setState(() {});
//             },
//           ),
//         ),
//         Expanded(
//           child: TextButton(
//             child: Text("下载已选"),
//             onPressed: () {
//               context.read<DownloadQueueController>().downloadSelected();
//             },
//           ),
//         ),
//       ],
//     );
//   }

//   ///
// }
