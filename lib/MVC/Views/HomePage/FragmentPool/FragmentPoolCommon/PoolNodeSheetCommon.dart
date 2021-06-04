import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:jysp/Database/MergeModels/MMFragmentsAboutPoolNode.dart';
import 'package:jysp/Database/MergeModels/MMPoolNode.dart';
import 'package:jysp/Database/Models/MBase.dart';
import 'package:jysp/MVC/Views/HomePage/FragmentPool/FragmentPoolCommon/FragmentPoolToastRouteCommons/NodeMoreCommon.dart';
import 'package:jysp/Tools/Helper.dart';
import 'package:jysp/Tools/SheetPage/SheetPage.dart';
import 'package:jysp/Tools/SheetPage/SheetPageController.dart';
import 'package:jysp/Tools/TDebug.dart';
import 'package:jysp/Tools/Toast/ShowToast.dart';

/// TODO: 暂时 <String,int>，可以将前面的 String 新创建的 XXX 类对象，即替换成 <XXX,int>
class PoolNodeSheetCommon extends SheetPage<String, int> {
  ///
  PoolNodeSheetCommon({
    required this.poolNodeMModel,
    required this.fragmentsTableName,
    required this.columns,
  });

  /// poolNode 的 mmodel
  final MMPoolNode poolNodeMModel;

  /// 当前碎片池的碎片对应的表名
  final String fragmentsTableName;

  /// 需要用到的 column 名
  final List<String> columns;

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
                builder: (BuildContext btCtx, SetState setState) {
                  return TextButton(
                    child: const Icon(Icons.more_horiz),
                    onPressed: () {
                      showToastRoute(btCtx, NodeMoreCommon(btCtx, mmodel: poolNodeMModel));
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
  Future<BodyDataFutureResult> bodyDataFuture(List<String> bodyData, Mark<int> mark) async {
    try {
      await Future<void>.delayed(const Duration(seconds: 2));
      const int readCount = 10;
      mark.value ??= 0;

      await MBase.queryRowsAsModels<MBase, MMFragmentsAboutPoolNode, MMFragmentsAboutPoolNode>(
        connectTransaction: null,
        tableName: fragmentsTableName,
        columns: columns,
        limit: readCount,
        offset: mark.value,
        returnMWhere: null,
        returnMMWhere: (MBase model) {
          final MMFragmentsAboutPoolNode mmFragmentsAboutPoolNode = MMFragmentsAboutPoolNode(model: model);
          bodyData.add(mmFragmentsAboutPoolNode.get_title ?? 'unknown');
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
          bool isCheck = false;
          return Row(
            children: <Widget>[
              Expanded(
                child: TextButton(
                  style: TextButton.styleFrom(
                    padding: const EdgeInsets.all(0),
                    backgroundColor: Colors.purple,
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                  child: Text(sheetPageController.bodyData[index].toString()),
                  onPressed: () {},
                ),
              ),
              StatefulBuilder(
                builder: (BuildContext context, SetState rebuild) {
                  return Checkbox(
                    value: isCheck,
                    onChanged: (bool? check) {
                      isCheck = !isCheck;
                      rebuild(() {});
                    },
                  );
                },
              ),
            ],
          );
        },
        childCount: sheetPageController.bodyData.length,
      ),
    );
  }

  ///
}
