// ignore_for_file: non_constant_identifier_names
import 'dart:convert';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:jysp/Database/both/TFragmentPoolNode.dart';
import 'package:jysp/LWCR/Controller/FreeBoxController.dart';
import 'package:jysp/LWCR/Request/FragmentPoolRequest/LayoutNodesRequest.dart';
import 'package:jysp/Tools/RebuildHandler.dart';
import 'package:jysp/Tools/TDebug.dart';

enum OutType {
  id_exception,
  id_repeat,
  pool_type,
  node_type,
  name,
  position,
}

///
///
/// 扩展方法:
///
/// 方便直接 ".xxx"进行调用
///
/// 会把 enum int 类型全部转化成 enum 类型
///
class FragmentPoolNode {
  FragmentPoolNode(this.map);
  Map map;

  int get fragment_pool_node_id => this.map[TFragmentPoolNode.fragment_pool_node_id];
  String get fragment_pool_node_id_s => this.map[TFragmentPoolNode.fragment_pool_node_id_s];
  String get name => this.map[TFragmentPoolNode.name];
  NodeType get node_type => NodeType.values[this.map[TFragmentPoolNode.node_type]];
  PoolType get pool_type => PoolType.values[this.map[TFragmentPoolNode.pool_type]];
  List<double> get position {
    List<String> split = (this.map[TFragmentPoolNode.position] as String).split(",");
    return [double.parse(split[0]), double.parse(split[1])];
  }

  int get created_at => this.map[TFragmentPoolNode.created_at];
  int get updated_at => this.map[TFragmentPoolNode.updated_at];

  OutType get out_type => OutType.values[this.map["out_type"]];
}

