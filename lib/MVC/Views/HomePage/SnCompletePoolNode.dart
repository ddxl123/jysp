import 'package:flutter/material.dart';
import 'package:jysp/Database/models/MPnCompletePoolNode.dart';
import 'package:jysp/MVC/Controllers/FragmentPoolController/FragmentPoolController.dart';
import 'package:jysp/MVC/Views/HomePage/SingleNode.dart';
import 'package:provider/provider.dart';

class SnCompletePoolNode extends StatefulWidget {
  SnCompletePoolNode({required this.index});
  final int index;
  @override
  _SnCompletePoolNodeState createState() => _SnCompletePoolNodeState();
}

class _SnCompletePoolNodeState extends State<SnCompletePoolNode> {
  @override
  Widget build(BuildContext context) {
    MPnCompletePoolNode mPnCompletePoolNode = context.read<FragmentPoolController>().completePoolNodes[widget.index];
    return SingleNode(
      name: mPnCompletePoolNode.get_name ?? "unknown",
      position: mPnCompletePoolNode.get_position ?? "unknown",
    );
  }
}
