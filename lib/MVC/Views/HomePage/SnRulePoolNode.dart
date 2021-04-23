import 'package:flutter/material.dart';
import 'package:jysp/Database/Models/MPnRulePoolNode.dart';
import 'package:jysp/MVC/Controllers/FragmentPoolController/FragmentPoolController.dart';
import 'package:jysp/MVC/Views/HomePage/SingleNode.dart';
import 'package:provider/provider.dart';

class SnRulePoolNode extends StatefulWidget {
  const SnRulePoolNode({required this.index});
  final int index;
  @override
  _SnRulePoolNodeState createState() => _SnRulePoolNodeState();
}

class _SnRulePoolNodeState extends State<SnRulePoolNode> {
  @override
  Widget build(BuildContext context) {
    final MPnRulePoolNode mPnRulePoolNode = context.read<FragmentPoolController>().rulePoolNodes[widget.index];
    return SingleNode(
      name: mPnRulePoolNode.get_name ?? 'unknown',
      position: mPnRulePoolNode.get_position ?? 'unknown',
    );
  }
}
