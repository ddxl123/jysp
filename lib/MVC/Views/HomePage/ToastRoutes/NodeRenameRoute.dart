// import 'package:flutter/material.dart';
// import 'package:jysp/Database/MergeModels/MMPoolNode.dart';
// import 'package:jysp/Database/Models/MBase.dart';
// import 'package:jysp/MVC/Controllers/FragmentPoolController/FragmentPoolController.dart';
// import 'package:jysp/MVC/Request/Sqlite/RSqliteCurd.dart';
// import 'package:jysp/Tools/RoundedBox..dart';
// import 'package:jysp/Tools/TDebug.dart';
// import 'package:jysp/Tools/Toast/ShowToast.dart';
// import 'package:jysp/Tools/Toast/Toast.dart';
// import 'package:provider/provider.dart';

// class NodeRenameRoute extends ToastRoute {
//   NodeRenameRoute(BuildContext fatherContext, {required this.poolNodeMModel}) : super(fatherContext);
//   final MMPoolNode poolNodeMModel;

//   @override
//   AlignmentDirectional get stackAlignment => AlignmentDirectional.center;

//   final FocusNode _focusNode = FocusNode();
//   late TextEditingController _textEditingController;

//   double positionedButtom = 0.0;

//   @override
//   void init() {
//     // 自动对焦
//     _focusNode.requestFocus();
//     _textEditingController = TextEditingController(text: poolNodeMModel.get_name);
//   }

//   @override
//   List<Positioned> body() {
//     return <Positioned>[
//       Positioned(
//         child: Container(
//           alignment: Alignment.center,
//           width: MediaQuery.of(context).size.width,
//           height: MediaQuery.of(context).size.height,
//           child: RoundedBox(
//             width: 200,
//             height: null,
//             pidding: const EdgeInsets.all(10),
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: <Widget>[
//               Container(child: Text('当前名称: ${poolNodeMModel.get_name}')),
//               const SizedBox(height: 10),
//               Row(
//                 children: <Widget>[
//                   Container(child: const Text('修改后:')),
//                   const SizedBox(width: 10),
//                   Expanded(
//                     child: Container(
//                       color: Colors.white,
//                       height: 50,
//                       child: TextField(focusNode: _focusNode, controller: _textEditingController),
//                     ),
//                   ),
//                 ],
//               ),
//               const SizedBox(height: 10),
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceAround,
//                 children: <Widget>[
//                   TextButton(
//                     style: ButtonStyle(backgroundColor: MaterialStateProperty.all(Colors.red), tapTargetSize: MaterialTapTargetSize.shrinkWrap),
//                     child: const Text('确认'),
//                     onPressed: () {
//                       Navigator.pop(context, 0);
//                     },
//                   ),
//                   TextButton(
//                     style: const ButtonStyle(tapTargetSize: MaterialTapTargetSize.shrinkWrap),
//                     child: const Text('取消'),
//                     onPressed: () {
//                       Navigator.pop(context, null);
//                     },
//                   ),
//                 ],
//               ),
//             ],
//           ),
//         ),
//       ),
//     ];
//   }

//   @override
//   void rebuild() {
//     // 获取键盘高度
//     positionedButtom = MediaQuery.of(context).viewInsets.bottom;
//   }

//   @override
//   Future<Toast<bool>> Function(int? result)? get whenPop {
//     return (int? result) async {
//       try {
//         if (result == null) {
//           return showToast<bool>(text: '已取消', returnValue: true);
//         } else if (result == 0) {
//           await RSqliteCurd<MBase>.byModel(poolNodeMModel.model).toUpdateRow(
//             updateContent: <String, Object?>{poolNodeMModel.name: _textEditingController.text},
//             isReturnNewModel: false,
//             connectTransaction: null,
//           );
//           poolNodeMModel.getRowJson.update(poolNodeMModel.name, (Object? value) => _textEditingController.text);
//           fatherContext.read<FragmentPoolController>().needInitStateForSetState(() {});
//           return showToast<bool>(text: '修改成功', returnValue: true);
//         } else {
//           throw 'whenPop err: $result';
//         }
//       } catch (e) {
//         dLog(() => e);
//         return showToast(text: '修改失败', returnValue: false);
//       }
//     };
//   }
// }
