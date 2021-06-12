import 'package:flutter/material.dart';
import 'package:jysp/database/g_sqlite/GSqlite.dart';
import 'package:jysp/database/merge_models/MMFragmentsAboutPoolNode.dart';
import 'package:jysp/database/models/MBase.dart';
import 'package:jysp/mvc/request/offline/RSqliteCurd.dart';
import 'package:jysp/mvc/views/home_page/fragment_pool/fragment_pool_common/fragment_pool_toast_route_commons/RenameCommon.dart';
import 'package:jysp/tools/RoundedBox..dart';
import 'package:jysp/tools/TDebug.dart';
import 'package:jysp/tools/toast/ShowToast.dart';
import 'package:jysp/tools/toast/ToastRoute.dart';
import 'package:sqflite/sqflite.dart';

class FragmentButtonLongPressedCommon extends ToastRoute {
  FragmentButtonLongPressedCommon(BuildContext fatherContext, {required this.mmFragmentsAboutPoolNode}) : super(fatherContext);

  final MMFragmentsAboutPoolNode mmFragmentsAboutPoolNode;

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
              child: const Text('删除该碎片'),
              onPressed: () {
                Navigator.pop(context, PopResult(popResultSelect: PopResultSelect.one, value: null));
              },
            ),
            TextButton(
              child: const Text('修改名称'),
              onPressed: () {
                Navigator.pop(context, PopResult(popResultSelect: PopResultSelect.two, value: null));
                Navigator.push(
                  context,
                  RenameCommon(
                    context,
                    oldName: mmFragmentsAboutPoolNode.title,
                    model: mmFragmentsAboutPoolNode.model,
                    nameKey: mmFragmentsAboutPoolNode.title,
                    updatedAtKey: mmFragmentsAboutPoolNode.updated_at,
                  ),
                );
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
        return showToast<bool>(text: '未选择', returnValue: true);
      }
      //
      else if (popResult.popResultSelect == PopResultSelect.one) {
        // 上层只获取了显示在 sheet 外观上的字段，而这里还需要 aiid/uuid 等字段，因此需要再次 query 获取 aiid/uuid 等字段。
        final bool result = await db.transaction<bool>(
          (Transaction txn) async {
            final List<MMFragmentsAboutPoolNode> mmFragmentsAboutPoolNodes = await MBase.queryRowsAsModels<MBase, MMFragmentsAboutPoolNode, MMFragmentsAboutPoolNode>(
              connectTransaction: txn,
              returnMWhere: null,
              returnMMWhere: (MBase model) {
                return MMFragmentsAboutPoolNode(model: model);
              },
              tableName: mmFragmentsAboutPoolNode.getTableName,
              where: 'id = ?',
              whereArgs: <int>[mmFragmentsAboutPoolNode.get_id!],
              columns: <String>[
                mmFragmentsAboutPoolNode.id,
                mmFragmentsAboutPoolNode.aiid,
                mmFragmentsAboutPoolNode.uuid,
              ],
            );
            if (mmFragmentsAboutPoolNodes.isEmpty) {
              throw 'mmFragmentsAboutPoolNodes is empty';
            }
            final bool deleteResult = await RSqliteCurd<MBase>.byModel(mmFragmentsAboutPoolNodes.first.model).deleteRow(transactionMark: TransactionMark(txn));
            return deleteResult;
          },
        );

        if (result) {
          return showToast<bool>(text: '删除成功', returnValue: true);
        } else {
          return showToast<bool>(text: '删除失败', returnValue: false);
        }
      } else if (popResult.popResultSelect == PopResultSelect.two) {
        return showToast<bool>(text: '选择修改名称', returnValue: true);
      }
      //
      else {
        throw 'unknown result: $popResult';
      }
    } catch (e, r) {
      dLog(() => '$e---$r');
      return showToast(text: 'err', returnValue: false);
    }
  }
}
