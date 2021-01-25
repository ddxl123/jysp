import 'package:flutter/material.dart';
import 'package:jysp/FragmentPool/FragmentPool/FragmentPoolController.dart';
import 'package:jysp/FragmentPool/FragmentPoolEnum.dart';
import 'package:jysp/FragmentPool/NodeType/UnknownNode.dart';
import 'package:jysp/FragmentPool/SingleNode/SingleNodeLine.dart';

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
    _notFindByThisRouteName();
    return _buildWidget();
  }

  /// 获取每个 node 的宽高
  void _getLayout() {
    if (widget.fragmentPoolController.getFragmentPoolRefreshStatus == FragmentPoolRefreshStatus.willGetLayout) {
      /// 防止被执行多次, 这里不能写这行, 否则第一个 node 就被禁止了, 应该在 end 里写
      // widget.fragmentPoolController.fragmentPoolRefreshStatus = FragmentPoolRefreshStatus.willSetLayout;

      /// 当前帧被 [build] 完成后调用
      WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
        Size size = (this.context.findRenderObject() as RenderBox).size;

        /// 给 [nodeLayoutMapTemp] 添加 [Node] ,并重置 [nodeLayoutMapTemp],在这之前 [nodeLayoutMapTemp] 已被 [clear] 过了。
        widget.fragmentPoolController.nodeLayoutMapTemp[widget.thisRouteName] = widget.fragmentPoolController.defaultLayoutPropertyMap(size: size);
      });
    }
  }

  /// 未找到对应route
  void _notFindByThisRouteName() {
    if (!widget.fragmentPoolController.nodeLayoutMap.containsKey(widget.thisRouteName)) {
      widget.fragmentPoolController.nodeLayoutMap[widget.thisRouteName] = widget.fragmentPoolController.defaultLayoutPropertyMap(size: null);
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

  Widget _child() {
    switch (widget.fragmentPoolController.fragmentPoolNodes[widget.index]["node_type"]) {
      case -1:
        return TextButton(child: Text("没有node "), onPressed: () {});
      case 0:
        return TextButton(child: Text("普通node"), onPressed: () {});
      default:
        return UnknownNode();
    }
  }
}
