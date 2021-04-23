// import 'package:flutter/material.dart';
// import 'package:jysp/Database/Models/MDownloadQueueModule.dart';

// class DownloadQueueModule {
//   /// 因为前三个对 MDownloadQueueModule 来说可能获取为空（即使必然不为空）
//   DownloadQueueModule({this.moduleName, this.isDownloaded, this.isRequired, required this.getBaseData, this.getChildrenModule}) {
//     this.widget = _setWidget();
//   }

//   ///
//   /// 对应 [MDownloadQueueModule] 部分
//   ///
//   String? moduleName;
//   DownloadIsOk? isDownloaded; // 为 null 时表示正在下载中
//   IsRequired? isRequired;

//   ///
//   /// 其它部分
//   ///
//   int downloadProgress = 0;
//   Function(Function()) setState = (_) {};
//   Future<void> Function() getBaseData; // 点下载的时候调用
//   Future<void> Function()? getChildrenModule;
//   List<DownloadQueueModule> childrenModules = [];

//   /// 针对可选的选择状态
//   bool isChosenOptional = false;

//   /// 必须是一个对象，不能是一个函数调用
//   late Widget widget;

//   Widget _setWidget() {
//     return StatefulBuilder(
//       builder: (BuildContext context, rebuild) {
//         if (!(this.setState == rebuild)) {
//           this.setState = rebuild;
//         }
//         if (moduleName == null) {
//           return _row("moduleName_is_null", Container());
//         }
//         if (isRequired == null) {
//           return _row("isRequired_is_null", Container());
//         }
//         // 已被下载
//         if (isDownloaded == DownloadIsOk.yes && getChildrenModule != null) {
//           return ShowChildren(this);
//         }
//         if (isDownloaded == DownloadIsOk.yes && getChildrenModule == null) {
//           return _row(moduleName!, Icon(Icons.check_circle_outline));
//         }
//         // 必选且未被下载
//         if (isRequired == IsRequired.yes && isDownloaded == DownloadIsOk.no) {
//           return _row(
//             moduleName!,
//             Checkbox(
//               value: true,
//               onChanged: (_) {},
//               activeColor: Colors.grey,
//             ),
//           );
//         }
//         // 可选且未被下载
//         if (isRequired == IsRequired.no && isDownloaded == DownloadIsOk.no) {
//           return _row(
//             moduleName!,
//             Checkbox(
//               value: isChosenOptional,
//               onChanged: (isChange) {
//                 isChosenOptional = isChange!;
//                 rebuild(() {});
//               },
//             ),
//           );
//         }
//         // 否则正在下载
//         return _row(moduleName!, TextButton(onPressed: () {}, child: Text(downloadProgress.toString() + " %")));
//       },
//     );
//   }

//   Widget _row(String moduleName, Widget selectWidget) {
//     return Row(
//       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//       children: [
//         Expanded(child: Text(moduleName)),
//         selectWidget,
//       ],
//     );
//   }

//   String moduleNameString() {
//     return moduleName.toString();
//   }

//   @override
//   String toString() {
//     return {
//       MDownloadQueueModule.module_name: moduleName,
//       MDownloadQueueModule.download_is_ok: isDownloaded,
//       MDownloadQueueModule.isRequired: isRequired,
//       "downloadProgress": downloadProgress,
//     }.toString();
//   }
// }

// class ShowChildren extends StatefulWidget {
//   ShowChildren(this.downloadQueueModule);
//   final DownloadQueueModule downloadQueueModule;
//   @override
//   _ShowChildrenState createState() => _ShowChildrenState();
// }

// class _ShowChildrenState extends State<ShowChildren> {
//   @override
//   Widget build(BuildContext context) {
//     return FutureBuilder(
//       future: _futrue(),
//       builder: _builder,
//     );
//   }

//   Future<void> _futrue() async {
//     await widget.downloadQueueModule.getChildrenModule!();
//   }

//   Widget _builder(BuildContext context, AsyncSnapshot snapshot) {
//     switch (snapshot.connectionState) {
//       case ConnectionState.waiting:
//         return Container(child: Text("获取中..."));
//       case ConnectionState.done:
//         return Column(
//           children: [
//             Row(
//               children: [
//                 Icon(Icons.chevron_right),
//                 Expanded(child: Text(widget.downloadQueueModule.moduleName!)),
//                 // for (var i = 0; i < widget.downloadQueueModule.childrenModules.length; i++)
//               ],
//             ),
//           ],
//         );
//       default:
//         return Container(child: Text("获取异常: ${snapshot.connectionState.toString()}"));
//     }
//   }
// }
