import 'package:flutter/material.dart';
import 'package:jysp/Database/MergeModels/MMPoolNode.dart';
import 'package:jysp/MVC/Views/HomePage/FragmentPool/FragmentPoolCommon/PoolNodeCommon.dart';
import 'package:jysp/MVC/Views/HomePage/FragmentPool/FragmentPoolCommon/PoolNodesCommon.dart';

class RulePoolNodes extends StatefulWidget {
  @override
  _RulePoolNodesState createState() => _RulePoolNodesState();
}

class _RulePoolNodesState extends State<RulePoolNodes> {
  @override
  Widget build(BuildContext context) {
    return PoolNodesCommon(
      poolNodeCommon: (MMPoolNode poolNodeMModel) {
        return PoolNodeCommon(poolNodeMModel: poolNodeMModel);
      },
    );
  }
}
