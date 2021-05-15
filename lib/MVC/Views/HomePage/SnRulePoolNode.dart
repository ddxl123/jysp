import 'package:flutter/material.dart';
import 'package:jysp/Database/Models/MPnRulePoolNode.dart';
import 'package:jysp/MVC/Views/HomePage/SingleNode.dart';

class SnRulePoolNode extends StatefulWidget {
  const SnRulePoolNode({required this.model});
  final MPnRulePoolNode model;
  @override
  _SnRulePoolNodeState createState() => _SnRulePoolNodeState();
}

class _SnRulePoolNodeState extends State<SnRulePoolNode> {
  @override
  Widget build(BuildContext context) {
    return SingleNode(
      name: widget.model.get_name ?? 'unknown',
      position: widget.model.get_position ?? 'unknown',
      baseModel: widget.model,
    );
  }
}
