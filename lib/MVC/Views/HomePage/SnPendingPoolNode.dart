import 'package:flutter/material.dart';
import 'package:jysp/Database/Models/MPnPendingPoolNode.dart';
import 'package:jysp/MVC/Views/HomePage/SingleNode.dart';

class SnPendingPoolNode extends StatefulWidget {
  const SnPendingPoolNode({required this.model});
  final MPnPendingPoolNode model;

  @override
  _SnPendingPoolNodeState createState() => _SnPendingPoolNodeState();
}

class _SnPendingPoolNodeState extends State<SnPendingPoolNode> {
  @override
  Widget build(BuildContext context) {
    return SingleNode(
      name: widget.model.get_name ?? 'unknown',
      position: widget.model.get_position ?? 'unknown',
      baseModel: widget.model,
    );
  }
}
