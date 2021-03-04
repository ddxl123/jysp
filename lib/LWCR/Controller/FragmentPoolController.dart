// ignore_for_file: non_constant_identifier_names
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:jysp/Database/both/TFragmentPoolNode.dart';
import 'package:jysp/FragmentPool/FragmentPoolEnum.dart';
import 'package:jysp/LWCR/Controller/FreeBoxController.dart';
import 'package:jysp/LWCR/Request/FragmentPoolRequest/LayoutNodesRequest.dart';
import 'package:jysp/Tools/RebuildHandler.dart';
import 'package:jysp/Tools/TDebug.dart';

class _Init extends ChangeNotifier {}

mixin FragmentPoolControllerRoot on _Init {
  ///

  /// 需要显示在池内的节点
  /// const 代表 [] 对象无法被赋予新对象，而内元素可以被修改
  final List<Map> fragmentPoolNodes = [
    // 标准格式：
  ];

  /// 重复的、没有 father 的、route=null 的节点
  List<Map> fragmentPoolNodeOuts = [];

  /// 将 [参数异常]、[重复的 route] 、[没有 father 的 route] 过滤到 [fragmentPoolNodeOuts] 中，保证 [fragmentPoolNodes] 中每个 Map 的 route 唯一且不为空：
  void setFragmentPoolNodes(bool isClearBefore, Function(List<Map> fpn) setCallback) {
    if (isClearBefore) {
      fragmentPoolNodes.clear();
    }

    fragmentPoolNodeOuts.clear();

    setCallback(fragmentPoolNodes);

    dLog(() => "setFragmentPoolNodes 过滤前：", () => fragmentPoolNodes);

    // route="0" 必须存在
    if (fragmentPoolNodes.where((item) => (item["route"] == "0")).length == 0) {
      fragmentPoolNodes.add(_poolNodeZero());
    }

    fragmentPoolNodes.removeWhere(
      (itemRaw) {
        // 先过滤掉参数异常的数据 ----------------------------------------------------
        if (!(itemRaw[TFragmentPoolNode.fragment_pool_node_id] is int) && !(itemRaw[TFragmentPoolNode.fragment_pool_node_id_s] is int)) {
          itemRaw["out_type"] = OutType.id.index;
          fragmentPoolNodeOuts.add(itemRaw);
          return true;
        }
        if (!(PoolType.indexs.toList.contains(itemRaw[TFragmentPoolNode.pool_type]))) {
          itemRaw["out_type"] = OutType.pool_type.index;
          fragmentPoolNodeOuts.add(itemRaw);
          return true;
        }
        if (!(PoolType.indexs.toList.contains(itemRaw[TFragmentPoolNode.node_type]))) {
          itemRaw["out_type"] = OutType.node_type.index;
          fragmentPoolNodeOuts.add(itemRaw);
          return true;
        }
        if (!(itemRaw[TFragmentPoolNode.route] is String)) {
          itemRaw["out_type"] = OutType.route_exception.index;
          fragmentPoolNodeOuts.add(itemRaw);
          return true;
        }
        if (!(itemRaw[TFragmentPoolNode.name] is String)) {
          itemRaw["out_type"] = OutType.name.index;
          fragmentPoolNodeOuts.add(itemRaw);
          return true;
        }

        // 过滤掉没有 father 的：------------------------------------------------
        bool isRemoveNoFather = false;
        if (itemRaw["route"] != "0") {
          List<String> splitResult = itemRaw["route"].toString().split("-");
          if (splitResult[0] != "0") {
            itemRaw["out_type"] = OutType.route_exception.index;
            fragmentPoolNodeOuts.add(itemRaw);
            return true;
          }
          String fatherRoute = splitResult.sublist(0, splitResult.length - 1).join("-");
          fragmentPoolNodes.firstWhere(
            (fatherItem) {
              // 若当前 [itemRaw] 存在 [fatherRoute]：
              if (fatherItem["route"] == fatherRoute) {
                return true;
              }
              return false;
            },
            orElse: () {
              // 若当前 [itemRaw] 不存在 [fatherRoute]：
              itemRaw["out_type"] = OutType.route_no_father.index;
              fragmentPoolNodeOuts.add(itemRaw);
              isRemoveNoFather = true;
              return null;
            },
          );
          // 若当前 [itemRaw] 没有被过滤掉，则继续往下执行识别
          if (isRemoveNoFather) {
            return isRemoveNoFather;
          }

          // 过滤掉重复的：------------------------------------------------------
          if (itemRaw["out_type"] == OutType.route_repeat.index) {
            fragmentPoolNodeOuts.add(itemRaw);
            return true;
          }
          fragmentPoolNodes.firstWhere(
            (repeatItem) {
              // 若 [fragmentPoolNodes] 中存在与当前 [itemRaw] 相同的 route，则
              bool isExist = (repeatItem["route"] == itemRaw["route"]);
              if (isExist) {
                repeatItem["out_type"] = OutType.route_repeat.index;
              }
              return true;
            },
          );
        }

        return false;
      },
    );

    dLog(() => "setFragmentPoolNodes 过滤后：", () => {"fragmentPoolNodes": fragmentPoolNodes, "fragmentPoolNodeOuts": fragmentPoolNodeOuts});
  }

  /// [fragmentPoolNodes] 数量为0时, [node_type] 为 -1。
  Map _poolNodeZero() {
    return {
      "fragment_pool_node_id": -1,
      "fragment_pool_node_id_s": -1,
      "pool_type": getCurrentPoolType.index,
      "node_type": NodeType.root.index,
      "route": "0",
      "name": "root",
      "created_at": null,
      "updated_at": null,
    };
  }

  /// node 的默认布局数据
  Map defaultLayoutPropertyMap({@required Size size}) {
    return {
      "child_count": 0,
      "father_route": "0", // 默认不能为 null ，因为节点的连接线需要 xx["father_route"]["layout_top"] 等
      "layout_width": size == null ? 100 : size.width, // 不设置它为0是为了防止出现bug观察不出来
      "layout_height": size == null ? 100 : size.height,
      "layout_left": -10000.0,
      "layout_top": -10000.0,
      "container_height": size == null ? 10 : size.height,
      "vertical_center_offset": 0.0
    };
  }

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

  /// 刷新碎片池操作过程的状态
  PoolRefreshStatus _poolRefreshStatus = PoolRefreshStatus.none;
  PoolRefreshStatus get getPoolRefreshStatus => _poolRefreshStatus;
  set setPoolRefreshStatus(PoolRefreshStatus value) => _poolRefreshStatus = value;

  bool isInitFragmentPool = false;

  ///
}

