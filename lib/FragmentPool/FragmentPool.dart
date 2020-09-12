import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:jysp/FragmentPool/Nodes/ToolNodes/FreeBox.dart';
import 'package:jysp/FragmentPool/Nodes/BaseNodes/MainSingleNode.dart';

class FragmentPool extends StatefulWidget {
  FragmentPool({@required this.freeBoxController});
  final FreeBoxController freeBoxController;

  @override
  _FragmentPoolState createState() => _FragmentPoolState();
}

class _FragmentPoolState extends State<FragmentPool> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Future.delayed(Duration(seconds: 3)).then((value) {
        // widget.freeBoxController.disableTouch(true);
        // void listener() {
        //   print("listener");
        //   if (widget.freeBoxController.freeBoxSlidingStatus == FreeBoxSlidingStatus.none) {
        //     print("object");
        //     widget.freeBoxController.disableTouch(false);
        //     widget.freeBoxController.removeListener(listener);
        //   }
        // }

        // widget.freeBoxController.addListener(listener);
      }),
      builder: (_, AsyncSnapshot snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.waiting:
            return Stack(
              children: [
                Positioned(
                  top: 0,
                  child: Container(
                    width: MediaQueryData.fromWindow(window).size.width,
                    height: MediaQueryData.fromWindow(window).size.height,
                    alignment: Alignment.center,
                    color: Colors.blue,
                    child: Text("loading"),
                  ),
                ),
              ],
            );
          case ConnectionState.done:
            return FragmentNode(freeBoxController: widget.freeBoxController);
          default:
            return Center(child: Text("err"));
        }
      },
    );
  }
}

class FragmentNode extends StatefulWidget {
  FragmentNode({@required this.freeBoxController});
  final FreeBoxController freeBoxController;

  @override
  _FragmentNodeState createState() => _FragmentNodeState();
}

class _FragmentNodeState extends State<FragmentNode> {
  List<Map<dynamic, dynamic>> fragmentPoolDataList = [];
  Map<String, Map<dynamic, dynamic>> fragmentPoolLayoutDataMap = {};
  Map<String, Map<dynamic, dynamic>> fragmentPoolLayoutDataMapTemp = {};

  Map<String, int> _tailMap = {};

  /// 间隔空间大小
  double heightSpace = 40.0;
  double widthSpace = 80.0;

  /// 是否正在执行重新进行布局
  bool _isResetingLayoutProperty = false;
  bool _isResetingLayout = false;

  /// 是否已被初始化 [ToZero]
  bool _isInitedToZero = false;

