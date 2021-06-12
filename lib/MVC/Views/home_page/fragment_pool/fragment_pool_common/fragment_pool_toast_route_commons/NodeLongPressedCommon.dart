import 'package:flutter/material.dart';
import 'package:jysp/database/merge_models/MMPoolNode.dart';
import 'package:jysp/database/models/MBase.dart';
import 'package:jysp/mvc/request/offline/RSqliteCurd.dart';
import 'package:jysp/mvc/views/home_page/fragment_pool/fragment_pool_common/fragment_pool_toast_route_commons/RenameCommon.dart';
import 'package:jysp/tools/RoundedBox..dart';
import 'package:jysp/tools/TDebug.dart';
import 'package:jysp/tools/toast/ShowToast.dart';
import 'package:jysp/tools/toast/ToastRoute.dart';

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
              onPressed: () {
                Navigator.push(
                  context,
                  RenameCommon(
                    context,
                    model: mmPoolNode.model,
                    oldName: mmPoolNode.name,
                    nameKey: mmPoolNode.name,
                    updatedAtKey: mmPoolNode.updated_at,
                  ),
                );
              },
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
  Future<Toast<bool>> whenPop(PopResult? popResult) async {
    try {
      if (popResult == null || popResult.popResultSelect == PopResultSelect.clickBackground) {
        return showToast(text: '未选择', returnValue: true);
      }
      //
      else if (popResult.popResultSelect == PopResultSelect.one) {
        final bool deleteResult = await RSqliteCurd<MBase>.byModel(mmPoolNode.model).deleteRow(transactionMark: null);
        if (deleteResult) {
          return showToast(text: '删除成功', returnValue: true);
        } else {
          return showToast(text: '删除失败', returnValue: false);
        }
      }
      //
      else {
        throw 'unknown popResult: $popResult';
      }
    } catch (e, r) {
      dLog(() => '$e---$r');
      return showToast<bool>(text: 'err', returnValue: false);
    }
  }
}
