import 'package:flutter/material.dart';
import 'package:jysp/Database/MergeModels/MMPoolNode.dart';
import 'package:jysp/MVC/Views/HomePage/FragmentPool/FragmentPoolCommon/PoolNodeCommon.dart';
import 'package:jysp/MVC/Views/HomePage/FragmentPool/FragmentPoolCommon/PoolNodesCommon.dart';

class CompletePoolNodes extends StatefulWidget {
  @override
  _CompletePoolNodesState createState() => _CompletePoolNodesState();
}

class _CompletePoolNodesState extends State<CompletePoolNodes> {
  @override
  Widget build(BuildContext context) {
    return PoolNodesCommon(
      poolNodeCommon: (MMPoolNode poolNodeMModel) {
        return PoolNodeCommon(poolNodeMModel: poolNodeMModel);
      },
    );
  }
}
