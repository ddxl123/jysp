import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:jysp/FragmentPool/FragmentPoolEnum.dart';

class FragmentPoolController extends ChangeNotifier {
  ///

  /// 当前碎片池节点读取数据
  final List<dynamic> fragmentPoolNodes = [
    {"_id": "", "user_id": "", "pool_type": 0, "node_type": 0, "route": "0", "name": "root"},
    {"_id": "", "user_id": "", "pool_type": 0, "node_type": 0, "route": "0-0", "name": "root1"},
    {"_id": "", "user_id": "", "pool_type": 0, "node_type": 0, "route": "0-1", "name": "root2"},
    {"_id": "", "user_id": "", "pool_type": 0, "node_type": 0, "route": "0-0-0", "name": "ro\not3的"},
  ];

  /// node0 位置
  Offset node0Position = Offset.zero;

  /// 间隔空间大小
  double heightSpace = 40.0;
  double widthSpace = 80.0;

  /// 当前展现的碎片池类型
  FragmentPoolSelectedType fragmentPoolSelectedType = FragmentPoolSelectedType.none;

  /// 刷新碎片池操作过程的状态
  FragmentPoolRefreshStatus fragmentPoolRefreshStatus = FragmentPoolRefreshStatus.none;

  ///
  ///
  ///
  /// 视图 Map
  ///
  /// 在刷新布局的过程中, 会 clear [nodeLayoutMap] ,因此需要 [nodeLayoutMapTemp]
  Map<dynamic, dynamic> nodeLayoutMap = {};
  Map<dynamic, dynamic> nodeLayoutMapTemp = {};

  ///
  ///
  ///
  /// 默认布局数据
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

  ///
  ///
  ///
  /// 刷新布局函数
  ///
  /// 每次刷新碎片池时, 需最先获取每个 node 的布局宽高
  void refreshLayout() {
    if (fragmentPoolRefreshStatus != FragmentPoolRefreshStatus.none) {
      print("非none");
      return;
    }

    fragmentPoolRefreshStatus = FragmentPoolRefreshStatus.willRefresh;
    print("1-willRefresh");

    /// [callback] 可以对 [fragmentPoolDataList] 进行增删操作
    /// 之所以放在 [if(_isResetingLayout)] 之后，是因为放在前面时， [fragmentPoolDataList] 被修改后，直接被 [return] 了而无法进行剩余操作
    // callback();

    /// 获取每个 node 的布局宽高前, 要想 clear, 防止元素残余
    /// 是独立的地址值，没有相关联的，因此放心 [clear]
    nodeLayoutMapTemp.clear();
    notifyListeners();
  }

  ///
  ///
  ///
  /// 已获取完 [全部 Nodes 的初始属性],开始对 [布局] 进行摆布
  void setLayout() {
    Map<String, int> tailMap = {};
    _sl1(tailMap);
    _sl2(tailMap);
    _sl3();
    _sl4(tailMap);
    _sl5LayoutDone();
    _sl6GetNode0Position();
    _sl7FrameTwo();
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
    /// 作用：防止残留的 [route] 干扰
    nodeLayoutMap.clear();

    /// 伪深拷贝
    nodeLayoutMap = Map.of(nodeLayoutMapTemp);
  }

  /// 6、获取布局后需要的 state
  void _sl6GetNode0Position() {
    /// 获取 [route=="0"] 的坐标
    Offset transformZeroOffset =
        Offset(nodeLayoutMapTemp["0"]["layout_left"] - nodeLayoutMapTemp["0"]["layout_width"] / 2, -(nodeLayoutMapTemp["0"]["layout_top"] + nodeLayoutMapTemp["0"]["layout_height"] / 2));
    Offset mediaCenter = Offset(MediaQueryData.fromWindow(window).size.width / 2, MediaQueryData.fromWindow(window).size.height / 2);
    node0Position = transformZeroOffset + mediaCenter;
  }

  /// 7、调用第二帧
  void _sl7FrameTwo() {
    fragmentPoolRefreshStatus = FragmentPoolRefreshStatus.runLayout;
    print("5-runLayout");
    notifyListeners();
  }
}