  @override
  void initState() {
    super.initState();

    fragmentPoolDataList = [
      {
        "route": "0",
        "type": 0,
        "pool_display_name": "root",
      },
      {
        "route": "0-0",
        "type": 1,
        "pool_display_name": "热污染3人安抚43热污染3人安抚433给热污染3人安抚433给 0-0",
      },
      {
        "route": "0-1",
        "type": 1,
        "pool_display_name":
            "热污\n染3\n人安\n抚43\n3给热\n污\n染\n\热\n污\n染\n\热\n污\n染\n\热\n污\n染\n\n\n3人安\n\热\n污\n染\n\热\n污\n染\n\热\n污\n染\n\n\n3人安\n\热\n污\n染\n\热\n污\n染\n\热\n污\n染\n\n\n3人安抚\n\n433给热\n污\n染3人安抚433给热污\n染3人安抚4\n33给 0-1",
      },
      {
        "route": "0-2",
        "type": 1,
        "pool_display_name": "热污染3人安抚3给 0-2",
      },
      {
        "route": "0-0-0",
        "type": 1,
        "pool_display_name": "热污染3人安抚433给热污染3人安抚433给热污\n染3人安抚433给热污\n染3人安抚433给热污\n染3人安抚433安抚433给 0-0-0",
      },
      {
        "route": "0-0-0-0",
        "type": 1,
        "pool_display_name": "热污染3给 0-0-0-0",
      },
      {
        "route": "0-0-0-1",
        "type": 1,
        "pool_display_name": "热污染给热污染3人安抚433给热污染3人安抚433给 0-0-0-1",
      },
      {
        "route": "0-0-1",
        "type": 1,
        "pool_display_name": "热污染3人安抚433给热污染3人安抚433给热污染3人安抚433给 0-0-1",
      },
      {
        "route": "0-0-1-0",
        "type": 1,
        "pool_display_name": "热污染3人\n染3人安抚433给热污染3人安抚\n433给热\n污染3人安抚433给 0-0-1-0",
      },
      {
        "route": "0-0-1-1",
        "type": 1,
        "pool_display_name": "热污染3人安抚433给热污染33给热污染3人安抚433给热污染33给热污染3人安抚433给热污染33给热污染3人安抚433给热污染33给热污染3人安抚433给热污染33给热污染3人安抚433给热污染33给 0-0-1-1",
      },
      {
        "route": "0-0-1-2",
        "type": 1,
        "pool_display_name": " 0-0-1-2",
      },
      {
        "route": "0-0-2",
        "type": 2,
        "pool_display_name": "433给热污染3人安抚433给 0-0-2",
      },
      {
        "route": "0-1-0",
        "type": 2,
        "pool_display_name": "热污\n染3抚433\n给 0-1-0",
      },
      {
        "route": "0-1-1",
        "type": 2,
        "pool_display_name": "热0-1-0",
      },
      {
        "route": "0-1-0-0",
        "type": 2,
        "pool_display_name": "热污染3人安抚433给热污污\n安抚433给 0-1-0",
      },
      {
        "route": "0-1-0-1",
        "type": 2,
        "pool_display_name": "热污染3人安污\n安抚433给 0-1-0",
      },
      {
        "route": "0-1-0-2",
        "type": 2,
        "pool_display_name": "热给 0-1-0",
      },
      {
        "route": "0-2-0",
        "type": 2,
        "pool_display_name": "热污染3人安抚433给热污染3人安抚433染3人安抚433给 0-2-0",
      },
      {
        "route": "0-2-1",
        "type": 2,
        "pool_display_name": "热污染3人安抚43热污\n染3人安抚433给热污染3人安抚433给热污染3人安抚433给 0-2-1",
      },
      {
        "route": "0-2-2",
        "type": 2,
        "pool_display_name": "热污染3人安抚433给热污染3人安抚433给热污\n染3人安抚433给热污染3人安抚433给热污染3人安抚433给 0-2-2",
      },
    ];
  }

  @override
  Widget build(BuildContext context) {
    return nodes();
  }

  Widget nodes() {
    return Stack(
      children: <Widget>[
        for (int childrenIndex = 0; childrenIndex < fragmentPoolDataList.length; childrenIndex++)
          MainSingleNode(
            fragmentPoolDataList: this.fragmentPoolDataList,
            index: childrenIndex,
            fragmentPoolLayoutDataMap: this.fragmentPoolLayoutDataMap,
            fragmentPoolLayoutDataMapTemp: this.fragmentPoolLayoutDataMapTemp,
            freeBoxController: widget.freeBoxController,
            resetLayout: resetLayout,
            isResetingLayout: (bool b) {
              _isResetingLayout = b;
            },
            isResetingLayoutProperty: () {
              /// 之所以用函数获取，是因为如果直接传入bool值，会按值传递，并不会获取到被修改后的 [_isReSetLayouting]
              return _isResetingLayoutProperty;
            },
            reLayoutHandle: () {
              _one();
              _two();
              _three();
              _four();
              _five();
              _six();
            },
          ),
      ],
    );
  }

  /// 已获取完 [全部Node的初始属性],开始进行 [布局]
  ///
  /// 1、获取全部 [tail_route] 的 [map],以及 每个 [route] 数量
  /// [fragmentPoolLayoutDataMap] 和 [fragmentPoolLayoutDataMapClone] 已被 [SingleNode] 中的 [firstFrameStart] 重置了,因为需要获取 [SingleNode.this] ,因此不能在这里重置 [SingleNode.this]
  void _one() {
    fragmentPoolLayoutDataMap.forEach((key, value) {
      /// 获取 [tail_route]
      if (!fragmentPoolLayoutDataMap.containsKey(key + "-0")) {
        _tailMap[key] = value["index"];
      }

      /// 获取每个 [route] 的 [child] 数量
      List<String> spl = key.split("-");
      String fatherRoute = spl.sublist(0, spl.length - 1).join("-");
      if (key != "0" && fragmentPoolLayoutDataMap.containsKey(fatherRoute)) {
        fragmentPoolLayoutDataMap[fatherRoute]["child_count"]++;
      }
    });
  }

