import 'package:flutter/material.dart';
import 'package:jysp/Database/both/TFragmentPoolNode.dart';
import 'package:jysp/FragmentPool/FragmentPoolEnum.dart';
import 'package:jysp/FragmentPool/SingleNode/SingleNode.dart';
import 'package:jysp/LWCR/Controller/FragmentPoolController.dart';
import 'package:jysp/LWCR/LifeCycle/FragmentPoolLC.dart';
import 'package:jysp/LWCR/WidgetBuild/WidgetBuildBase.dart';
import 'package:jysp/Tools/TDebug.dart';

class FragmentPoolWB extends WidgetBuildBase<FragmentPoolLC> {
  FragmentPoolWB(FragmentPoolLC widget) : super(widget);

  @override
  Widget build(BuildContext context) {
    if (widget.fragmentPoolController.isInitFragmentPool) {
      return Text("initing...");
    }

    // 在 [setFragmentPoolNodes] 中已经全部准备好了，不用再确认 branch 是否无效等问题。
    return Stack(
      children: <Widget>[
        for (int childrenIndex = 0; childrenIndex <= widget.fragmentPoolController.fragmentPoolNodes.length; childrenIndex++)
          () {
            if (childrenIndex == widget.fragmentPoolController.fragmentPoolNodes.length) {
              return End(fragmentPoolController: widget.fragmentPoolController);
            }
            return SingleNode(
              index: childrenIndex,
              thisBranchName: widget.fragmentPoolController.fragmentPoolNodes[childrenIndex][TFragmentPoolNode.branch],
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
    if (widget.fragmentPoolController.getPoolRefreshStatus == PoolRefreshStatus.getLayout) {
      /// 防止被执行多次
      widget.fragmentPoolController.setPoolRefreshStatus = PoolRefreshStatus.setLayout;
      dLog(() => "3-setLayout");

      /// 每个 node 都被 [build] 完成后调用
      WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
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
