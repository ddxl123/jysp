import 'package:flutter/material.dart';
import 'package:jysp/Database/Models/MPnMemoryPoolNode.dart';
import 'package:jysp/MVC/Views/HomePage/SingleNode.dart';

class SnMemoryPoolNode extends StatefulWidget {
  const SnMemoryPoolNode({required this.model});
  final MPnMemoryPoolNode model;
  @override
  _SnMemoryPoolNodeState createState() => _SnMemoryPoolNodeState();
}

class _SnMemoryPoolNodeState extends State<SnMemoryPoolNode> {
  @override
  Widget build(BuildContext context) {
    return SingleNode(
      name: widget.model.get_name ?? 'unknown',
      position: widget.model.get_position ?? 'unknown',
      baseModel: widget.model,
    );
  }
}
