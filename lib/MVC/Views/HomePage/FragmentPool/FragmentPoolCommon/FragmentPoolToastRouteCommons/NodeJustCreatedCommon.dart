import 'package:flutter/material.dart';
import 'package:jysp/Database/MergeModels/MMPoolNode.dart';
import 'package:jysp/Database/Models/MBase.dart';
import 'package:jysp/MVC/Controllers/FragmentPoolController/FragmentPoolController.dart';
import 'package:jysp/MVC/Controllers/HomePageController.dart';
import 'package:jysp/MVC/Request/Sqlite/RSqliteCurd.dart';
import 'package:jysp/Tools/TDebug.dart';
import 'package:jysp/Tools/Toast/ShowToast.dart';
import 'package:jysp/Tools/Toast/ToastRoute.dart';
import 'package:provider/provider.dart';

class NodeJustCreatedCommon extends ToastRoute {
  NodeJustCreatedCommon(
    BuildContext fatherContext, {
    required this.poolType,
    required this.screenPosition,
    required this.newNodeModelCallback,
  }) : super(fatherContext);

  @override
  Color get backgroundColor => Colors.black;

  @override
  double get backgroundOpacity => 0.5;

  final PoolType poolType;

  /// 将要把输入框放在屏幕 left 多远的地方
  final Offset screenPosition;

  /// 新节点模型
  MBase Function(Offset boxPosition, String name) newNodeModelCallback;

  /// 输入控制器
  final TextEditingController _txtEditingController = TextEditingController();

  /// 键盘有关
  final FocusNode _focusNode = FocusNode();

  /// 当前碎片池
  late final FragmentPoolController _fragmentPoolController;

  @override
  void init() {
    _fragmentPoolController = fatherContext.read<HomePageController>().getFragmentPoolController(poolType);
  }

  @override
  void rebuild() {
    // 自动升起键盘
    FocusScope.of(context).requestFocus(_focusNode);
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  List<Positioned> body() {
    return <Positioned>[
      _input(),
    ];
  }

  /// 输入框
  Positioned _input() {
    return Positioned(
      top: screenPosition.dy,
      left: screenPosition.dx,
      child: Container(
        width: 100,
        color: Colors.white,
        child: TextField(
          focusNode: _focusNode,
          controller: _txtEditingController,
          onEditingComplete: () {
            // 不仅返回时执行 future ，点击键盘的提交按钮时也 pop->future
            Navigator.pop(context, null);
          },
        ),
      ),
    );
  }

  @override
  Future<Toast<bool>> Function(PopResult? popResult) get whenPop {
    return (PopResult? result) async {
      try {
        if (result == null) {
          await _toInsert();
          return showToast(text: '创建成功', returnValue: true);
        } else if (result.popResultSelect == PopResultSelect.clickBackground) {
          return showToast(text: '已取消', returnValue: true);
        } else {
          throw 'result err: $result';
        }
      } catch (e, r) {
        dLog(() => '$e\n$r');
        return showToast(text: '创建失败', returnValue: false);
      }
    };
  }

  Future<void> _toInsert() async {
    // 若输入为空，则不进行插入
    if (_txtEditingController.text == '') {
      dLog(() => 'text: ', () => _txtEditingController.text);
      return;
    }

    // 若输入不为空，才进行插入
    await Future<void>.delayed(const Duration(seconds: 1));
    dLog(() => 'text: ', () => _txtEditingController.text);

    final bool result = await insertNewNode();

    // 插入成功。插入失败不进行任何操作
    if (result) {
      _fragmentPoolController.poolNodesSetState!(() {});
    }
  }

  /// 在当前池内插入新节点
  Future<bool> insertNewNode() async {
    final String name = _txtEditingController.text;
    try {
      final MBase newNodeModel = newNodeModelCallback(_fragmentPoolController.freeBoxController.screenToBoxTransform(screenPosition), name);

      // 插入 new node
      final MBase? insertReuslt = await RSqliteCurd<MBase>.byModel(newNodeModel).toInsertRow(connectTransaction: null);

      // 让 state 变化
      if (insertReuslt != null) {
        // 不能把 newNodeModel 插入，而是把 insertReuslt 插入，因为前者没有 id
        _fragmentPoolController.poolNodes.add(MMPoolNode(model: insertReuslt));
        return true;
      }

      return false;
    } catch (e, r) {
      dLog(() => 'createNewNode err: $e+$r');
      return false;
    }
  }
}
