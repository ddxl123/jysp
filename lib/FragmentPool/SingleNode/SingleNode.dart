import 'package:flutter/material.dart';
import 'package:jysp/Database/both/TFragmentPoolNode.dart';
import 'package:jysp/FragmentPool/SingleNode/SingleNodeLine.dart';
import 'package:jysp/LWCR/Controller/FragmentPoolController.dart';
import 'package:jysp/Tools/TDebug.dart';

class SingleNode extends StatefulWidget {
  SingleNode({
    required this.index,
    required this.fragmentPoolController,
  });

  final int index;
  final FragmentPoolController fragmentPoolController;

  @override
  SingleNodeState createState() => SingleNodeState();
}

class SingleNodeState extends State<SingleNode> {
  ///

  Offset _lastOffset = Offset.zero;
  Offset _deltaOffset = Offset.zero;

  @override
  Widget build(BuildContext context) {
    return _buildWidget();
  }

  Widget _buildWidget() {
    return StatefulBuilder(
      builder: (context, rebuild) {
        return Positioned(
          left: widget.fragmentPoolController.fragmentPoolNodes[widget.index].fragmentPoolNode.position[0],
          top: widget.fragmentPoolController.fragmentPoolNodes[widget.index].fragmentPoolNode.position[1],
          child: GestureDetector(
            child: _child(),
            // onLongPressStart: (details) {
            //   dLog(() => "onLongPressStart");
            //   _lastOffset = details.globalPosition;
            // },
            onLongPressMoveUpdate: (details) {
              _deltaOffset = details.globalPosition - _lastOffset;
              dLog(() => _deltaOffset);
              dLog(() => "1:", () => widget.fragmentPoolController.fragmentPoolNodes[widget.index].fragmentPoolNode.position[0]);
              widget.fragmentPoolController.fragmentPoolNodes[widget.index].fragmentPoolNode.position[0] += _deltaOffset.dx;
              widget.fragmentPoolController.fragmentPoolNodes[widget.index].fragmentPoolNode.position[1] += _deltaOffset.dy;
              dLog(() => "2:", () => widget.fragmentPoolController.fragmentPoolNodes[widget.index].fragmentPoolNode.position[0]);
              rebuild(() {});
            },
            // onLongPressEnd: (details) {
            //   dLog(() => "onLongPressEnd");
            // },
          ),
        );
      },
    );
  }

  Widget _child() {
    switch (widget.fragmentPoolController.fragmentPoolNodes[widget.index].fragmentPoolNode.node_type) {
      case NodeType.pendingFragment:
        return TextButton(child: Text(widget.fragmentPoolController.fragmentPoolNodes[widget.index].fragmentPoolNode.name), onPressed: () {});
      case NodeType.pendingGroup:
        return TextButton(child: Text(widget.fragmentPoolController.fragmentPoolNodes[widget.index].fragmentPoolNode.name), onPressed: () {});
      default:
        return TextButton(child: Text(widget.fragmentPoolController.fragmentPoolNodes[widget.index].fragmentPoolNode.name), onPressed: () {});
    }
  }
}