extension MapExtension on Map {
  FragmentPoolNode get fragmentPoolNode => FragmentPoolNode(this);
  FragmentPoolNode get fragmentPoolNodeOut => FragmentPoolNode(this);
}

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

  ///
  /// 将无效的数据转化为有效数据，供扩展方法使用
  ///
  /// 读写的 enum 为 int 类型
  ///
  /// - [setCallbak] 要如何对 fragmentPoolNodes 进行设置
  ///
  /// - [toPool] 将要进入的碎片池类型
  ///
  bool setFragmentPoolNodes(Function(List<Map> nodes) setCallbak, PoolType toPool) {
    // 若报了异常，可以恢复原来数据
    List<Map> fragmentPoolNodesTemp = (jsonDecode(jsonEncode(fragmentPoolNodes)) as List).cast<Map>();
    List<Map> fragmentPoolNodeOutsTemp = (jsonDecode(jsonEncode(fragmentPoolNodeOuts)) as List).cast<Map>();
    fragmentPoolNodeOuts.clear();

    try {
      setCallbak(fragmentPoolNodes);

      // 移除重复的。直接移除，无需放到
      fragmentPoolNodes.removeWhere(
        (elementOut) {
          // 是否被标记为重复，重复则移除
          if (elementOut["repeat"] != null) {
            return true;
          }
          fragmentPoolNodes.forEach(
            (element) {
              // 把相同地址的排除掉
              if (elementOut != element) {
                if (elementOut[TFragmentPoolNode.fragment_pool_node_id] != null && element[TFragmentPoolNode.fragment_pool_node_id] != null) {
                  if (elementOut[TFragmentPoolNode.fragment_pool_node_id] == element[TFragmentPoolNode.fragment_pool_node_id]) {
                    element["repeat"] = true;
                    return;
                  }
                }
                if (elementOut[TFragmentPoolNode.fragment_pool_node_id_s] != null && element[TFragmentPoolNode.fragment_pool_node_id_s] != null) {
                  if (elementOut[TFragmentPoolNode.fragment_pool_node_id_s] == element[TFragmentPoolNode.fragment_pool_node_id_s]) {
                    element["repeat"] = true;
                    return;
                  }
                }
              }
            },
          );
          return false;
        },
      );

      // 检查异常的
      fragmentPoolNodes.removeWhere(
        (element) {
          // id
          // 待重新获取或重新生成 id_s 写入
          if (element[TFragmentPoolNode.fragment_pool_node_id] == null && element[TFragmentPoolNode.fragment_pool_node_id_s] == null) {
            element["out_type"] = OutType.id_exception.index;
            fragmentPoolNodeOuts.add(element);
            return true;
          }
          // pool_type
          // 直接移除
          if (element[TFragmentPoolNode.pool_type] != toPool.index) {
            return true;
          }
          // node_type
          // 待重新获取或重新写入
          if (!(element[TFragmentPoolNode.node_type] is int) || element[TFragmentPoolNode.node_type] >= NodeType.values.length) {
            element["out_type"] = OutType.node_type.index;
            fragmentPoolNodeOuts.add(element);
            return true;
          }
          // name
          // 待重新获取或重新写入
          if (!(element[TFragmentPoolNode.name] is String)) {
            element["out_type"] = OutType.name.index;
            fragmentPoolNodeOuts.add(element);
            return true;
          }
          // position
          // 待重新获取或重新写入
          if (!(element[TFragmentPoolNode.position] is String) || !(RegExp(r"[0-9]+,[0-9]+").hasMatch(element[TFragmentPoolNode.position]))) {
            element["out_type"] = OutType.position.index;
            fragmentPoolNodeOuts.add(element);
            return true;
          }
          // created_at
          // 直接设置为 0
          if (!(element[TFragmentPoolNode.created_at] is int)) {
            element[TFragmentPoolNode.created_at] = 0;
          }
          // updated_at
          // 直接设置为 0
          if (!(element[TFragmentPoolNode.updated_at] is int)) {
            element[TFragmentPoolNode.updated_at] = 0;
          }
          return false;
        },
      );

      // 若 fragmentPoolNodes 为空数组，则需要一个 widget 进行提示
      if (fragmentPoolNodes.isEmpty) {
        fragmentPoolNodes.add(_nullFragmentPoolNodesMap(toPool));
      }

      dLog(() => "setFragmentPoolNodes 完成：", () => {"fragmentPoolNodes": fragmentPoolNodes, "fragmentPoolNodeOuts": fragmentPoolNodeOuts});
      return true;
    } catch (e) {
      // 恢复到原来的
      fragmentPoolNodes.clear();
      fragmentPoolNodeOuts.clear();
      fragmentPoolNodes.addAll(fragmentPoolNodesTemp);
      fragmentPoolNodes.addAll(fragmentPoolNodeOutsTemp);

      dLog(() => "setFragmentPoolNodes 失败：", () => e);
      return false;
    }
  }

  Map _nullFragmentPoolNodesMap(PoolType toPool) => {
        TFragmentPoolNode.fragment_pool_node_id: "0",
        TFragmentPoolNode.fragment_pool_node_id_s: "0",
        TFragmentPoolNode.pool_type: toPool.index,
        TFragmentPoolNode.node_type: NodeType.root.index,
        TFragmentPoolNode.name: "无数据",
        TFragmentPoolNode.position: "0,0",
        TFragmentPoolNode.created_at: 0,
        TFragmentPoolNode.updated_at: 0,
      };

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

  Function rebuild = () {};

  bool isIniting = false;

  ///
}

mixin _ToPool on LayoutNodesRequest {
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
      bool? result = await layoutNodesRequest(toPoolType);

      switch (result) {
        case true:
          dLog(() => "获取 fragmentPoolNodes 数据成功。");
          toPoolTypeResult(0);
          isLoadingBarrierRebuildHandler.rebuildHandle(LoadingBarrierHandlerEnum.disabled);
          _isToPooling = false;
          _setView(freeBoxController, toPoolType);
          // 根据结果重新刷新布局
          rebuild();
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

class FragmentPoolController extends _Init with FragmentPoolControllerRoot, LayoutNodesRequest, _ToPool {}
