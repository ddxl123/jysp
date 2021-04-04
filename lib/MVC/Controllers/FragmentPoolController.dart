// ignore_for_file: non_constant_identifier_names
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:jysp/FragmentPool/FragmentPoolEnum.dart';
import 'package:jysp/Plugin/FreeBox/FreeBoxController.dart';
import 'package:jysp/Tools/RebuildHandler.dart';
import 'package:jysp/Tools/TDebug.dart';

///
///
///
class _Init extends ChangeNotifier {}

mixin FragmentPoolControllerRoot on _Init {
  ///

  /// 需要显示在池内的节点
  // 标准格式：同 [TFragmentPoolNode] 表结构
  final List<Map> fragmentPoolNodes = [];

  /// 重复的、没有 father 的、branch=null 的节点
  // 标准格式：同 [fragmentPoolNodes] 结构，且格外 key="out_type"
  List<Map> fragmentPoolNodeOuts = [];

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
    PoolType.wikiPool: {"offset": null, "scale": null, "node0": Offset.zero},
  };

  bool isIniting = false;

  bool doRebuild = false;

  ///
}

mixin _ToPool on FragmentPoolControllerRoot {
  ///

  /// 是否弹出加载屏障
  RebuildHandler<LoadingBarrierHandlerEnum> isLoadingBarrierRebuildHandler = RebuildHandler<LoadingBarrierHandlerEnum>();

  /// 是否处于 toPooling
  bool _isToPooling = false;

  ///
  ///
  ///
  /// 将进入指定碎片池
  ///
  /// 每次刷新碎片池时, 需先获取每个 node 的布局宽高, 因此碎片池 widget 需要被 build 2次
  ///
  /// - [freeBoxController]：需要用来 setView()。
  /// - [toPoolType]：将要进入池的类型。
  /// - [toPoolTypeResult]：跳转至指定 type of pool 成功与失败。
  ///   - [resultCode]：
  ///     - 回调带 0：获取数据失败，不跳转到对应的 type
  ///     - 回调带 1：获取数据成功，自动跳转到对应的 type
  ///     - 回调带 -1：不跳转到对应的 type。Ⅰ. toPool 并发。
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
      // bool? result = await layoutNodesRequest(toPoolType);
      bool? result;

      switch (result) {
        case true:
          dLog(() => "获取 fragmentPoolNodes 数据成功。");
          toPoolTypeResult(0);
          isLoadingBarrierRebuildHandler.rebuildHandle(LoadingBarrierHandlerEnum.disabled);
          _isToPooling = false;
          _setView(freeBoxController, toPoolType);
          // 根据结果重新刷新布局
          doRebuild = !doRebuild;
          notifyListeners();
          break;
        case false:
          dLog(() => "获取 fragmentPoolNodes 数据失败。");
          toPoolTypeResult(1);
          isLoadingBarrierRebuildHandler.rebuildHandle(LoadingBarrierHandlerEnum.disabled);
          _isToPooling = false;
          break;
        default:
          dLog(() => "获取 fragmentPoolNodes 数据成功，但被中断。");
          toPoolTypeResult(-1);
      }
    });
  }

  /// 保存当前 offset/scale , 并设置当前碎片池的为指定池
  void _setView(FreeBoxController freeBoxController, PoolType toPoolType) {
    viewSelectedType[getCurrentPoolType]!["offset"] = freeBoxController.offset;

    viewSelectedType[getCurrentPoolType]!["scale"] = freeBoxController.scale;

    setCurrentPoolType = toPoolType; // 必须放到设置 viewSelectedType 的后面
  }

  ///
}

class FragmentPoolController extends _Init with FragmentPoolControllerRoot, _ToPool {}
