import 'package:flutter/material.dart';
import 'package:jysp/Database/MergeModels/MMPoolNode.dart';
import 'package:jysp/MVC/Views/HomePage/FragmentPool/FragmentPoolCommon/PoolNodeCommon.dart';
import 'package:jysp/MVC/Views/HomePage/FragmentPool/FragmentPoolCommon/PoolNodesCommon.dart';

class MemoryPoolNodes extends StatefulWidget {
  @override
  _MemoryPoolNodesState createState() => _MemoryPoolNodesState();
}

class _MemoryPoolNodesState extends State<MemoryPoolNodes> {
  @override
  Widget build(BuildContext context) {
    return PoolNodesCommon(
      poolNodeCommon: (MMPoolNode poolNodeMModel) {
        return PoolNodeCommon(poolNodeMModel: poolNodeMModel);
      },
    );
  }
}
