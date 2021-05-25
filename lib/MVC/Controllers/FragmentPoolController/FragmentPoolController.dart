// ignore_for_file: non_constant_identifier_names
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:jysp/Database/MergeModels/MMPoolNode.dart';
import 'package:jysp/Tools/FreeBox/FreeBoxController.dart';

class FragmentPoolController extends ChangeNotifier {
  ///
  FragmentPoolController({required this.poolNodesTableName});

  /// 当前碎片池节点对应的数据表名称
  String poolNodesTableName;

  /// 默认碎片池视口位置
  Offset defaultViewPosition = Offset.zero;

  /// 默认碎片池缩放
  double defaultViewScale = 1.0;

  /// [FragmentPool] 的 setState 函数
  Function(Function()) needInitStateForSetState = (_) {};

  final List<MMPoolNode> poolNodes = <MMPoolNode>[];

  final FreeBoxController freeBoxController = FreeBoxController();

  ///
}
