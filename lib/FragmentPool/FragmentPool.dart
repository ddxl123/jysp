import 'dart:convert';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:jysp/FragmentPool/FragmentPoolState.dart';
import 'package:jysp/G/G.dart';
import 'package:jysp/FragmentPool/Nodes/BaseNodes/MainSingleNode.dart';

class FragmentPool extends StatefulWidget {
  FragmentPool({@required this.fragmentPoolState});
  final FragmentPoolState fragmentPoolState;

  @override
  _FragmentPoolState createState() => _FragmentPoolState();
}

class _FragmentPoolState extends State<FragmentPool> {
  Future _future() async {
    await Future.delayed(Duration(seconds: 1));
    await DefaultAssetBundle.of(context).loadString("assets/get_db/user_self_init_fragment_pool.json").then((value) {
      List val = json.decode(value);
      G.fragmentPool.fragmentPoolPendingNodes.clear();
      G.fragmentPool.fragmentPoolPendingNodes.addAll(val);
    }).catchError((onError) {});

    return null;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _future(),
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
            return FragmentNode(fragmentPoolState: widget.fragmentPoolState);
          default:
            return Center(child: Text("err"));
        }
      },
    );
  }
}

class FragmentNode extends StatefulWidget {
  FragmentNode({@required this.fragmentPoolState});
  final FragmentPoolState fragmentPoolState;

  @override
  _FragmentNodeState createState() => _FragmentNodeState();
}

class _FragmentNodeState extends State<FragmentNode> {
  /// 调用父级的 [reLayout] 会清空 [_nodeLayoutMap] ,因此需要 [_nodeLayoutMapTemp]
  ///  [_nodeLayoutMap] 是一个 [布局Map] ,是需要随时 [reLayout] 的
  Map<String, Map<dynamic, dynamic>> _nodeLayoutMap = {};
  Map<String, Map<dynamic, dynamic>> _nodeLayoutMapTemp = {};

  Map<String, int> _tailMap = {};

  /// 间隔空间大小
  double heightSpace = 40.0;
  double widthSpace = 80.0;

  /// 是否正在执行重新进行布局
  bool _isResetingLayoutProperty = false;
  bool _isResetingLayout = false;

