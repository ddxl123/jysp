import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:jysp/FragmentPool/FragmentPoolEnum.dart';
import 'package:jysp/G/G.dart';
import 'package:jysp/G/GSqliteField.dart';
import 'package:jysp/LWCR/Controller/FreeBoxController.dart';
import 'package:jysp/Tools/RebuildHandler.dart';
import 'package:jysp/Tools/TDebug.dart';

class Init extends ChangeNotifier {}

mixin _Root on Init {
  ///

  /// 当前碎片池节点读取数据
  final List<Map<dynamic, dynamic>> fragmentPoolNodes = [
    {"_id": "", "user_id": "", "pool_type": 0, "node_type": 0, "route": "0", "name": "root1"},
    {"_id": "", "user_id": "", "pool_type": 0, "node_type": 0, "route": "0-0", "name": "root1"},
    {"_id": "", "user_id": "", "pool_type": 0, "node_type": 0, "route": "0-1", "name": "root2"},
    {"_id": "", "user_id": "", "pool_type": 0, "node_type": 0, "route": "0-0-0", "name": "ro\not3的"},
  ];

  /// 当 nodes 数量为0时, 创建的临时 node0 节点
  final Map<dynamic, dynamic> nullNode = const {"route": "0", "node_type": -1};

  /// node 的默认布局数据
  Map<dynamic, dynamic> defaultLayoutPropertyMap({@required Size size}) {
    return {
      "child_count": 0,
      "father_route": "0",
      "layout_width": size == null ? 10 : size.width, // 不设置它为0是为了防止出现bug观察不出来
      "layout_height": size == null ? 10 : size.height,
      "layout_left": -10000.0,
      "layout_top": -10000.0,
      "container_height": size == null ? 10 : size.height,
      "vertical_center_offset": 0.0
    };
  }

  /// 当前展现的碎片池类型
  FragmentPoolType _currentFragmentPoolType = FragmentPoolType.pendingPool;
  FragmentPoolType get getCurrentFragmentPoolType => _currentFragmentPoolType;
  set setCurrentFragmentPoolType(FragmentPoolType value) => _currentFragmentPoolType = value;

  /// 每个碎片池的视口位置和缩放, 以及对应池默认的视口位置
  /// 这里必须把子类型写清楚了, 不然会报错:"type 'Offset' is not a subtype of type 'String' of 'value'"
  Map<FragmentPoolType, Map<String, dynamic>> viewSelectedType = {
    FragmentPoolType.pendingPool: {"offset": null, "scale": null, "node0": Offset.zero},
    FragmentPoolType.memoryPool: {"offset": null, "scale": null, "node0": Offset.zero},
    FragmentPoolType.completePool: {"offset": null, "scale": null, "node0": Offset.zero},
    FragmentPoolType.wikiPool: {"offset": null, "scale": null, "node0": Offset.zero},
  };

  /// 刷新碎片池操作过程的状态
  FragmentPoolRefreshStatus _fragmentPoolRefreshStatus = FragmentPoolRefreshStatus.none;
  FragmentPoolRefreshStatus get getFragmentPoolRefreshStatus => _fragmentPoolRefreshStatus;
  set setFragmentPoolRefreshStatus(FragmentPoolRefreshStatus value) => _fragmentPoolRefreshStatus = value;

  ///
}

mixin _SetLayout on _Root {
  ///

  /// 间隔空间大小
  double heightSpace = 40.0;
  double widthSpace = 80.0;

  /// 视图 Map
  /// 在刷新布局的过程中, 会 clear [nodeLayoutMap] ,因此需要 [nodeLayoutMapTemp]
  Map<dynamic, dynamic> nodeLayoutMap = {};
  Map<dynamic, dynamic> nodeLayoutMapTemp = {};

  ///
  ///
  ///
  /// 已获取完 [全部 Nodes 的初始属性],开始对 [布局] 进行摆布
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
      /// 获取 [tail_route] 的 [map]
      if (!nodeLayoutMapTemp.containsKey(key + "-0")) {
        tailMap[key] = value["index"];
      }

      /// 获取每个 [route] 的 [father_route]
      List<String> spl = key.split("-");
      String fatherRoute = spl.sublist(0, spl.length - 1).join("-");
      nodeLayoutMapTemp[key]["father_route"] = fatherRoute;

      /// 获取每个 [route] 的 [child] 数量
      if (key != "0" && nodeLayoutMapTemp.containsKey(fatherRoute)) {
        nodeLayoutMapTemp[fatherRoute]["child_count"]++;
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

    /// 伪深拷贝
    nodeLayoutMap = Map.of(nodeLayoutMapTemp);

    /// 防止残留的元素干扰
    nodeLayoutMapTemp.clear();
  }

  /// 6、调用第二帧
  void _sl6FrameTwo() {
    setFragmentPoolRefreshStatus = FragmentPoolRefreshStatus.willRunLayout;
    dPrint("5-willRunLayout");
    notifyListeners();
  }

  ///
}

