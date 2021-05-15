import 'package:flutter/material.dart';
import 'package:jysp/Database/Models/MPnCompletePoolNode.dart';
import 'package:jysp/MVC/Views/HomePage/SingleNode.dart';

class SnCompletePoolNode extends StatefulWidget {
  const SnCompletePoolNode({required this.model});
  final MPnCompletePoolNode model;
  @override
  _SnCompletePoolNodeState createState() => _SnCompletePoolNodeState();
}

class _SnCompletePoolNodeState extends State<SnCompletePoolNode> {
  @override
  Widget build(BuildContext context) {
    return SingleNode(
      name: widget.model.get_name ?? 'unknown',
      position: widget.model.get_position ?? 'unknown',
      baseModel: widget.model,
    );
  }
}