mixin _RefreshLayout on LayoutNodesRequest {
  ///

  /// 流程：
  /// init rebuild
  ///    ↓
  /// toPool
  ///    ↓
  /// getData成功                                 设置 route="0"
  ///    ↓                                             |
  /// setFragmentPoolNodes ——> refreshLayout ——>    rebuild    ——>    getLayouts ——>     endGetLayout      ——>      setLayout             ——>            rebuild
  ///                                                  |                  |                                          |    |                                 |
  ///                                                  |                  +---------------+--------------------------+    |                                 |
  ///                                                  |                                  |                               |                                 |
  ///                                                 使用                               使用                      nodeLayoutMap.clear()                    使用
  ///                                            nodeLayoutMap                     nodeLayoutMapTemp        nodeLayoutMap = nodeLayoutMapTemp          nodeLayoutMap
  ///                                         保持,但可能会增加元素                                               nodeLayoutMapTemp.clear()
  ///                                   因此新的元素需赋予 default(no size)
  ///                                          无需担心元素被减少
  ///                       因为 fragmentPoolNodes 无论增加还是减少，nodeLayoutMap 始终没变

  /// 间隔空间大小
  double heightSpace = 40.0;
  double widthSpace = 80.0;

  /// 布局 Map
  /// 格式：{"0":{key:value},"0-0":{key:value}};
  Map<dynamic, dynamic> nodeLayoutMap = {};
  Map<dynamic, dynamic> nodeLayoutMapTemp = {};

  ///
  ///
  ///
  /// 刷新布局 —— 获取布局属性
  ///
  void refreshFragmentPool(FreeBoxController freeBoxController, PoolType toPoolType) {
    setView(freeBoxController, toPoolType);

    setPoolRefreshStatus = PoolRefreshStatus.refreshLayout;
    dLog(() => "1-refreshLayout");
    notifyListeners(); // notifyListeners 是同步任务
  }

  /// 保存当前 offset/scale , 并设置当前碎片池的为指定池
  void setView(FreeBoxController freeBoxController, PoolType toPoolType) {
    viewSelectedType[getCurrentPoolType]["offset"] = freeBoxController.offset;
    viewSelectedType[getCurrentPoolType]["scale"] = freeBoxController.scale;
    setCurrentPoolType = toPoolType; // 必须放到设置 viewSelectedType 的后面
  }

  ///
  ///
  ///
  /// 刷新布局 —— build 布局
  /// 已获取完 [全部 Nodes 的初始属性],开始对 [布局] 进行布设
  ///
  void setLayout() {
    Map<String, int> tailMap = {};
    _sl1(tailMap);
    _sl2(tailMap);
    _sl3();
    _sl4(tailMap);
    _sl5LayoutDone();
    _sl6FrameTwo();
  }

  /// 1、获取全部 [tail_route] 的 [map], 获取每个 [route] 数量和 [father_route]
  void _sl1(Map<String, int> tailMap) {
    nodeLayoutMapTemp.forEach((key, value) {
      // 获取 [tail_route] 的 [map]
      if (!nodeLayoutMapTemp.containsKey(key + "-0")) {
        tailMap[key] = value["index"];
      }

      if (key != "0") {
        // 获取每个 [route] 的 [father_route]
        List<String> spl = key.split("-");
        String fatherRoute = spl.sublist(0, spl.length - 1).join("-");
        nodeLayoutMapTemp[key]["father_route"] = fatherRoute;

        // 获取每个 [route] 的 [child] 数量
        if (nodeLayoutMapTemp.containsKey(fatherRoute)) {
          nodeLayoutMapTemp[fatherRoute]["child_count"]++; // 根据当前 key(子route) 给 fatherRoute 赋值
        }
      }
    });
  }

  /// 2、从 [tail_route] 开始,依次向左迭代并获取 [container_height]
  void _sl2(Map<String, int> tailMap) {
    tailMap.forEach((key, value) {
      List<String> keyNums = key.split("-");
      for (int partIndex = keyNums.length - 1; partIndex >= 0; partIndex--) {
        String partRoute = keyNums.sublist(0, partIndex + 1).join("-");

        /// 既然从尾部开始，那么就不处理"0"
        if (partRoute != "0") {
          String fatherRoute = keyNums.sublist(0, partIndex).join("-");
          double childrenContainerHeight = 0.0 - heightSpace; // 减去 [height_space] 是因为 [container_height] 不包含最底下的 [height_space]

          /// 迭代同层级的 [route]
          for (int incIndex = 0; incIndex < nodeLayoutMapTemp[fatherRoute]["child_count"]; incIndex++) {
            String incRoute = fatherRoute + "-$incIndex";
            childrenContainerHeight += nodeLayoutMapTemp[incRoute]["container_height"] + heightSpace; // 需要加上 [heightSpace]
          }

          /// 比较并赋值
          nodeLayoutMapTemp[fatherRoute]["container_height"] =
              nodeLayoutMapTemp[fatherRoute]["layout_height"] > childrenContainerHeight ? nodeLayoutMapTemp[fatherRoute]["layout_height"] : childrenContainerHeight;
        }
      }
    });
  }

  /// 3、从任意 [route] 开始,向上紧贴,并向左对齐
  void _sl3() {
    nodeLayoutMapTemp.forEach((key, value) {
      double topContainerHeight = 0.0; // 不减去 [height_space] 是因为 top 时包含最底下的 height_space
      double finalLeft = 0.0;

      /// 逐渐减
      List<String> keyNums = key.split("-");
      for (int partIndex = keyNums.length - 1; partIndex >= 0; partIndex--) {
        String partRoute = keyNums.sublist(0, partIndex + 1).join("-");

        /// 向上紧贴
        for (int upIndex = 0; upIndex < int.parse(keyNums[partIndex]); upIndex++) {
          topContainerHeight += nodeLayoutMapTemp[keyNums.sublist(0, partIndex).join("-") + "-$upIndex"]["container_height"] + heightSpace;
        }

        /// 向左对齐
        if (partRoute != key) {
          finalLeft += nodeLayoutMapTemp[partRoute]["layout_width"] + widthSpace; // 需要加上 [widthSpace]
        }
      }
      nodeLayoutMapTemp[key]["layout_top"] = topContainerHeight;
      nodeLayoutMapTemp[key]["layout_left"] = finalLeft;
    });
  }

  /// 4、从 [tail_route] 开始,垂直居中偏移
  void _sl4(Map<String, int> tailMap) {
    tailMap.forEach((key, value) {
      /// 向左传递,逐渐减
      List<String> keyNums = key.split("-");
      for (int partIndex = keyNums.length - 1; partIndex >= 0; partIndex--) {
        String partRoute = keyNums.sublist(0, partIndex + 1).join("-");

        /// 既然从尾部开始，那么就不处理"0"
        if (partRoute != "0") {
          String fatherRoute = keyNums.sublist(0, partIndex).join("-");

          double childrenUp = nodeLayoutMapTemp[fatherRoute + "-0"]["layout_top"]; // 可以为负值
          double childrenDown = nodeLayoutMapTemp[fatherRoute + "-${nodeLayoutMapTemp[fatherRoute]["child_count"] - 1}"]["layout_top"] +
              nodeLayoutMapTemp[fatherRoute + "-${nodeLayoutMapTemp[fatherRoute]["child_count"] - 1}"]["layout_height"]; // 可以为负值
          double childrenUDHeight = (childrenDown - childrenUp).abs(); // 不能为负值
          double fatherUp = nodeLayoutMapTemp[fatherRoute]["layout_top"]; // 可以为负值
          double fatherHeight = nodeLayoutMapTemp[fatherRoute]["layout_height"]; // 不能为负值
          if (childrenUDHeight >= nodeLayoutMapTemp[fatherRoute]["layout_height"]) {
            /// 1、这里不能用"2、"的方式,因为 [children] 上方的空无不容易计算;
            nodeLayoutMapTemp[fatherRoute]["layout_top"] = (childrenUDHeight / 2 - fatherHeight / 2) + childrenUp;
          } else {
            /// 2、这里不能用"1、"的方法,因为需要把整个 [children] 进行调整;
            double finalchild0Top = (fatherHeight / 2 - childrenUDHeight / 2) + fatherUp; // 可以为负值
            double delta = finalchild0Top - childrenUp; // 可以为负值
            void func(String route, double del) {
              for (int i = 0; i < nodeLayoutMapTemp[route]["child_count"]; i++) {
                String childRoute = route + "-$i";
                nodeLayoutMapTemp[childRoute]["vertical_center_offset"] = del;
                func(childRoute, del);
              }
            }

            if (delta >= 0) {
              func(fatherRoute, delta.abs());
            } else {
              // 因为 [delta >= 0] 时，其 ["vertical_center_offset"] 还残留着非0值,因此需要把他们的值赋为0
              func(fatherRoute, 0);
              List<String> keyNums = fatherRoute.split("-");
              for (int partIndex = keyNums.length - 1; partIndex >= 0; partIndex--) {
                // [fatherRoute] 假设为 0-1-2-3 ,结果为: 0, 0-1, 0-1-2, 0-1-2-3
                String partRoute = keyNums.sublist(0, partIndex + 1).join("-");
                // 自身: 0, 0-1, 0-1-2, 0-1-2-3
                nodeLayoutMapTemp[partRoute]["vertical_center_offset"] = delta.abs();
                for (int brotherIndex = int.parse(keyNums[partIndex]) + 1; brotherIndex < nodeLayoutMapTemp.length; brotherIndex++) {
                  // 递增: (1+), 0-(2+), 0-1-(3+), 0-1-2-(4+)
                  String partIncRoute = keyNums.sublist(0, partIndex).join("-") + "-$brotherIndex";
                  if (nodeLayoutMapTemp.containsKey(partIncRoute) == false) {
                    break;
                  } else {
                    // TODO: 这部分不知为何下移的距离会过大
                    nodeLayoutMapTemp[partIncRoute]["vertical_center_offset"] = delta.abs(); // 自身
                    func(partIncRoute, delta.abs());
                  }
                }
              }
            }
          }
        }
      }
    });

    /// 实施垂直居中偏移
    nodeLayoutMapTemp.forEach((key, value) {
      nodeLayoutMapTemp[key]["layout_top"] += nodeLayoutMapTemp[key]["vertical_center_offset"];
    });
  }

  /// 5、完成布局设置
  void _sl5LayoutDone() {
    /// 防止残留的元素干扰
    nodeLayoutMap.clear();

    /// 进行拷贝
    nodeLayoutMap.addAll(nodeLayoutMapTemp);

    /// 防止残留的元素干扰
    nodeLayoutMapTemp.clear();
  }

  /// 6、调用第二帧
  void _sl6FrameTwo() {
    setPoolRefreshStatus = PoolRefreshStatus.buildLayout;
    dLog(() => "4-buildLayout");
    dLog(() => "nodeLayoutMap:", () => nodeLayoutMap);
    notifyListeners();
  }

  ///
}

