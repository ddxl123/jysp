import 'package:flutter/material.dart';
import 'package:jysp/Database/MergeModels/MMPoolNode.dart';
import 'package:jysp/Database/Models/MBase.dart';
import 'package:jysp/MVC/Request/Sqlite/RSqliteCurd.dart';
import 'package:jysp/Tools/RoundedBox..dart';
import 'package:jysp/Tools/TDebug.dart';
import 'package:jysp/Tools/Toast/ShowToast.dart';
import 'package:jysp/Tools/Toast/ToastRoute.dart';

class NodeLongPressedCommon extends ToastRoute {
  NodeLongPressedCommon(BuildContext fatherContext, {required this.mmPoolNode}) : super(fatherContext);
  final MMPoolNode mmPoolNode;

  @override
  Color get backgroundColor => Colors.transparent;

  @override
  double get backgroundOpacity => 0;

  @override
  List<Widget> body() {
    return <Widget>[
      AutoPositioned(
        child: RoundedBox(
          children: <Widget>[
            TextButton(
              child: const Text('修改名称'),
              onPressed: () {},
            ),
            TextButton(
              child: const Text('删除节点'),
              onPressed: () {
                Navigator.pop(context, PopResult(popResultSelect: PopResultSelect.one, value: null));
              },
            ),
          ],
        ),
      ),
    ];
  }

  @override
  void init() {}

  @override
  void rebuild() {}

  @override
  Future<Toast<bool>> whenPop(PopResult? popResult) async {
    try {
      if (popResult == null || popResult.popResultSelect == PopResultSelect.clickBackground) {
        return showToast(text: '未选择', returnValue: true);
      } else if (popResult.popResultSelect == PopResultSelect.one) {
        final bool deleteResult = await RSqliteCurd<MBase>.byModel(mmPoolNode.model).toDeleteRow(connectTransaction: null);
        if (deleteResult) {
          return showToast(text: '删除成功', returnValue: true);
        } else {
          return showToast(text: '删除失败', returnValue: false);
        }
      } else {
        throw 'unknown popResult: $popResult';
      }
    } catch (e, r) {
      dLog(() => '$e---$r');
      return showToast<bool>(text: 'err', returnValue: false);
    }
  }
}