  /// 2、从 [tail_route] 开始,依次向左迭代并获取 [container_height]
  void _two() {
    _tailMap.forEach((key, value) {
      List<String> keyNums = key.split("-");
      for (int partIndex = keyNums.length - 1; partIndex >= 0; partIndex--) {
        String partRoute = keyNums.sublist(0, partIndex + 1).join("-");

        /// 既然从尾部开始，那么就不处理"0"
        if (partRoute != "0") {
          String fatherRoute = keyNums.sublist(0, partIndex).join("-");
          double childrenContainerHeight = 0.0 - heightSpace; //// 减去 [height_space] 是因为 [container_height] 不包含最底下的 [height_space]

          /// 迭代同层级的 [route]
          for (int incIndex = 0; incIndex < fragmentPoolLayoutDataMap[fatherRoute]["child_count"]; incIndex++) {
            String incRoute = fatherRoute + "-$incIndex";
            childrenContainerHeight += fragmentPoolLayoutDataMap[incRoute]["container_height"] + heightSpace; //// 需要加上 [heightSpace]
          }

          /// 比较并赋值
          fragmentPoolLayoutDataMap[fatherRoute]["container_height"] =
              fragmentPoolLayoutDataMap[fatherRoute]["layout_height"] > childrenContainerHeight ? fragmentPoolLayoutDataMap[fatherRoute]["layout_height"] : childrenContainerHeight;
        }
      }
    });
  }

  /// 3、从任意 [route] 开始,向上紧贴,并向左对齐
  void _three() {
    fragmentPoolLayoutDataMap.forEach((key, value) {
      double topContainerHeight = 0.0; //// 不减去 [height_space] 是因为 top 时包含最底下的 height_space
      double finalLeft = 0.0;

      /// 逐渐减
      List<String> keyNums = key.split("-");
      for (int partIndex = keyNums.length - 1; partIndex >= 0; partIndex--) {
        String partRoute = keyNums.sublist(0, partIndex + 1).join("-");

        /// 向上紧贴
        for (int upIndex = 0; upIndex < int.parse(keyNums[partIndex]); upIndex++) {
          topContainerHeight += fragmentPoolLayoutDataMap[keyNums.sublist(0, partIndex).join("-") + "-$upIndex"]["container_height"] + heightSpace;
        }

        /// 向左对齐
        if (partRoute != key) {
          finalLeft += fragmentPoolLayoutDataMap[partRoute]["layout_width"] + widthSpace; //// 需要加上 [widthSpace]
        }
      }
      fragmentPoolLayoutDataMap[key]["layout_top"] = topContainerHeight;
      fragmentPoolLayoutDataMap[key]["layout_left"] = finalLeft;
    });
  }

