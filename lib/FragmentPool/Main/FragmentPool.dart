import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:jysp/FragmentPool/Main/FreeBox.dart';
import 'package:jysp/FragmentPool/Nodes/BaseNodes/MainNode.dart';

/// 第一帧：获取全部 [layout_size]
/// 第二帧：
/// 1、获取全部 [tail_route] 的 [map]
/// 2、从 [tail_route] 依次向左迭代获取 [container_height] 和 [container_left]:
/// [container_height]:
///   当前层级的 [container_height] 指的是当前层级的每个 [route] 的 [container_height] 相加,再加上 [container] 间被夹持的 [height_space] ,不包含非被夹持的最底下的 [height_space];
///   [tail_route] 的 [container_height] 值为自身的 [layout_height];
///   若当前层级的 [container_height] 大于父级的 [layout_height] ,则父级的 [container_height] 值为当前层级的 [container_height] ,并计算父级的 [offset_top];
///   若当前层级的 [container_height] 小于父级的 [layout_height] ,则父级的 [container_height] 值为父级自身的 [layout_height] ,并计算子级的 [offset_top];
/// [container_left]:靠左，非靠右
/// 3、设置全部 [route] 的 [container_top]:
///   [container_top] 指的是当前 [route] 上方的全部 [route] 的 [container_height] 相加,
///   再加上 [container] 间被夹持的 [height_space] ,再加上自身的 [offset_top] ,不包含非被夹持的最底下的 [height_space];

class FragmentPool extends StatefulWidget {
  @override
  _FragmentPoolState createState() => _FragmentPoolState();
}

class _FragmentPoolState extends State<FragmentPool> {
  FreeBoxController _freeBoxController;
  List<Map<dynamic, dynamic>> _fragmentPoolDateList = [];
  Map<String, Map<dynamic, dynamic>> _fragmentPoolDateMap = {};
  Map<String, Map<dynamic, dynamic>> _fragmentPoolDateMapClone = {};
  Map<String, int> _tailMap = {};
  double _heightSpace = 40.0;
  double _widthSpace = 80.0;

