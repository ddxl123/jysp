import 'package:flutter/material.dart';
import 'package:jysp/FragmentPool/FragmentPoolEnum.dart';
import 'package:jysp/FragmentPool/SingleNode/SingleNode.dart';
import 'package:jysp/LWCR/Controller/FragmentPoolController.dart';
import 'package:jysp/LWCR/LifeCycle/FragmentPool.dart';
import 'package:jysp/LWCR/WidgetBuild/WidgetBuildBase.dart';
import 'package:jysp/Tools/TDebug.dart';

class FragmentPoolWB extends WidgetBuildBase<FragmentPool> {
  FragmentPoolWB(FragmentPool widget) : super(widget);

  @override
  Widget build(BuildContext context) {
    /// 检测 nodes 数量是否为0, 若为0则生成一个
    if (widget.fragmentPoolController.fragmentPoolNodes.isEmpty) {
      widget.fragmentPoolController.fragmentPoolNodes.add(widget.fragmentPoolController.nullNode);
    }
    return Stack(
      children: <Widget>[
        for (int childrenIndex = 0; childrenIndex <= widget.fragmentPoolController.fragmentPoolNodes.length; childrenIndex++)
          () {
            if (childrenIndex == widget.fragmentPoolController.fragmentPoolNodes.length) {
              return End(fragmentPoolController: widget.fragmentPoolController);
            }
            return SingleNode(
              index: childrenIndex,
              thisRouteName: widget.fragmentPoolController.fragmentPoolNodes[childrenIndex]["route"],
              fragmentPoolController: widget.fragmentPoolController,
            );
          }()
      ],
    );
  }
}

///
///
/// 完成最好的 build 调用
class End extends StatefulWidget {
  End({@required this.fragmentPoolController});
  final FragmentPoolController fragmentPoolController;

  @override
  _EndState createState() => _EndState();
}

class _EndState extends State<End> {
  /// 每个 node 的宽高都被获取完成后
  void _getLayout() {
    if (widget.fragmentPoolController.getFragmentPoolRefreshStatus == FragmentPoolRefreshStatus.willGetLayout) {
      /// 防止被执行多次
      widget.fragmentPoolController.setFragmentPoolRefreshStatus = FragmentPoolRefreshStatus.willSetLayout;
      dPrint("3-willSetLayout");

      /// 每个 node 都被 [build] 完成后调用
      WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
        widget.fragmentPoolController.setFragmentPoolRefreshStatus = FragmentPoolRefreshStatus.setLayoutDone;
        dPrint("4-setLayoutDone");
        widget.fragmentPoolController.setLayout();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    _getLayout();
    return Container();
  }
}
