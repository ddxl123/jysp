import 'package:flutter/material.dart';
import 'package:jysp/Database/Models/MPnMemoryPoolNode.dart';
import 'package:jysp/MVC/Controllers/FragmentPoolController/FragmentPoolController.dart';
import 'package:jysp/MVC/Views/HomePage/SingleNode.dart';
import 'package:provider/provider.dart';

class SnMemoryPoolNode extends StatefulWidget {
  const SnMemoryPoolNode({required this.index});
  final int index;
  @override
  _SnMemoryPoolNodeState createState() => _SnMemoryPoolNodeState();
}

class _SnMemoryPoolNodeState extends State<SnMemoryPoolNode> {
  @override
  Widget build(BuildContext context) {
    final MPnMemoryPoolNode mPnMemoryPoolNode = context.read<FragmentPoolController>().memoryPoolNodes[widget.index];
    return SingleNode(
      name: mPnMemoryPoolNode.get_name ?? 'unknown',
      position: mPnMemoryPoolNode.get_position ?? 'unknown',
    );
  }
}
