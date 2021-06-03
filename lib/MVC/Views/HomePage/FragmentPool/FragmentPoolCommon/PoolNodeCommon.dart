import 'dart:async';

import 'package:flutter/material.dart';
import 'package:jysp/Database/MergeModels/MMFragmentsAboutPoolNode.dart';
import 'package:jysp/Database/MergeModels/MMPoolNode.dart';
import 'package:jysp/Database/Models/MBase.dart';
import 'package:jysp/G/G.dart';
import 'package:jysp/MVC/Controllers/FragmentPoolController/FragmentPoolController.dart';
import 'package:jysp/MVC/Controllers/HomePageController.dart';
import 'package:jysp/MVC/Views/HomePage/FragmentPool/FragmentPoolCommon/NodeMoreCommon.dart';
import 'package:jysp/Tools/Helper.dart';
import 'package:jysp/Tools/SheetPage/SheetPage.dart';
import 'package:jysp/Tools/SheetPage/SheetPageController.dart';
import 'package:jysp/Tools/TDebug.dart';
import 'package:jysp/Tools/Toast/ShowToast.dart';
import 'package:provider/provider.dart';

class PoolNodeCommon extends StatefulWidget {
  /// [baseModel] 当前 model，供调用 base 方法。其他参数 base 可能没有对应方法
  const PoolNodeCommon({
    required this.poolType,
    required this.poolNodeMModel,
    required this.fragmentsTableName,
    required this.columns,
  });
  final PoolType poolType;
  final MMPoolNode poolNodeMModel;
  final String fragmentsTableName;
  final List<String> columns;

  @override
  PoolNodeCommonState createState() => PoolNodeCommonState();
}

class PoolNodeCommonState extends State<PoolNodeCommon> {
  ///

  Timer? _longPressTimer;
  bool _isLongPress = false;

  late final FragmentPoolController _thisFragmentPoolController;

  @override
  void initState() {
    super.initState();
    _thisFragmentPoolController = context.read<HomePageController>().getFragmentPoolController(widget.poolType);
  }

  @override
  Widget build(BuildContext context) {
    return _buildWidget();
  }

  Widget _buildWidget() {
    return Listener(
      onPointerDown: (_) {
        if (_.device > 0) {
          return;
        }

        _longPressTimer = Timer(const Duration(milliseconds: 1000), () {
          _isLongPress = true;
          _longPressStart();
        });
      },
      onPointerMove: (_) {
        if (_.device > 0) {
          return;
        }

        _longPressTimer?.cancel();
        if (_isLongPress) {
          _longPressMove();
        }
      },
      onPointerUp: (_) {
        dLog(() => 'up');
        if (_.device > 0) {
          return;
        }

        _longPressTimer?.cancel();

        if (_isLongPress) {
          _isLongPress = false;
          _longPressUp();
        }
        _thisFragmentPoolController.freeBoxController.disableTouch(false);
      },
      onPointerCancel: (_) {
        dLog(() => 'cancel');
        if (_.device > 0) {
          return;
        }

        _longPressTimer?.cancel();

        if (_isLongPress) {
          _isLongPress = false;
          _longPressCancel();
        }
        _thisFragmentPoolController.freeBoxController.disableTouch(false);
      },
      child: _body(),
    );
  }

  void _longPressStart() {
    dLog(() => '_longPressStart');
    _thisFragmentPoolController.freeBoxController.disableTouch(true);
    // showToastRoute(context, NodeLongPressMenuRoute(context, poolNodeMModel: widget.poolNodeMModel));
  }

  void _longPressMove() {
    dLog(() => '_longPressMove');
  }

  void _longPressUp() {
    dLog(() => '_longPressUp');
  }

  void _longPressCancel() {
    dLog(() => '_longPressCancel');
  }

  Widget _body() {
    return TextButton(
      child: Text(widget.poolNodeMModel.get_name ?? unknown),
      onPressed: () {
        Navigator.push(
          context,
          SheetPage<String, int>(
            sheetPageController: SheetPageController<String, int>(),
            bodyDataFuture: (List<String> bodyData, Mark<int> mark) async {
              try {
                await Future<void>.delayed(const Duration(seconds: 2));
                const int readCount = 10;
                mark.value ??= 0;

                await MBase.queryRowsAsModels<MBase, MMFragmentsAboutPoolNode, MMFragmentsAboutPoolNode>(
                  connectTransaction: null,
                  tableName: widget.fragmentsTableName,
                  columns: widget.columns, // 只获取该列
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
            },
            header: (SheetPageController<String, int> sheetPageController) {
              return SliverAppBar(
                primary: false,
                pinned: true,
                actions: <Widget>[
                  Container(
                    width: MediaQuery.of(context).size.width,
                    color: Colors.orange,
                    child: Row(
                      children: <Widget>[
                        Text('  节点：${widget.poolNodeMModel.get_name}'),
                        Expanded(child: Container()),
                        StatefulBuilder(
                          builder: (BuildContext btCtx, SetState setState) {
                            return TextButton(
                              child: const Icon(Icons.more_horiz),
                              onPressed: () {
                                showToastRoute(btCtx, NodeMoreCommon(btCtx));
                              },
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              );
            },
            body: (SheetPageController<String, int> sheetPageController) {
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
                            onPressed: () {},
                            child: Text(sheetPageController.bodyData[index].toString()),
                          ),
                        ),
                        StatefulBuilder(
                          builder: (BuildContext context, void Function(void Function()) rebuild) {
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
            },
          ),
        );
      },
      style: TextButton.styleFrom(
        primary: Colors.black,
        onSurface: Colors.orange,
        shadowColor: Colors.purple,
      ),
    );
  }
}