  /// 4、从 [tail_route] 开始,垂直居中偏移
  void _four() {
    _tailMap.forEach((key, value) {
      /// 向左传递,逐渐减
      List<String> keyNums = key.split("-");
      for (int partIndex = keyNums.length - 1; partIndex >= 0; partIndex--) {
        String partRoute = keyNums.sublist(0, partIndex + 1).join("-");

        /// 既然从尾部开始，那么就不处理"0"
        if (partRoute != "0") {
          String fatherRoute = keyNums.sublist(0, partIndex).join("-");

          double childrenUp = fragmentPoolLayoutDataMap[fatherRoute + "-0"]["layout_top"]; // 可以为负值
          double childrenDown = fragmentPoolLayoutDataMap[fatherRoute + "-${fragmentPoolLayoutDataMap[fatherRoute]["child_count"] - 1}"]["layout_top"] +
              fragmentPoolLayoutDataMap[fatherRoute + "-${fragmentPoolLayoutDataMap[fatherRoute]["child_count"] - 1}"]["layout_height"]; // 可以为负值
          double childrenUDHeight = (childrenDown - childrenUp).abs(); // 不能为负值
          double fatherUp = fragmentPoolLayoutDataMap[fatherRoute]["layout_top"]; // 可以为负值
          double fatherHeight = fragmentPoolLayoutDataMap[fatherRoute]["layout_height"]; // 不能为负值
          if (childrenUDHeight >= fragmentPoolLayoutDataMap[fatherRoute]["layout_height"]) {
            /// 1、这里不能用"2、"的方式,因为 [children] 上方的空无不容易计算;
            fragmentPoolLayoutDataMap[fatherRoute]["layout_top"] = (childrenUDHeight / 2 - fatherHeight / 2) + childrenUp;
          } else {
            /// 2、这里不能用"1、"的方法,因为需要把整个 [children] 进行调整;
            double finalchild0Top = (fatherHeight / 2 - childrenUDHeight / 2) + fatherUp; // 可以为负值
            double delta = finalchild0Top - childrenUp; // 可以为负值
            void func(String route, double del) {
              for (int i = 0; i < fragmentPoolLayoutDataMap[route]["child_count"]; i++) {
                String childRoute = route + "-$i";
                fragmentPoolLayoutDataMap[childRoute]["vertical_center_offset"] = del;
                func(childRoute, del);
              }
            }

            if (delta >= 0) {
              func(fatherRoute, delta.abs());
            } else {
              //// 因为 [delta >= 0] 时，其 ["vertical_center_offset"] 还残留着非0值,因此需要把他们的值赋为0
              func(fatherRoute, 0);
              List<String> keyNums = fatherRoute.split("-");
              for (int partIndex = keyNums.length - 1; partIndex >= 0; partIndex--) {
                //// [fatherRoute] 假设为 0-1-2-3 ,结果为: 0, 0-1, 0-1-2, 0-1-2-3
                String partRoute = keyNums.sublist(0, partIndex + 1).join("-");
                //// 自身: 0, 0-1, 0-1-2, 0-1-2-3
                fragmentPoolLayoutDataMap[partRoute]["vertical_center_offset"] = delta.abs();
                for (int brotherIndex = int.parse(keyNums[partIndex]) + 1; brotherIndex < fragmentPoolLayoutDataMap.length; brotherIndex++) {
                  //// 递增: (1+), 0-(2+), 0-1-(3+), 0-1-2-(4+)
                  String partIncRoute = keyNums.sublist(0, partIndex).join("-") + "-$brotherIndex";
                  if (fragmentPoolLayoutDataMap.containsKey(partIncRoute) == false) {
                    break;
                  } else {
                    /// TODO: 这部分不知为何下移的距离会过大
                    fragmentPoolLayoutDataMap[partIncRoute]["vertical_center_offset"] = delta.abs(); // 自身
                    func(partIncRoute, delta.abs());
                  }
                }
              }
            }
          }
        }
      }
    });
  }

  /// 5、开始第2帧 [rebuild]
  void _five() {
    fragmentPoolLayoutDataMap.forEach((key, value) {
      /// 偏移
      fragmentPoolLayoutDataMap[key]["layout_top"] += fragmentPoolLayoutDataMap[key]["vertical_center_offset"];
    });

    /// 正式设置布局完成
    _isResetingLayoutProperty = false;
    setState(() {});
  }

  /// 6、镜头调至原点
  void _six() {
    Offset transformZeroOffset = Offset(fragmentPoolLayoutDataMap["0"]["layout_left"] - fragmentPoolLayoutDataMap["0"]["layout_width"] / 2,
        -(fragmentPoolLayoutDataMap["0"]["layout_top"] + fragmentPoolLayoutDataMap["0"]["layout_height"] / 2));
    Offset mediaCenter = Offset(MediaQueryData.fromWindow(window).size.width / 2, MediaQueryData.fromWindow(window).size.height / 2);
    widget.freeBoxController.zeroPosition = transformZeroOffset + mediaCenter;

    /// 因为重新布局会调用 [six()] ,而这里只需 [init] 时调用一次
    if (!_isInitedToZero) {
      _isInitedToZero = true;
      widget.freeBoxController.startZeroSliding();
    }
  }

  /// 重置布局
  void resetLayout(Function callback) {
    if (_isResetingLayout) {
      return;
    }

    /// [callback] 可以对 [fragmentPoolDataList] 进行增删操作
    /// 之所以放在 [if(_isResetingLayout)] 之后，是因为放在前面时， [fragmentPoolDataList] 被修改后，直接被 [return] 了而无法进行剩余操作
    callback();

    _isResetingLayout = true;
    _isResetingLayoutProperty = true;

    /// 是独立的地址值，没有相关联的，因此放心 [clear]
    fragmentPoolLayoutDataMapTemp.clear();

    /// 伪深拷贝,因为下面的 [fragmentPoolLayoutDataMap.clear()] 会把同地址的给 [clear] 了
    /// 作用：保留原数据，防止 [setState] 时闪一下
    fragmentPoolLayoutDataMapTemp = Map.of(fragmentPoolLayoutDataMap);

    /// 作用：防止残留的 [route] 干扰
    _tailMap.clear();
    fragmentPoolLayoutDataMap.clear();

    setState(() {});
  }
}
