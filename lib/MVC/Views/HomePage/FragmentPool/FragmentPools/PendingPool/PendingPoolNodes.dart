import 'package:flutter/material.dart';
import 'package:jysp/Database/MergeModels/MMPoolNode.dart';
import 'package:jysp/MVC/Views/HomePage/FragmentPool/FragmentPoolCommon/PoolNodeCommon.dart';
import 'package:jysp/MVC/Views/HomePage/FragmentPool/FragmentPoolCommon/PoolNodesCommon.dart';

class PendingPoolNodes extends StatefulWidget {
  @override
  _PendingPoolNodesState createState() => _PendingPoolNodesState();
}

class _PendingPoolNodesState extends State<PendingPoolNodes> {
  @override
  Widget build(BuildContext context) {
    return PoolNodesCommon(
      poolNodeCommon: (MMPoolNode poolNodeMModel) {
        return PoolNodeCommon(poolNodeMModel: poolNodeMModel);
      },
    );
  }
}
