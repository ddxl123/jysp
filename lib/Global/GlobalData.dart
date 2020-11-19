import 'package:flutter/material.dart';

class GlobalData {
  // 工厂模式
  factory GlobalData() => _getInstance();
  static GlobalData get instance => _getInstance();
  static GlobalData _instance;
  GlobalData._internal() {
    // 初始化
  }
  static GlobalData _getInstance() {
    if (_instance == null) {
      _instance = GlobalData._internal();
    }
    return _instance;
  }

  final GlobalKey<NavigatorState> navigatorState = GlobalKey();

  final List<dynamic> fragmentPoolPendingNodes = [];

  Function(Function callback) startResetLayout = (callback) {};

  /// 0表示 待定池，1表示 记忆池，2表示 完成池
  SelectedFragmentPool selectedFragmentPool = SelectedFragmentPool.pendingPool;
}

enum SelectedFragmentPool {
  pendingPool,
  memoryPool,
  completePool,
}
