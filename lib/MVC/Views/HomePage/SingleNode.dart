import 'package:flutter/material.dart';
import 'package:jysp/Plugin/FreeBox/FreeBoxController.dart';
import 'package:jysp/Tools/TDebug.dart';
import 'package:provider/provider.dart';

class SingleNode extends StatefulWidget {
  SingleNode({
    required this.index,
  });

  final int index;

  @override
  SingleNodeState createState() => SingleNodeState();
}

class SingleNodeState extends State<SingleNode> {
  ///

  Offset _lastOffset = Offset.zero;
  Offset _deltaOffset = Offset.zero;

  Offset _onLongPressMoveUpdateOffset = Offset.zero;

  @override
  Widget build(BuildContext context) {
    return _buildWidget();
  }

  Widget _buildWidget() {
    dLog(() => "build");
    return Positioned(
      left: context.read<FreeBoxController>().leftTopOffsetFilling.dx +
          // context.read<FragmentPoolController>().fragmentPoolNodes[widget.index].fragmentPoolNode.position.dx +
          _onLongPressMoveUpdateOffset.dx,
      top: context.read<FreeBoxController>().leftTopOffsetFilling.dy +
          // context.read<FragmentPoolController>().fragmentPoolNodes[widget.index].fragmentPoolNode.position.dy +
          _onLongPressMoveUpdateOffset.dy,
      child: GestureDetector(
        onLongPressStart: (details) {
          dLog(() => "onLongPressStart");
          _lastOffset = details.globalPosition;
        },
        onLongPressMoveUpdate: (details) {
          _deltaOffset = details.globalPosition - _lastOffset;
          _onLongPressMoveUpdateOffset += _deltaOffset;
          _lastOffset = details.globalPosition;
          setState(() {});
        },
        onLongPressEnd: (details) {
          dLog(() => "onLongPressEnd");
        },
        child: Text("aaa"),
      ),
    );
  }

  // Widget _child() {
  //   switch (context.read<FragmentPoolController>().fragmentPoolNodes[widget.index].fragmentPoolNode.node_type) {
  //     case NodeType.pendingFragment:
  //       return TextButton(
  //         child: Text(context.read<FragmentPoolController>().fragmentPoolNodes[widget.index].fragmentPoolNode.name),
  //         onPressed: () {
  //           G.navigatorPush.pushSheetPage(context);
  //         },
  //         style: TextButton.styleFrom(
  //           primary: Colors.red,
  //           onSurface: Colors.orange,
  //           shadowColor: Colors.purple,
  //         ),
  //       );
  //     case NodeType.pendingGroup:
  //       return TextButton(
  //         child: Text(context.read<FragmentPoolController>().fragmentPoolNodes[widget.index].fragmentPoolNode.name),
  //         onPressed: () {
  //           G.navigatorPush.pushSheetPage(context);
  //         },
  //         style: TextButton.styleFrom(
  //           primary: Colors.red,
  //           onSurface: Colors.orange,
  //           shadowColor: Colors.purple,
  //         ),
  //       );
  //     default:
  //       return TextButton(
  //         child: Text(context.read<FragmentPoolController>().fragmentPoolNodes[widget.index].fragmentPoolNode.name),
  //         onPressed: () {
  //           G.navigatorPush.pushSheetPage(context);
  //         },
  //         style: TextButton.styleFrom(
  //           primary: Colors.red,
  //           onSurface: Colors.orange,
  //           shadowColor: Colors.purple,
  //         ),
  //       );
  //   }
  // }
}