  @override
  void initState() {
    super.initState();
    _freeBoxController = FreeBoxController(widgetState: this);
    _fragmentPoolDateList = [
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
    return Stack(
      children: <Widget>[
        FreeBox(
          boxWidth: double.maxFinite,
          boxHeight: double.maxFinite,
          eventWidth: double.maxFinite,
          eventHeight: double.maxFinite,
          backgroundColor: Colors.green,
          freeBoxController: _freeBoxController,
          children: childrenWidget(),
        ),
        Positioned(
          bottom: 50,
          left: 0,
          child: FlatButton(
            onPressed: () {
              _freeBoxController.startZeroSliding();
            },
            child: Icon(Icons.adjust),
          ),
        ),
      ],
    );
  }

  List<Widget> childrenWidget() {
    /// 必须清空,防止被残留的 key 干扰
    _tailMap.clear();
    _fragmentPoolDateMap.clear();

    /// 不能 [clone.clear()] ,保留 [clone] 即维持状态不变，防止 [setState] 时闪一下, [fragmentPoolDateMapClone] 成员的作用即是如此
    // fragmentPoolDateMapClone.clear();

    return <Widget>[
      for (int childrenIndex = 0; childrenIndex < _fragmentPoolDateList.length + 1; childrenIndex++)
        if (childrenIndex != _fragmentPoolDateList.length)
          MainNode(
            fragmentPoolDateList: this._fragmentPoolDateList,
            index: childrenIndex,
            fragmentPoolDateMap: this._fragmentPoolDateMap,
            fragmentPoolDateMapClone: this._fragmentPoolDateMapClone,
            freeBoxController: this._freeBoxController,
          )
        else
          EndIndex(
            fisrtFrameEndHandle: () {
              WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
                one();
                two();
                three();
                four();
                five();
                six();
              });
            },
          ),
    ];
  }

  /// 1、获取全部 [tail_route] 的 [map],以及 每个 [route] 数量
  /// [fragmentPoolDateMap] 和 [fragmentPoolDateMapClone] 已被 [SingleNode] 中的 [firstFrameStart] 重置了,因为需要获取 [MainNode.this] ,因此不能在这里重置 [MainNode.this]
  void one() {
    _fragmentPoolDateMap.forEach((key, value) {
      /// 获取 [tail_route]
      if (!_fragmentPoolDateMap.containsKey(key + "-0")) {
        _tailMap[key] = value["index"];
      }

      /// 获取每个 [route] 的 [child] 数量
      List<String> spl = key.split("-");
      String fatherRoute = spl.sublist(0, spl.length - 1).join("-");
      if (key != "0" && _fragmentPoolDateMap.containsKey(fatherRoute)) {
        _fragmentPoolDateMap[fatherRoute]["child_count"]++;
      }
    });
  }

  /// 2、从 [tail_route] 开始,依次向左迭代并获取 [container_height]
  void two() {
    _tailMap.forEach((key, value) {
      List<String> keyNums = key.split("-");
      for (int partIndex = keyNums.length - 1; partIndex >= 0; partIndex--) {
        String partRoute = keyNums.sublist(0, partIndex + 1).join("-");

        /// 既然从尾部开始，那么就不处理"0"
        if (partRoute != "0") {
          String fatherRoute = keyNums.sublist(0, partIndex).join("-");
          double childrenContainerHeight = 0.0 - _heightSpace; //// 减去 [height_space] 是因为 [container_height] 不包含最底下的 [height_space]

          /// 迭代同层级的 [route]
          for (int incIndex = 0; incIndex < _fragmentPoolDateMap[fatherRoute]["child_count"]; incIndex++) {
            String incRoute = fatherRoute + "-$incIndex";
            childrenContainerHeight += _fragmentPoolDateMap[incRoute]["container_height"] + _heightSpace; //// 需要加上 [heightSpace]
          }

          /// 比较并赋值
          _fragmentPoolDateMap[fatherRoute]["container_height"] =
              _fragmentPoolDateMap[fatherRoute]["layout_height"] > childrenContainerHeight ? _fragmentPoolDateMap[fatherRoute]["layout_height"] : childrenContainerHeight;
        }
      }
    });
  }

  /// 3、从任意 [route] 开始,向上紧贴,并向左对齐
  void three() {
    _fragmentPoolDateMap.forEach((key, value) {
      double topContainerHeight = 0.0; //// 不减去 [height_space] 是因为 top 时包含最底下的 height_space
      double finalLeft = 0.0;

      /// 逐渐减
      List<String> keyNums = key.split("-");
      for (int partIndex = keyNums.length - 1; partIndex >= 0; partIndex--) {
        String partRoute = keyNums.sublist(0, partIndex + 1).join("-");

        /// 向上紧贴
        for (int upIndex = 0; upIndex < int.parse(keyNums[partIndex]); upIndex++) {
          topContainerHeight += _fragmentPoolDateMap[keyNums.sublist(0, partIndex).join("-") + "-$upIndex"]["container_height"] + _heightSpace;
        }

        /// 向左对齐
        if (partRoute != key) {
          finalLeft += _fragmentPoolDateMap[partRoute]["layout_width"] + _widthSpace; //// 需要加上 [widthSpace]
        }
      }
      _fragmentPoolDateMap[key]["layout_top"] = topContainerHeight;
      _fragmentPoolDateMap[key]["layout_left"] = finalLeft;
    });
  }

  /// 4、从 [tail_route] 开始,垂直居中偏移
  void four() {
    _tailMap.forEach((key, value) {
      /// 向左传递,逐渐减
      List<String> keyNums = key.split("-");
      for (int partIndex = keyNums.length - 1; partIndex >= 0; partIndex--) {
        String partRoute = keyNums.sublist(0, partIndex + 1).join("-");

        /// 既然从尾部开始，那么就不处理"0"
        if (partRoute != "0") {
          String fatherRoute = keyNums.sublist(0, partIndex).join("-");

          double childrenUp = _fragmentPoolDateMap[fatherRoute + "-0"]["layout_top"]; // 可以为负值
          double childrenDown = _fragmentPoolDateMap[fatherRoute + "-${_fragmentPoolDateMap[fatherRoute]["child_count"] - 1}"]["layout_top"] +
              _fragmentPoolDateMap[fatherRoute + "-${_fragmentPoolDateMap[fatherRoute]["child_count"] - 1}"]["layout_height"]; // 可以为负值
          double childrenUDHeight = (childrenDown - childrenUp).abs(); // 不能为负值
          double fatherUp = _fragmentPoolDateMap[fatherRoute]["layout_top"]; // 可以为负值
          double fatherHeight = _fragmentPoolDateMap[fatherRoute]["layout_height"]; // 不能为负值
          if (childrenUDHeight >= _fragmentPoolDateMap[fatherRoute]["layout_height"]) {
            /// 1、这里不能用"2、"的方式,因为 [children] 上方的空无不容易计算;
            _fragmentPoolDateMap[fatherRoute]["layout_top"] = (childrenUDHeight / 2 - fatherHeight / 2) + childrenUp;
          } else {
            /// 2、这里不能用"1、"的方法,因为需要把整个 [children] 进行调整;
            double finalchild0Top = (fatherHeight / 2 - childrenUDHeight / 2) + fatherUp; // 可以为负值
            double delta = finalchild0Top - childrenUp; // 可以为负值
            void func(String route, double del) {
              for (int i = 0; i < _fragmentPoolDateMap[route]["child_count"]; i++) {
                String childRoute = route + "-$i";
                _fragmentPoolDateMap[childRoute]["vertical_center_offset"] = del;
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
                _fragmentPoolDateMap[partRoute]["vertical_center_offset"] = delta.abs();
                for (int brotherIndex = int.parse(keyNums[partIndex]) + 1; brotherIndex < _fragmentPoolDateList.length; brotherIndex++) {
                  //// 递增: (1+), 0-(2+), 0-1-(3+), 0-1-2-(4+)
                  String partIncRoute = keyNums.sublist(0, partIndex).join("-") + "-$brotherIndex";
                  if (_fragmentPoolDateMap.containsKey(partIncRoute) == false) {
                    break;
                  } else {
                    /// TODO: 这部分不知为何下移的距离会过大
                    _fragmentPoolDateMap[partIncRoute]["vertical_center_offset"] = delta.abs(); // 自身
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
  void five() {
    _fragmentPoolDateMapClone.clear();
    _fragmentPoolDateMap.forEach((key, value) {
      _fragmentPoolDateMap[key]["layout_top"] += _fragmentPoolDateMap[key]["vertical_center_offset"];
      _fragmentPoolDateMapClone[key] = {
        "child_count": _fragmentPoolDateMap[key]["child_count"],
        "layout_height": _fragmentPoolDateMap[key]["layout_height"],
        "layout_width": _fragmentPoolDateMap[key]["layout_width"],
        "layout_left": _fragmentPoolDateMap[key]["layout_left"],
        "layout_top": _fragmentPoolDateMap[key]["layout_top"],
        "container_height": _fragmentPoolDateMap[key]["container_height"],
      };
      (value["this"] as MainNodeState).setState(() {});
    });
  }

  /// 6、镜头调至原点
  void six() {
    Offset transformZeroOffset =
        Offset(_fragmentPoolDateMap["0"]["layout_left"] - _fragmentPoolDateMap["0"]["layout_width"] / 2, -(_fragmentPoolDateMap["0"]["layout_top"] + _fragmentPoolDateMap["0"]["layout_height"] / 2));
    Offset mediaCenter = Offset(MediaQueryData.fromWindow(window).size.width / 2, MediaQueryData.fromWindow(window).size.height / 2);
    _freeBoxController.zeroPosition = transformZeroOffset + mediaCenter;
  }
}

class EndIndex extends StatefulWidget {
  EndIndex({Key key, @required this.fisrtFrameEndHandle}) : super(key: key);
  final Function fisrtFrameEndHandle;

  @override
  _EndIndexState createState() => _EndIndexState();
}

class _EndIndexState extends State<EndIndex> {
  void firstFrame() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      /// 当所有 [SingleNode] 都 [build] 完一遍后调用。
      widget.fisrtFrameEndHandle();
    });
  }

  @override
  void didUpdateWidget(EndIndex oldWidget) {
    super.didUpdateWidget(oldWidget);
    firstFrame();
  }

  @override
  void initState() {
    super.initState();
    firstFrame();
  }

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
