// ignore_for_file: non_constant_identifier_names
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:jysp/Database/MergeModels/MMPoolNode.dart';
import 'package:jysp/Database/Models/MBase.dart';
import 'package:jysp/Database/Models/MPnCompletePoolNode.dart';
import 'package:jysp/Database/Models/MPnMemoryPoolNode.dart';
import 'package:jysp/Database/Models/MPnPendingPoolNode.dart';
import 'package:jysp/Database/Models/MPnRulePoolNode.dart';
import 'package:jysp/MVC/Controllers/FragmentPoolController/Enums.dart';
import 'package:jysp/Tools/FreeBox/FreeBoxController.dart';
import 'package:jysp/Tools/RebuildHandler.dart';
import 'package:jysp/Tools/TDebug.dart';

class FragmentPoolController extends ChangeNotifier {
  ///

  final FreeBoxController freeBoxController = FreeBoxController();

  /// 需要显示在池内的节点
  final List<MMPoolNode> pendingPoolNodes = <MMPoolNode>[];
  final List<MMPoolNode> memoryPoolNodes = <MMPoolNode>[];
  final List<MMPoolNode> completePoolNodes = <MMPoolNode>[];
  final List<MMPoolNode> rulePoolNodes = <MMPoolNode>[];

  /// 当前展现的碎片池类型
  /// 必须设置默认值：
  /// 1. 初始化时调用刷新布局函数需要获取这个默认值。
  /// 2. 初始化时 widget 需要显示这个默认的碎片池。
  PoolType _currentPoolType = PoolType.pendingPool;
  PoolType get getCurrentPoolType => _currentPoolType;
  set setCurrentPoolType(PoolType value) => _currentPoolType = value;

  /// 每个碎片池的视口位置和缩放, 以及对应池默认的视口位置
  /// 这里必须把子类型写清楚了, 不然会报错:"type 'Offset' is not a subtype of type 'String' of 'value'"
  Map<PoolType, Map<String, Object?>> viewSelectedType = <PoolType, Map<String, Object?>>{
    PoolType.pendingPool: <String, Object?>{'offset': null, 'scale': null, 'node0': Offset.zero},
    PoolType.memoryPool: <String, Object?>{'offset': null, 'scale': null, 'node0': Offset.zero},
    PoolType.completePool: <String, Object?>{'offset': null, 'scale': null, 'node0': Offset.zero},
    PoolType.rulePool: <String, Object?>{'offset': null, 'scale': null, 'node0': Offset.zero},
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

  /// 异步类型的选择。函数内没有 try catch。
  Future<T> poolTypeSwitchFuture<T>({
    PoolType? toPoolType,
    required Future<T> Function() pendingPoolCB,
    required Future<T> Function() memoryPoolCB,
    required Future<T> Function() completePoolCB,
    required Future<T> Function() rulePoolCB,
  }) async {
    final PoolType poolType = toPoolType ?? getCurrentPoolType;
    switch (poolType) {
      case PoolType.pendingPool:
        return await pendingPoolCB();
      case PoolType.memoryPool:
        return await memoryPoolCB();
      case PoolType.completePool:
        return await completePoolCB();
      case PoolType.rulePool:
        return await rulePoolCB();
      default:
        throw 'unknown poolType: $poolType';
    }
  }

  /// 非异步类型的选择。函数内没有 try catch。
  T poolTypeSwitch<T>({
    PoolType? toPoolType,
    required T Function() pendingPoolCB,
    required T Function() memoryPoolCB,
    required T Function() completePoolCB,
    required T Function() rulePoolCB,
  }) {
    final PoolType poolType = toPoolType ?? getCurrentPoolType;
    switch (poolType) {
      case PoolType.pendingPool:
        return pendingPoolCB();
      case PoolType.memoryPool:
        return memoryPoolCB();
      case PoolType.completePool:
        return completePoolCB();
      case PoolType.rulePool:
        return rulePoolCB();
      default:
        throw 'unknown poolType: $poolType';
    }
  }

  /// 对指定 nodes 统一操作：
  ///
  /// [toPoolType] 为 null 时为当前池类型
  ///
  /// <T>：若已知类型，则传入其类型
  List<MMPoolNode> getPoolTypeNodesList([PoolType? toPoolType]) {
    final PoolType poolType = toPoolType ?? getCurrentPoolType;
    return poolTypeSwitch<List<MMPoolNode>>(
      toPoolType: poolType,
      pendingPoolCB: () => pendingPoolNodes,
      memoryPoolCB: () => memoryPoolNodes,
      completePoolCB: () => completePoolNodes,
      rulePoolCB: () => rulePoolNodes,
    );
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
      dLog(() => 'toPool 并发');
      return;
    }
    _isToPooling = true;

    await Future<void>(() async {
      dLog(() => '正在获取 fragmentPoolNodes 数据，并进入${toPoolType.text}中...');

      // 打开加载屏障
      isLoadingBarrierRebuildHandler.rebuildHandle(LoadingBarrierHandlerEnum.enabled);

      // 获取数据：[toPoolType] 的数据
      final bool result = await retrievePoolNodes();

      switch (result) {
        case true:
          dLog(() => '获取 fragmentPoolNodes 数据成功。');
          toPoolTypeResult(0);
          isLoadingBarrierRebuildHandler.rebuildHandle(LoadingBarrierHandlerEnum.disabled);
          _isToPooling = false;
          _setCurrentPoolType(freeBoxController, toPoolType);
          // 根据结果重新刷新布局
          needInitStateForSetState(() {});
          break;
        case false:
          dLog(() => '获取 fragmentPoolNodes 数据失败。');
          toPoolTypeResult(1);
          isLoadingBarrierRebuildHandler.rebuildHandle(LoadingBarrierHandlerEnum.disabled);
          _isToPooling = false;
          break;
        default:
          dLog(() => 'result unknown');
          toPoolTypeResult(-1);
      }
    });
  }