mixin _ToPool on _RefreshLayout {
  ///

  /// 是否弹出加载屏障
  RebuildHandler<LoadingBarrierHandlerEnum> isLoadingBarrierRebuildHandler = RebuildHandler<LoadingBarrierHandlerEnum>();

  /// 是否取消 to pool
  bool _isCancelToPool = false;
  bool get isCancelToPool => _isCancelToPool;
  void cancelToPool() {
    _isCancelToPool = true;
    isLoadingBarrierRebuildHandler.rebuildHandle(LoadingBarrierHandlerEnum.disabled);
  }

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
  ///     - 回调带 -1：不跳转到对应的 type。Ⅰ. toPool 并发。Ⅱ. 获取数据成功，但被取消对数据的操作。
  ///
  /// 先获取数据后，才会调用 [toPoolTypeResult] 回调，最后才刷新碎片池
  ///
  Future<void> toPool({
    @required FreeBoxController freeBoxController,
    @required PoolType toPoolType,
    @required Function(int resultCode) toPoolTypeResult,
  }) async {
    if (_isToPooling) {
      toPoolTypeResult(-1);
      return;
    }
    _isToPooling = true;

    await Future(() async {
      dLog(() => "正在获取 fragmentPoolNodes 数据，并进入${toPoolType.value}中...");

      // 打开加载屏障
      isLoadingBarrierRebuildHandler.rebuildHandle(LoadingBarrierHandlerEnum.enabled);

      // 获取数据：[toPoolType] 的数据
      // result = true 时：获取数据成功。
      // result = false 时：获取数据失败。
      // result = null 时：toPool 被中断。
      bool result = await layoutNodesRequest(toPoolType, isCancelToPool);

      switch (result) {
        case true:
          dLog(() => "获取 fragmentPoolNodes 数据成功。");
          toPoolTypeResult(0);
          // 根据结果重新刷新布局
          refreshFragmentPool(freeBoxController, toPoolType);
          isLoadingBarrierRebuildHandler.rebuildHandle(LoadingBarrierHandlerEnum.disabled);
          _isToPooling = false;
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

  ///
}

class FragmentPoolController extends _Init with FragmentPoolControllerRoot, LayoutNodesRequest, _RefreshLayout, _ToPool {}
