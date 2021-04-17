import 'package:flutter/material.dart';
import 'package:jysp/G/GNavigatorPush.dart';
import 'package:jysp/Tools/FreeBox/FreeBoxController.dart';
import 'package:jysp/Tools/TDebug.dart';
import 'package:provider/provider.dart';

class SingleNode extends StatefulWidget {
  SingleNode({required this.name, required this.position});
  final String name;
  final String position;

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
    // dLog(() => "build");
    double left;
    double top;
    try {
      List<String> sp = widget.position.split(",");
      left = double.parse(sp[0]);
      top = double.parse(sp[1]);
    } catch (e) {
      dLog(() => e);
      left = 0;
      top = 0;
    }
    return Positioned(
      left: context.read<FreeBoxController>().leftTopOffsetFilling.dx + left + _onLongPressMoveUpdateOffset.dx,
      top: context.read<FreeBoxController>().leftTopOffsetFilling.dy + top + _onLongPressMoveUpdateOffset.dy,
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
        child: _body(),
      ),
    );
  }

  Widget _body() {
    return TextButton(
      child: Text(widget.name),
      onPressed: () {
        GNavigatorPush.pushSheetPage(context);
      },
      style: TextButton.styleFrom(
        primary: Colors.red,
        onSurface: Colors.orange,
        shadowColor: Colors.purple,
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
