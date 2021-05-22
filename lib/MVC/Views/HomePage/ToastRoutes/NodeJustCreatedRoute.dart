import 'package:flutter/material.dart';
import 'package:jysp/Database/MergeModels/MMFragmentPoolNode.dart';
import 'package:jysp/Database/Models/MBase.dart';
import 'package:jysp/Database/Models/MPnCompletePoolNode.dart';
import 'package:jysp/Database/Models/MPnMemoryPoolNode.dart';
import 'package:jysp/Database/Models/MPnPendingPoolNode.dart';
import 'package:jysp/Database/Models/MPnRulePoolNode.dart';
import 'package:jysp/MVC/Controllers/FragmentPoolController/FragmentPoolController.dart';
import 'package:jysp/MVC/Request/Sqlite/RSqliteCurd.dart';
import 'package:jysp/Tools/TDebug.dart';
import 'package:jysp/Tools/Toast/ShowToast.dart';
import 'package:jysp/Tools/Toast/Toast.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

class NodeJustCreatedRoute extends ToastRoute {
  NodeJustCreatedRoute(BuildContext fatherContext, {required this.screenPosition}) : super(fatherContext);

  /// 将要把输入框放在屏幕 left 多远的地方
  final Offset screenPosition;

  @override
  AlignmentDirectional get stackAlignment => AlignmentDirectional.topStart;

  /// 输入控制器
  final TextEditingController _txtEditingController = TextEditingController();

  /// 键盘有关
  final FocusNode _focusNode = FocusNode();

  @override
  void init() {}

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
            Navigator.pop(context);
          },
        ),
      ),
    );
  }

  @override
  Future<Toast<bool>> Function(int?) get whenPop {
    return (int? result) async {
      try {
        if (result == null) {
          await _toInsert();
          return showToast(text: '创建成功', returnValue: true);
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
      fatherContext.read<FragmentPoolController>().needInitStateForSetState(() {});
    }
  }

  /// 在当前池内插入新节点
  Future<bool> insertNewNode() async {
    final String name = _txtEditingController.text;
    final Offset position = fatherContext.read<FragmentPoolController>().freeBoxController.screenToBoxTransform(screenPosition);
    try {
      final MBase newNodeModel = fatherContext.read<FragmentPoolController>().poolTypeSwitch<MBase>(
            pendingPoolCB: () => MPnPendingPoolNode.createModel(
              aiid_v: null,
              uuid_v: const Uuid().v4(),
              recommend_raw_rule_aiid_v: null,
              recommend_raw_rule_uuid_v: null,
              type_v: PendingPoolNodeType.ordinary,
              name_v: name,
              position_v: '${position.dx},${position.dy}',
              created_at_v: DateTime.now().millisecondsSinceEpoch,
              updated_at_v: DateTime.now().millisecondsSinceEpoch,
            ),
            memoryPoolCB: () => MPnMemoryPoolNode.createModel(
              aiid_v: null,
              uuid_v: const Uuid().v4(),
              using_raw_rule_aiid_v: null,
              using_raw_rule_uuid_v: null,
              type_v: MemoryPoolNodeType.ordinary,
              name_v: name,
              position_v: '${position.dx},${position.dy}',
              created_at_v: DateTime.now().millisecondsSinceEpoch,
              updated_at_v: DateTime.now().millisecondsSinceEpoch,
            ),
            completePoolCB: () => MPnCompletePoolNode.createModel(
              aiid_v: null,
              uuid_v: const Uuid().v4(),
              used_raw_rule_aiid_v: null,
              used_raw_rule_uuid_v: null,
              type_v: CompletePoolNodeType.ordinary,
              name_v: name,
              position_v: '${position.dx},${position.dy}',
              created_at_v: DateTime.now().millisecondsSinceEpoch,
              updated_at_v: DateTime.now().millisecondsSinceEpoch,
            ),
            rulePoolCB: () => MPnRulePoolNode.createModel(
              aiid_v: null,
              uuid_v: const Uuid().v4(),
              type_v: RulePoolNodeType.ordinary,
              name_v: name,
              position_v: '${position.dx},${position.dy}',
              created_at_v: DateTime.now().millisecondsSinceEpoch,
              updated_at_v: DateTime.now().millisecondsSinceEpoch,
            ),
          );

      // 插入 new node
      final MBase? insertReuslt = await RSqliteCurd<MBase>.byModel(newNodeModel).toInsertRow(connectTransaction: null);

      // 让 state 变化
      if (insertReuslt != null) {
        // 不能把 newNodeModel 插入，而是把 insertReuslt 插入，因为前者没有 id
        fatherContext.read<FragmentPoolController>().getPoolTypeNodesList().add(MMFragmentPoolNode(model: insertReuslt));
        return true;
      }

      return false;
    } catch (e, r) {
      dLog(() => 'createNewNode err: $e+$r');
      return false;
    }
  }
}
