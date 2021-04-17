// ignore_for_file: non_constant_identifier_names
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:jysp/Database/models/MPnCompletePoolNode.dart';
import 'package:jysp/Database/models/MPnMemoryPoolNode.dart';
import 'package:jysp/Database/models/MPnPendingPoolNode.dart';
import 'package:jysp/Database/models/MPnRulePoolNode.dart';
import 'package:jysp/MVC/Controllers/FragmentPoolController/Enums.dart';
import 'package:jysp/MVC/Models/FragmentPoolRequest/GetPoolNodesRequest.dart';
import 'package:jysp/Tools/FreeBox/FreeBoxController.dart';
import 'package:jysp/Tools/RebuildHandler.dart';
import 'package:jysp/Tools/TDebug.dart';

class FragmentPoolController extends ChangeNotifier {
  ///

  /// 需要显示在池内的节点
  final List<MPnPendingPoolNode> pendingPoolNodes = [];
  final List<MPnMemoryPoolNode> memoryPoolNodes = [];
  final List<MPnCompletePoolNode> completePoolNodes = [];
  final List<MPnRulePoolNode> rulePoolNodes = [];

  /// 当前展现的碎片池类型
  /// 必须设置默认值：
  /// 1. 初始化时调用刷新布局函数需要获取这个默认值。
  /// 2. 初始化时 widget 需要显示这个默认的碎片池。
  PoolType _currentPoolType = PoolType.pendingPool;
  PoolType get getCurrentPoolType => _currentPoolType;
  set setCurrentPoolType(PoolType value) => _currentPoolType = value;

  /// 每个碎片池的视口位置和缩放, 以及对应池默认的视口位置
  /// 这里必须把子类型写清楚了, 不然会报错:"type 'Offset' is not a subtype of type 'String' of 'value'"
  Map<PoolType, Map<String, dynamic>> viewSelectedType = {
    PoolType.pendingPool: {"offset": null, "scale": null, "node0": Offset.zero},
    PoolType.memoryPool: {"offset": null, "scale": null, "node0": Offset.zero},
    PoolType.completePool: {"offset": null, "scale": null, "node0": Offset.zero},
    PoolType.rulePool: {"offset": null, "scale": null, "node0": Offset.zero},
  };

  /// [FragmentPool] 是否正在初始化状态
  bool needInitStateForIsIniting = false;

  /// [FragmentPool] 的 setState 函数
  Function(Function()) needInitStateForSetState = (_) {};

  ///
  /// 是否弹出加载屏障
  RebuildHandler<LoadingBarrierHandlerEnum> isLoadingBarrierRebuildHandler = RebuildHandler<LoadingBarrierHandlerEnum>();

  /// 是否处于 toPooling
  bool _isToPooling = false;

  /// 添加节点
  void addNode(Offset boxPosition) {
    switch (_currentPoolType) {
      case PoolType.pendingPool:
        pendingPoolNodes.add(
          MPnPendingPoolNode.createModel(
            pn_pending_pool_node_id_v: null,
            pn_pending_pool_node_uuid_v: null,
            recommend_raw_rule_id_v: null,
            recommend_raw_rule_uuid_v: null,
            type_v: null,
            name_v: null,
            position_v: "${boxPosition.dx.toString()},${boxPosition.dy.toString()}",
            created_at_v: null,
            updated_at_v: null,
            curd_status_v: null,
          ),
        );
        needInitStateForSetState(() {});
        break;
      default:
    }
  }

  ///
  ///
  ///
  /// 将进入指定碎片池
  ///
  /// - [freeBoxController]：用来设置相机位置。
  /// - [toPoolType]：将要进入池的类型。
  /// - [toPoolTypeResult]：跳转至指定 type of pool 成功与失败。
  ///   - [resultCode]：
  ///     - 回调带 0：获取数据失败，不跳转到对应的 type；
  ///     - 回调带 1：获取数据成功，自动跳转到对应的 type；
  ///     - 回调带 -1：toPool 并发,，不跳转到对应的 type。
  ///
  /// 先获取数据后，才会调用 [toPoolTypeResult] 回调，最后才刷新碎片池
  ///
  Future<void> toPool({
    required FreeBoxController freeBoxController,
    required PoolType toPoolType,
    required Function(int resultCode) toPoolTypeResult,
  }) async {
    if (_isToPooling) {
      toPoolTypeResult(-1);
      dLog(() => "toPool 并发");
      return;
    }
    _isToPooling = true;

    await Future(() async {
      dLog(() => "正在获取 fragmentPoolNodes 数据，并进入${toPoolType.text}中...");

      // 打开加载屏障
      isLoadingBarrierRebuildHandler.rebuildHandle(LoadingBarrierHandlerEnum.enabled);

      // 获取数据：[toPoolType] 的数据
      bool result = await GetPoolNodesRequest().getPoolNodes(this, toPoolType);

      switch (result) {
        case true:
          dLog(() => "获取 fragmentPoolNodes 数据成功。");
          toPoolTypeResult(0);
          isLoadingBarrierRebuildHandler.rebuildHandle(LoadingBarrierHandlerEnum.disabled);
          _isToPooling = false;
          _setCurrentPoolType(freeBoxController, toPoolType);
          // 根据结果重新刷新布局
          needInitStateForSetState(() {});
          break;
        case false:
          dLog(() => "获取 fragmentPoolNodes 数据失败。");
          toPoolTypeResult(1);
          isLoadingBarrierRebuildHandler.rebuildHandle(LoadingBarrierHandlerEnum.disabled);
          _isToPooling = false;
          break;
        default:
          dLog(() => "result unknown");
          toPoolTypeResult(-1);
      }
    });
  }

  /// 设置当前碎片池的为指定池, 保存当前 offset/scale
  void _setCurrentPoolType(FreeBoxController freeBoxController, PoolType toPoolType) {
    viewSelectedType[getCurrentPoolType]!["offset"] = freeBoxController.offset;

    viewSelectedType[getCurrentPoolType]!["scale"] = freeBoxController.scale;

    setCurrentPoolType = toPoolType; // 必须放到设置 viewSelectedType 的后面
  }

  ///
}