  /// 设置当前碎片池的为指定池, 保存当前 offset/scale
  void _setCurrentPoolType(FreeBoxController freeBoxController, PoolType toPoolType) {
    viewSelectedType[getCurrentPoolType]!['offset'] = freeBoxController.offset;

    viewSelectedType[getCurrentPoolType]!['scale'] = freeBoxController.scale;

    setCurrentPoolType = toPoolType; // 必须放到设置 viewSelectedType 的后面
  }

  /// 读取当前池的全部节点
  Future<bool> retrievePoolNodes() async {
    try {
      // 虽然清除后再重新 addAll，但清除的是 MBase 数据，而 list widget 的 index 没有被重置，因此 clear data 后仍保持相同的 state
      getPoolTypeNodesList().clear();
      final List<MMPoolNode> mmnodes = await poolTypeSwitchFuture<List<MMPoolNode>>(
        pendingPoolCB: () async {
          final List<MMPoolNode> mmodels = await MBase.queryRowsAsModels<MPnPendingPoolNode, MMPoolNode, MMPoolNode>(
            tableName: MPnPendingPoolNode.tableName,
            returnMWhere: null,
            returnMMWhere: (MPnPendingPoolNode model) => MMPoolNode(model: model),
            connectTransaction: null,
          );
          return mmodels;
        },
        memoryPoolCB: () async {
          final List<MMPoolNode> mmodels = await MBase.queryRowsAsModels<MPnMemoryPoolNode, MMPoolNode, MMPoolNode>(
            tableName: MPnMemoryPoolNode.tableName,
            connectTransaction: null,
            returnMWhere: null,
            returnMMWhere: (MPnMemoryPoolNode model) => MMPoolNode(model: model),
          );
          return mmodels;
        },
        completePoolCB: () async {
          final List<MMPoolNode> mmodels = await MBase.queryRowsAsModels<MPnCompletePoolNode, MMPoolNode, MMPoolNode>(
            tableName: MPnCompletePoolNode.tableName,
            connectTransaction: null,
            returnMWhere: null,
            returnMMWhere: (MPnCompletePoolNode model) => MMPoolNode(model: model),
          );
          return mmodels;
        },
        rulePoolCB: () async {
          final List<MMPoolNode> mmodels = await MBase.queryRowsAsModels<MPnRulePoolNode, MMPoolNode, MMPoolNode>(
            tableName: MPnRulePoolNode.tableName,
            connectTransaction: null,
            returnMWhere: null,
            returnMMWhere: (MPnRulePoolNode model) => MMPoolNode(model: model),
          );
          return mmodels;
        },
      );
      getPoolTypeNodesList().addAll(mmnodes);
      return true;
    } catch (e) {
      dLog(() => 'retrievePoolNodes err: ', () => e);
      return false;
    }
  }

  ///
}
