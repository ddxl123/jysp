// ignore_for_file: non_constant_identifier_names

import 'package:flutter/material.dart';
import 'package:jysp/database/merge_models/MMPoolNode.dart';
import 'package:jysp/tools/Helper.dart';
import 'package:jysp/tools/TDebug.dart';
import 'package:jysp/tools/free_box/FreeBoxController.dart';

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
  SetState? poolNodesSetState;

  final List<MMPoolNode> poolNodes = <MMPoolNode>[];

  final FreeBoxController freeBoxController = FreeBoxController();

  @override
  void dispose() {
    dLog(() => 'FragmentPoolController dispose');
    super.dispose();
  }

  ///
}
