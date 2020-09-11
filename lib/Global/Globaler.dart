import 'package:flutter/material.dart';

class Globaler {
  // 工厂模式
  factory Globaler() => _getInstance();
  static Globaler get instance => _getInstance();
  static Globaler _instance;
  Globaler._internal() {
    // 初始化
    print("Globaler_internal");
  }
  static Globaler _getInstance() {
    if (_instance == null) {
      _instance = Globaler._internal();
    }
    return _instance;
  }

  final GlobalKey<NavigatorState> navigatorState = GlobalKey();
  OverlayState overlayState;
  final List<OverlayEntry> overlayEntryList = [];
}