mixin _RefreshLayout on _Root, _Request {
  ///

  /// 是否弹出加载 Toast
  RebuildHandler isLoadingBarrierRebuildHandler = RebuildHandler();

  /// 防止刷新碎片池操作并发
  Set<Object> lineCodes = {};

  ///
  ///
  ///
  /// 刷新布局函数
  ///
  /// 每次刷新碎片池时, 需先获取每个 node 的布局宽高, 因此碎片池 widget 需要被 build 2次
  ///
  /// [isInit]：不能为 null
  ///   当前调用是否为初始化调用
  /// [isGetData]：不能为 null
  ///   是否需要 [异步] 获取数据。
  /// [toPoolTypeResult]：不可以为 null
  ///   跳转至指定 type of pool 成功与失败
  ///   成功时回调带 1, 即跳转到对应的 type
  ///   失败时回调带 0, 即不跳转到对应的 type
  ///   异步获取数据被中断时回调带 -1
  ///
  void refreshLayout({
    @required FreeBoxController freeBoxController,
    @required bool isInit,
    @required bool isGetData,
    @required FragmentPoolType toPoolType,
    @required Function(int resultCode) toPoolTypeResult,
  }) {
    interruptRefreshLayout();
    _refreshLayoutHandle(freeBoxController, isInit, isGetData, toPoolType, toPoolTypeResult);
  }

  /// 具体操作分类
  void _refreshLayoutHandle(
    FreeBoxController freeBoxController,
    bool isInit,
    bool isGetData,
    FragmentPoolType toPoolType,
    Function(int resultCode) toPoolTypeResult,
  ) async {
    //
    /// [仅-初始化刷新布局]
    if (isInit == true && isGetData == false) {
      /// 初始化无法修改其他 widget 的 state, 因此需让 [currentFragmentPoolType] 保持为默认值, 从而使得其他 widget 的 state 能保持初始化 state 同步
      /// 因未完成布局而无法获取当前的 offset/scale, 因此会默认匹配到完成布局后 node0 的 offset/scale
      toPoolTypeResult(1);

      setFragmentPoolRefreshStatus = FragmentPoolRefreshStatus.willGetLayout;
      dPrint("2-willGetLayout-init");
    }
    //
    /// 先 [刷新布局], 再异步 [获取数据], 最后再 [仅-非初始化刷新布局]
    else if (isInit == true && isGetData == true) {
      /// 初始化无法修改其他 widget 的 state, 因此需让 [currentFragmentPoolType] 保持为默认值, 从而使得其他 widget 的 state 能保持初始化 state 同步
      /// 因未完成布局而无法获取当前的 offset/scale, 因此会默认匹配到完成布局后 node0 的 offset/scale
      /// toPoolTypeResult(true); 这里无需进行回调, 因为该回调是要让异步获取数据完成后进行回调的

      setFragmentPoolRefreshStatus = FragmentPoolRefreshStatus.willGetLayout;
      dPrint("2-willGetLayout-init");

      await _getRefreshLayoutData(freeBoxController, getCurrentFragmentPoolType, toPoolTypeResult);
    }
    //
    /// [仅-非初始化刷新布局]
    else if (isInit == false && isGetData == false) {
      setView(freeBoxController, toPoolType);
      toPoolTypeResult(1);

      setFragmentPoolRefreshStatus = FragmentPoolRefreshStatus.willLayout;
      dPrint("1-willLayout");
      notifyListeners(); // 同步
    }
    //
    /// 先 [获取数据], 再 [仅-非初始化刷新布局]
    else if (isInit == false && isGetData == true) {
      await _getRefreshLayoutData(freeBoxController, toPoolType, toPoolTypeResult);
    }
  }

  /// [异步] 获取布局数据
  Future _getRefreshLayoutData(
    FreeBoxController freeBoxController,
    FragmentPoolType toPoolType,
    Function(int resultCode) toPoolTypeResult,
  ) async {
    /// 必须都放在异步中
    await Future(() async {
      /// 打开加载屏障
      isLoadingBarrierRebuildHandler.rebuildHandle(1);

      /// 给予 [willGetData] 信号
      setFragmentPoolRefreshStatus = FragmentPoolRefreshStatus.willGetData;
      dPrint("willGetData");

      /// 安排线码
      Object lineCode = Object();
      lineCodes.add(lineCode);
      dPrint("线码:${lineCode.hashCode}");

      /// 获取数据：[toPoolType] 的数据
      bool result = await _layoutDataRequest();

      ///
      ///
      ///
      /// 并发中断
      /// 若不存在, 则代表该调用需被中断
      if (!lineCodes.contains(lineCode)) {
        toPoolTypeResult(-1); // 无法预测何时会进行回调
        dPrint("中断线码成功:${lineCode.hashCode}");
        return;
      }

      if (result) {
        dPrint("获取数据成功");

        /// 获取数据阶段收尾
        setFragmentPoolRefreshStatus = FragmentPoolRefreshStatus.none;
        dPrint("0-none");

        /// 根据结果重新刷新布局, [setView] 和 [toPoolTypeResult] 操作交给下面这行代码
        refreshLayout(freeBoxController: freeBoxController, isInit: false, isGetData: false, toPoolType: toPoolType, toPoolTypeResult: (bool) {}); //同步

        /// 最终完成后取消屏障
        isLoadingBarrierRebuildHandler.rebuildHandle(0);
      } else {
        dPrint("获取数据失败");

        toPoolTypeResult(0);

        /// 收尾
        setFragmentPoolRefreshStatus = FragmentPoolRefreshStatus.none;
        dPrint("0-none");

        /// 最终完成后取消屏障
        isLoadingBarrierRebuildHandler.rebuildHandle(0);
      }
    });
  }

  /// 中断数据获取的异步
  void interruptRefreshLayout() {
    if (getFragmentPoolRefreshStatus == FragmentPoolRefreshStatus.willGetData) {
      /// 若并发, 则中断上一次程序
      isLoadingBarrierRebuildHandler.rebuildHandle(0); // 取消屏障
      lineCodes.clear();
      // 这里被中断无需调用 [isGetData] 回调函数
      dPrint("被中断");
    }
  }

  /// 保存当前 offset/scale , 并设置当前碎片池的为指定池
  void setView(FreeBoxController freeBoxController, FragmentPoolType toPoolType) {
    viewSelectedType[getCurrentFragmentPoolType]["offset"] = freeBoxController.offset;
    viewSelectedType[getCurrentFragmentPoolType]["scale"] = freeBoxController.scale;
    setCurrentFragmentPoolType = toPoolType; // 必须放到设置 viewSelectedType 的后面
  }

  ///
}

mixin _Request {
  Future<bool> _layoutDataRequest() async {
    return await _sqliteLayoutData();
  }

  Future<bool> _sqliteLayoutData() async {
    /// 本地/云端获取数据是否成功
    bool isSuccess = false;

    /// 进行本地查询
    await G.sqlite.db.query(TFragmentPoolNodes.getTableName).then(
      (successValue) async {
        dLog("", successValue);

        /// 若本地中一个也没有，则代表未初始化，需向云端请求数据
        if (successValue.length == 0) {
          isSuccess = await _cloudLayoutData();
        }

        /// 若本地中存在，则代表已初始化过，无需向云端请求数据，直接使用即可
        else {
          isSuccess = true;
        }
      },
    ).catchError((onError) {
      dPrint(onError);

      /// 若本地 sqlite 错误，则 Toast 提示
      isSuccess = false;
    });

    return isSuccess;
  }

  Future<bool> _cloudLayoutData() async {
    bool isSuccess = false;
    await G.http.sendPostRequest(
      route: null,
      data: null,
      result: null,
      onError: null,
      notConcurrent: null,
    );
    return isSuccess;
  }
}

class FragmentPoolController extends Init with _Root, _SetLayout, _Request, _RefreshLayout {}
