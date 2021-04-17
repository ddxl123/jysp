// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:jysp/Database/models/MDownloadQueueModule.dart';
// import 'package:jysp/G/GSqlite/GSqlite.dart';
// import 'package:jysp/NotNeedTools/DownloadQueue/DownloadQueueController/DownloadQueueModule.dart';
// import 'package:sqflite/sqflite.dart';
// import 'package:jysp/NotNeedTools/DownloadQueue/DownloadQueueController/Extension.dart';

// class DownloadQueueController extends ChangeNotifier {
//   ///

//   /// 让该控制器全局存在而不被 dispose
//   /// 当 provider 所在的 widget 被 remove，会调用其 ChangeNotifier 的 dispose，一次需要阻止该 ChangeNotifier 被dispose
//   @override
//   // ignore: must_call_super
//   void dispose() {
//     return;
//   }

//   List<DownloadQueueModule> baseDownloadModuleGroupUse = [];

//   /// 【基础模型组】
//   List<DownloadQueueModule> baseDownloadModuleGroup = [
//     DownloadQueueModule(
//       moduleName: "用户资源",
//       isDownloaded: DownloadIsOk.no,
//       isRequired: IsRequired.no,
//       getBaseData: () async {},
//     ),
//     DownloadQueueModule(
//       moduleName: "用户资源",
//       isDownloaded: DownloadIsOk.no,
//       isRequired: IsRequired.no,
//       getBaseData: () async {},
//     ),
//     DownloadQueueModule(
//       moduleName: "英文词汇发音(美式)资源",
//       isDownloaded: DownloadIsOk.no,
//       isRequired: IsRequired.no,
//       getBaseData: () async {},
//     ),
//     DownloadQueueModule(
//       moduleName: "英文词汇发音(英式)资源",
//       isDownloaded: DownloadIsOk.no,
//       isRequired: IsRequired.no,
//       getBaseData: () async {},
//     ),
//     DownloadQueueModule(
//       moduleName: "文字识别系统资源",
//       isDownloaded: DownloadIsOk.no,
//       isRequired: IsRequired.no,
//       getBaseData: () async {},
//     ),
//   ];

//   void selectAllOptionalModules(bool isSelect) {
//     baseDownloadModuleGroup.forEach(
//       (module) {
//         module.isChosenOptional = isSelect;
//         module.setState(() {});
//       },
//     );
//   }

//   Future<void> downloadSelected() async {
//     for (var i = 0; i < baseDownloadModuleGroup.length; i++) {
//       DownloadQueueModule baseModule = baseDownloadModuleGroup[i];
//       // 若已被选且未被下载
//       if (baseModule.isChosenOptional && baseModule.isDownloaded == DownloadIsOk.no) {
//         baseModule.getBaseData(); // 直接存至 sqlite，存入之后对被存的进行 setState
//       }
//     }
//   }

//   Future<void> future() async {
//     await Future.delayed(Duration(seconds: 2));

//     List<MDownloadQueueModule> moduleModels = await MDownloadQueueModule.getAllRowsAsModel();

//     await _check(moduleModels);
//     await _setUse(moduleModels);
//   }

//   /// 检查【基础模型组】与 MDownloadQueueModule 数据表 数据是否一一对应
//   Future<void> _check(List<MDownloadQueueModule> moduleModels) async {
//     // 表示如果查询到 MDownloadQueueModule 表数据为空，则表示应用被下载后第一次被打开。需将【基本模型组】进行初始化。
//     if (moduleModels.isEmpty) {
//       Batch batch = GSqlite.db.batch();
//       baseDownloadModuleGroup.forEach(
//         (baseDownloadModule) {
//           batch.insert(
//             MDownloadQueueModule.getTableName,
//             MDownloadQueueModule.toSqliteMap(
//               module_name_v: baseDownloadModule.moduleName,
//               isRequired_v: baseDownloadModule.isRequired,
//               download_is_ok_v: baseDownloadModule.isDownloaded,
//               created_at_v: DateTime.now().millisecondsSinceEpoch,
//               updated_at_v: DateTime.now().millisecondsSinceEpoch,
//             ),
//           );
//         },
//       );
//       await batch.commit(continueOnError: false);
//       return;
//     }

//     // 检查【基础模型组】是否与 sqlite 查询到的名称是否完全一致
//     //
//     // 若不一致，则表示 MDownloadQueueModule 表数据为空(即应用被下载后第一次被打开)，或应用更新使得 baseDownloadModuleGroup 元素被修改。
//     if (!(baseDownloadModuleGroup.moduleNamesString() == moduleModels.moduleNamesString())) {
//       // 1. 先把被标记已下载过的转移至【基础模型组】
//       moduleModels.forEach(
//         (moduleModel) {
//           baseDownloadModuleGroup.forEach(
//             (baseDownloadModule) {
//               if (moduleModel.get_module_name == baseDownloadModule.moduleName) {
//                 baseDownloadModule.isRequired = moduleModel.get_isRequired;
//                 baseDownloadModule.isDownloaded = moduleModel.get_download_is_ok;
//               }
//             },
//           );
//         },
//       );

//       // 2. 清空 sqlite 的 MDownloadQueueModule 表
//       await GSqlite.db.delete(MDownloadQueueModule.getTableName);

//       // 3. 重新写入
//       Batch batch = GSqlite.db.batch();
//       baseDownloadModuleGroup.forEach(
//         (baseDownloadModule) {
//           batch.insert(
//             MDownloadQueueModule.getTableName,
//             MDownloadQueueModule.toSqliteMap(
//               module_name_v: baseDownloadModule.moduleName,
//               isRequired_v: baseDownloadModule.isRequired,
//               download_is_ok_v: baseDownloadModule.isDownloaded,
//               created_at_v: DateTime.now().millisecondsSinceEpoch,
//               updated_at_v: DateTime.now().millisecondsSinceEpoch,
//             ),
//           );
//         },
//       );
//       await batch.commit(continueOnError: false);
//     }
//   }

//   /// 设置列表
//   Future<void> _setUse(List<MDownloadQueueModule> moduleModels) async {
//     // 其中一个为空就代表初始化过后的重复打开应用。
//     // 应用被关闭后撤销了全部正在下载的状态，因此【初始化过后的重复打开应用】意味着可以直接拉取 MDownloadQueueModule 表中的 isDownloaded 属性内容
//     if (baseDownloadModuleGroupUse.isEmpty) {
//       moduleModels.forEach(
//         (moduleModel) {
//           baseDownloadModuleGroup.forEach(
//             (baseDownloadModule) {
//               if (moduleModel.get_module_name == baseDownloadModule.moduleName) {
//                 baseDownloadModule.isRequired = moduleModel.get_isRequired;
//                 baseDownloadModule.isDownloaded = moduleModel.get_download_is_ok;
//               }
//             },
//           );
//         },
//       );

//       // 其次进行 应用全局 插入。
//       baseDownloadModuleGroup.forEach(
//         (baseDownloadModule) {
//           baseDownloadModuleGroupUse.add(baseDownloadModule);
//         },
//       );
//     }
//     // 都不为空就代表应用一直处于打开状态，但是重复性的打开【下载队列页】
//     else {
//       // 无
//     }
//   }

//   ///
// }
