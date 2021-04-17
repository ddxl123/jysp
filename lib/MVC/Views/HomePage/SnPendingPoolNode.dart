import 'package:flutter/material.dart';
import 'package:jysp/Database/models/MPnPendingPoolNode.dart';
import 'package:jysp/MVC/Controllers/FragmentPoolController/FragmentPoolController.dart';
import 'package:jysp/MVC/Views/HomePage/SingleNode.dart';
import 'package:provider/provider.dart';

class SnPendingPoolNode extends StatefulWidget {
  SnPendingPoolNode({required this.index});
  final int index;
  @override
  _SnPendingPoolNodeState createState() => _SnPendingPoolNodeState();
}

class _SnPendingPoolNodeState extends State<SnPendingPoolNode> {
  @override
  Widget build(BuildContext context) {
    MPnPendingPoolNode mPnPendingPoolNode = context.read<FragmentPoolController>().pendingPoolNodes[widget.index];
    return SingleNode(
      name: mPnPendingPoolNode.get_name ?? "unknown",
      position: mPnPendingPoolNode.get_position ?? "unknown",
    );
  }
}
