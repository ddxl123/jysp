import 'package:flutter/material.dart';
import 'package:jysp/FragmentPool/FragmentPoolEnum.dart';
import 'package:jysp/FragmentPool/NodeType/UnknownNode.dart';
import 'package:jysp/FragmentPool/SingleNode/SingleNodeLine.dart';
import 'package:jysp/LWCR/Controller/FragmentPoolController.dart';

class SingleNode extends StatefulWidget {
  SingleNode({
    Key key,
    @required this.index,
    @required this.thisRouteName,
    @required this.fragmentPoolController,
  }) : super(key: key);

  final int index;
  final String thisRouteName;
  final FragmentPoolController fragmentPoolController;

  @override
  SingleNodeState createState() => SingleNodeState();
}

class SingleNodeState extends State<SingleNode> {
  ///

  @override
  Widget build(BuildContext context) {
    _getLayout();
    _newIndexLayoutPropertyConfig();
    return _buildWidget();
  }

  /// 获取每个 node 的宽高
  void _getLayout() {
    if (widget.fragmentPoolController.getPoolRefreshStatus == PoolRefreshStatus.getLayout) {
      /// 防止被执行多次, 这里不能写这行, 否则第一个 node 就被禁止了, 应该在 end 里写
      // widget.fragmentPoolController.fragmentPoolRefreshStatus = FragmentPoolRefreshStatus.setLayout;

      WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
        Size size = (this.context.findRenderObject() as RenderBox).size;

        /// 给每个 node 的 [nodeLayoutMapTemp] 添加布局属性 ,并重置 [nodeLayoutMapTemp], 在这之前 [nodeLayoutMapTemp] 已被 [clear] 过了。
        widget.fragmentPoolController.nodeLayoutMapTemp[widget.thisRouteName] = widget.fragmentPoolController.defaultLayoutPropertyMap(size: size);
      });
    }
  }

  /// 对新元素的配置，防止没有基本布局属性配置
  void _newIndexLayoutPropertyConfig() {
    if (!widget.fragmentPoolController.nodeLayoutMap.containsKey(widget.thisRouteName)) {
      widget.fragmentPoolController.nodeLayoutMap[widget.thisRouteName] = widget.fragmentPoolController.defaultLayoutPropertyMap(size: null);
    }
    // 若 [fragmentPoolNodes] 不是按照 [{"route":"0"},{"route":"0-1"}] 这样的 [先父后子] 的顺序排列，则需将其父同时添加 [nodeLayoutMap] 的默认值，防止之后
    List<String> split = widget.thisRouteName.split("-");
    String fatherRouteName = split.sublist(0, split.length - 1).join("-");
    if (!widget.fragmentPoolController.nodeLayoutMap.containsKey(fatherRouteName)) {
      widget.fragmentPoolController.nodeLayoutMap[fatherRouteName] = widget.fragmentPoolController.defaultLayoutPropertyMap(size: null);
    }
  }

  Widget _buildWidget() {
    return Positioned(
      left: widget.fragmentPoolController.nodeLayoutMap[widget.thisRouteName]["layout_left"],
      top: widget.fragmentPoolController.nodeLayoutMap[widget.thisRouteName]["layout_top"],
      child: CustomPaint(
        painter: SingleNodeLine(widget),
        child: _child(),
      ),
    );
  }

  /// 以下使用的全部都是 [fragmentPoolNodes]，而没有使用 [nodeLayoutMap] 的。
  Widget _child() {
    switch (widget.fragmentPoolController.fragmentPoolNodes[widget.index]["node_type"]) {
      case -1:
        return TextButton(child: Text(widget.fragmentPoolController.fragmentPoolNodes[widget.index]["node_type"]), onPressed: () {});
      case 0:
        return TextButton(child: Text("普通node"), onPressed: () {});
      default:
        return UnknownNode();
    }
  }
}
