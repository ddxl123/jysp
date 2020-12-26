import 'package:flutter/material.dart';
import 'package:jysp/FragmentPool/FragmentPool/FragmentPoolController.dart';
import 'package:jysp/FragmentPool/FragmentPoolEnum.dart';
import 'package:jysp/FragmentPool/SingleNode/SingleNode.dart';

class FragmentPool extends StatefulWidget {
  FragmentPool({@required this.fragmentPoolController});
  final FragmentPoolController fragmentPoolController;

  @override
  _FragmentPoolState createState() => _FragmentPoolState();
}

class _FragmentPoolState extends State<FragmentPool> {
  @override
  void initState() {
    super.initState();
    widget.fragmentPoolController.refreshLayout(true);
    widget.fragmentPoolController.addListener(_controllerListener);
  }

  @override
  void dispose() {
    widget.fragmentPoolController.removeListener(_controllerListener);
    super.dispose();
  }

  /// 监听函数
  void _controllerListener() {
    if (widget.fragmentPoolController.fragmentPoolRefreshStatus == FragmentPoolRefreshStatus.willRefresh) {
      widget.fragmentPoolController.fragmentPoolRefreshStatus = FragmentPoolRefreshStatus.getLayout;
      print("2-getLayout");
      setState(() {});
    }
    if (widget.fragmentPoolController.fragmentPoolRefreshStatus == FragmentPoolRefreshStatus.runLayout) {
      widget.fragmentPoolController.fragmentPoolRefreshStatus = FragmentPoolRefreshStatus.none;
      print("6-none");
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
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
///
/// 当 node 数量为0时，由于 [setLayout] 处理中有需要获取 [route="0"] 的操作
/// 对此, 当 node 数量为0时, 由 [End] 充当 [route="0"]
/// 即:
///   - 当 node 数量为0时, [End] 为 [指示Node] ,
///   - 当 node 数量不为0时, [End] 为 空widget
class End extends StatefulWidget {
  End({@required this.fragmentPoolController});
  final FragmentPoolController fragmentPoolController;

  @override
  _EndState createState() => _EndState();
}

class _EndState extends State<End> {
  /// 每个 node 的宽高都被获取完成后
  void _getLayout() {
    if (widget.fragmentPoolController.fragmentPoolRefreshStatus == FragmentPoolRefreshStatus.getLayout) {
      /// 防止被执行多次
      widget.fragmentPoolController.fragmentPoolRefreshStatus = FragmentPoolRefreshStatus.willSetLayout;
      print("3-willSetLayout");

      /// 每个 node 都被 [build] 完成后调用
      WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
        widget.fragmentPoolController.fragmentPoolRefreshStatus = FragmentPoolRefreshStatus.setLayout;
        print("4-setLayout");
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
