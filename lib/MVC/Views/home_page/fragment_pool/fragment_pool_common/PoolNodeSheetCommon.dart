import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:jysp/database/merge_models/MMFragmentsAboutPoolNode.dart';
import 'package:jysp/database/merge_models/MMPoolNode.dart';
import 'package:jysp/database/models/MBase.dart';
import 'package:jysp/mvc/views/home_page/fragment_pool/fragment_pool_common/fragment_pool_toast_route_commons/NodeMoreCommon.dart';
import 'package:jysp/tools/Helper.dart';
import 'package:jysp/tools/TDebug.dart';
import 'package:jysp/tools/sheet_page/SheetPage.dart';
import 'package:jysp/tools/sheet_page/SheetPageController.dart';
import 'package:jysp/tools/toast/ShowToast.dart';

/// TODO: 暂时 <String,int>，可以将前面的 String 新创建的 XXX 类对象，即替换成 <XXX,int>
class PoolNodeSheetCommon extends SheetPage<MMFragmentsAboutPoolNode, int> {
  ///
  PoolNodeSheetCommon({
    required this.poolNodeMModel,
    required this.fragmentsForeignKeyNameAIIDForNode,
    required this.fragmentsForeignKeyNameUUIDForNode,
    required this.fragmentsTableName,
    required this.columns,
    required this.buttonsBuilder,
  });

  /// poolNode 节点的 mmodel
  final MMPoolNode poolNodeMModel;

  /// 当前碎片池的碎片表对应的节点外键名
  final String fragmentsForeignKeyNameAIIDForNode;

  /// 当前碎片池的碎片表对应的节点外键名
  final String fragmentsForeignKeyNameUUIDForNode;

  /// 当前碎片池的碎片表名
  final String fragmentsTableName;

  /// 需要用到的 column 名
  final List<String> columns;

  /// 当前 sheet 的每个元素
  ///
  /// 任意 Widget
  final Widget Function(MMFragmentsAboutPoolNode bodyDataElement, BuildContext btnContext, SetState btnSetState) buttonsBuilder;

  @override
  Widget header() {
    return SliverAppBar(
      primary: false,
      pinned: true,
      actions: <Widget>[
        Container(
          width: MediaQueryData.fromWindow(window).size.width,
          color: Colors.orange,
          child: Row(
            children: <Widget>[
              Text('  节点：${poolNodeMModel.get_name}'),
              Expanded(child: Container()),
              StatefulBuilder(
                builder: (BuildContext btnCtx, SetState btnSetState) {
                  return TextButton(
                    child: const Icon(Icons.more_horiz),
                    onPressed: () {
                      showToastRoute(btnCtx, NodeMoreCommon(btnCtx, mmodel: poolNodeMModel));
                    },
                  );
                },
              ),
            ],
          ),
        ),
      ],
    );
  }

  @override
  Future<BodyDataFutureResult> bodyDataFuture(List<MMFragmentsAboutPoolNode> bodyData, Mark<int> mark) async {
    try {
      await Future<void>.delayed(const Duration(seconds: 2));
      const int readCount = 10;
      mark.value ??= 0;

      late String where;
      late List<Object?> whereArgs;
      if ((poolNodeMModel.get_aiid == null && poolNodeMModel.get_uuid == null) || (poolNodeMModel.get_aiid != null && poolNodeMModel.get_uuid != null)) {
        throw 'poolNodeMModel.get_aiid == ${poolNodeMModel.get_aiid} and poolNodeMModel.get_uuid == ${poolNodeMModel.get_uuid}';
      } else {
        if (poolNodeMModel.get_aiid != null) {
          where = '$fragmentsForeignKeyNameAIIDForNode = ?';
          whereArgs = <int>[poolNodeMModel.get_aiid!];
        } else {
          where = '$fragmentsForeignKeyNameUUIDForNode = ?';
          whereArgs = <String>[poolNodeMModel.get_uuid!];
        }
      }

      /// 这里因为 sheet 元素只需获取标题等字段，无需获取元素全部的字段，因此若之后想要获取全部字段，需要再次查询。
      await MBase.queryRowsAsModels<MBase, MMFragmentsAboutPoolNode, MMFragmentsAboutPoolNode>(
        connectTransaction: null,
        tableName: fragmentsTableName,
        where: where,
        whereArgs: whereArgs,
        columns: columns,
        limit: readCount,
        offset: mark.value,
        returnMWhere: null,
        returnMMWhere: (MBase model) {
          final MMFragmentsAboutPoolNode mmFragmentsAboutPoolNode = MMFragmentsAboutPoolNode(model: model);
          bodyData.add(mmFragmentsAboutPoolNode);
          return mmFragmentsAboutPoolNode;
        }, // 会从 mark.value + 1 的 index 开始
      );

      // 全部成功后才能对其增值
      // 当第一次取 0-10 个时, 下一次取 11-20 个、
      mark.value = mark.value! + readCount;
      return BodyDataFutureResult.success;
    } catch (e, r) {
      dLog(() => e.toString() + '----' + r.toString());
      return BodyDataFutureResult.fail;
    }
  }

  @override
  Widget body() {
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (_, int index) {
          return StatefulBuilder(
            builder: (BuildContext context, SetState btnSetState) {
              return buttonsBuilder(sheetPageController.bodyData[index], context, btnSetState);
            },
          );
        },
        childCount: sheetPageController.bodyData.length,
      ),
    );
  }

  ///
}