  @override
  void initState() {
    super.initState();

    G.fragmentPool.startResetLayout = startResetLayout; // 需按地址传递
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        for (int childrenIndex = 0; childrenIndex < G.fragmentPool.fragmentPoolPendingNodes.length; childrenIndex++)
          MainSingleNode(
            index: childrenIndex,
            thisRouteName: G.fragmentPool.fragmentPoolPendingNodes[childrenIndex]["route"],
            nodeLayoutMap: _nodeLayoutMap,
            nodeLayoutMapTemp: _nodeLayoutMapTemp,

            /// 之所以用函数获取，是因为如果直接传入 [bool] 值，会按值传递，并不会获取到被修改后的。
            /// 传入值为 [null] 时，保持原来值。
            isResetingLayout: (bool b) {
              _isResetingLayout = b ?? _isResetingLayout;
              return _isResetingLayout;
            },
            isResetingLayoutProperty: (bool b) {
              _isResetingLayoutProperty = b ?? _isResetingLayoutProperty;
              return _isResetingLayoutProperty;
            },

            /// 布局操作
            reLayoutHandle: () {
              _one();
              _two();
              _three();
              _four();
              _five();
            },
          ),
      ],
    );
  }

  /// 已获取完 [全部Node的初始属性],开始进行 [布局]
  ///
  /// 1、获取全部 [tail_route] 的 [map], 获取每个 [route] 数量和 [father_route]
  void _one() {
    _nodeLayoutMapTemp.forEach((key, value) {
      /// 获取 [tail_route] 的 [map]
      if (!_nodeLayoutMapTemp.containsKey(key + "-0")) {
        _tailMap[key] = value["index"];
      }

      /// 获取每个 [route] 的 [father_route]
      List<String> spl = key.split("-");
      String fatherRoute = spl.sublist(0, spl.length - 1).join("-");
      _nodeLayoutMapTemp[key]["father_route"] = fatherRoute;

      /// 获取每个 [route] 的 [child] 数量
      if (key != "0" && _nodeLayoutMapTemp.containsKey(fatherRoute)) {
        _nodeLayoutMapTemp[fatherRoute]["child_count"]++;
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
          for (int incIndex = 0; incIndex < _nodeLayoutMapTemp[fatherRoute]["child_count"]; incIndex++) {
            String incRoute = fatherRoute + "-$incIndex";
            childrenContainerHeight += _nodeLayoutMapTemp[incRoute]["container_height"] + heightSpace; //// 需要加上 [heightSpace]
          }

          /// 比较并赋值
          _nodeLayoutMapTemp[fatherRoute]["container_height"] =
              _nodeLayoutMapTemp[fatherRoute]["layout_height"] > childrenContainerHeight ? _nodeLayoutMapTemp[fatherRoute]["layout_height"] : childrenContainerHeight;
        }
      }
    });
  }

  /// 3、从任意 [route] 开始,向上紧贴,并向左对齐
  void _three() {
    _nodeLayoutMapTemp.forEach((key, value) {
      double topContainerHeight = 0.0; //// 不减去 [height_space] 是因为 top 时包含最底下的 height_space
      double finalLeft = 0.0;

      /// 逐渐减
      List<String> keyNums = key.split("-");
      for (int partIndex = keyNums.length - 1; partIndex >= 0; partIndex--) {
        String partRoute = keyNums.sublist(0, partIndex + 1).join("-");

        /// 向上紧贴
        for (int upIndex = 0; upIndex < int.parse(keyNums[partIndex]); upIndex++) {
          topContainerHeight += _nodeLayoutMapTemp[keyNums.sublist(0, partIndex).join("-") + "-$upIndex"]["container_height"] + heightSpace;
        }

        /// 向左对齐
        if (partRoute != key) {
          finalLeft += _nodeLayoutMapTemp[partRoute]["layout_width"] + widthSpace; //// 需要加上 [widthSpace]
        }
      }
      _nodeLayoutMapTemp[key]["layout_top"] = topContainerHeight;
      _nodeLayoutMapTemp[key]["layout_left"] = finalLeft;
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

          double childrenUp = _nodeLayoutMapTemp[fatherRoute + "-0"]["layout_top"]; // 可以为负值
          double childrenDown = _nodeLayoutMapTemp[fatherRoute + "-${_nodeLayoutMapTemp[fatherRoute]["child_count"] - 1}"]["layout_top"] +
              _nodeLayoutMapTemp[fatherRoute + "-${_nodeLayoutMapTemp[fatherRoute]["child_count"] - 1}"]["layout_height"]; // 可以为负值
          double childrenUDHeight = (childrenDown - childrenUp).abs(); // 不能为负值
          double fatherUp = _nodeLayoutMapTemp[fatherRoute]["layout_top"]; // 可以为负值
          double fatherHeight = _nodeLayoutMapTemp[fatherRoute]["layout_height"]; // 不能为负值
          if (childrenUDHeight >= _nodeLayoutMapTemp[fatherRoute]["layout_height"]) {
            /// 1、这里不能用"2、"的方式,因为 [children] 上方的空无不容易计算;
            _nodeLayoutMapTemp[fatherRoute]["layout_top"] = (childrenUDHeight / 2 - fatherHeight / 2) + childrenUp;
          } else {
            /// 2、这里不能用"1、"的方法,因为需要把整个 [children] 进行调整;
            double finalchild0Top = (fatherHeight / 2 - childrenUDHeight / 2) + fatherUp; // 可以为负值
            double delta = finalchild0Top - childrenUp; // 可以为负值
            void func(String route, double del) {
              for (int i = 0; i < _nodeLayoutMapTemp[route]["child_count"]; i++) {
                String childRoute = route + "-$i";
                _nodeLayoutMapTemp[childRoute]["vertical_center_offset"] = del;
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
                _nodeLayoutMapTemp[partRoute]["vertical_center_offset"] = delta.abs();
                for (int brotherIndex = int.parse(keyNums[partIndex]) + 1; brotherIndex < _nodeLayoutMapTemp.length; brotherIndex++) {
                  //// 递增: (1+), 0-(2+), 0-1-(3+), 0-1-2-(4+)
                  String partIncRoute = keyNums.sublist(0, partIndex).join("-") + "-$brotherIndex";
                  if (_nodeLayoutMapTemp.containsKey(partIncRoute) == false) {
                    break;
                  } else {
                    /// TODO: 这部分不知为何下移的距离会过大
                    _nodeLayoutMapTemp[partIncRoute]["vertical_center_offset"] = delta.abs(); // 自身
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
    _nodeLayoutMapTemp.forEach((key, value) {
      _nodeLayoutMapTemp[key]["layout_top"] += _nodeLayoutMapTemp[key]["vertical_center_offset"];
    });
  }

  /// 5、完成布局设置，并调用第2帧
  void _five() {
    _tailMap.clear();

    /// 作用：防止残留的 [route] 干扰
    _nodeLayoutMap.clear();

    /// 伪深拷贝
    _nodeLayoutMap = Map.of(_nodeLayoutMapTemp);

    _getNode0Position();
    setState(() {});
  }

  /// 获取 [route=="0"] 的坐标,并将镜头预调至原点
  void _getNode0Position() {
    /// 获取 [route=="0"] 的坐标
    Offset transformZeroOffset =
        Offset(_nodeLayoutMapTemp["0"]["layout_left"] - _nodeLayoutMapTemp["0"]["layout_width"] / 2, -(_nodeLayoutMapTemp["0"]["layout_top"] + _nodeLayoutMapTemp["0"]["layout_height"] / 2));
    Offset mediaCenter = Offset(MediaQueryData.fromWindow(window).size.width / 2, MediaQueryData.fromWindow(window).size.height / 2);
    widget.fragmentPoolState.node0Position = transformZeroOffset + mediaCenter;
  }

  /// 开始进行重置布局
  void startResetLayout(Function callback) {
    if (_isResetingLayout) {
      return;
    }

    /// [callback] 可以对 [fragmentPoolDataList] 进行增删操作
    /// 之所以放在 [if(_isResetingLayout)] 之后，是因为放在前面时， [fragmentPoolDataList] 被修改后，直接被 [return] 了而无法进行剩余操作
    callback();

    _isResetingLayout = true;
    _isResetingLayoutProperty = true;

    /// 是独立的地址值，没有相关联的，因此放心 [clear]
    _nodeLayoutMapTemp.clear();

    setState(() {});
  }
}
