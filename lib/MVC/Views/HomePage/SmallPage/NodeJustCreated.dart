import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:jysp/MVC/Views/HomePage/SmallPage/SmallRoute.dart';

class NodeJustCreated extends SmallRoute<bool> {
  NodeJustCreated({required this.left, required this.top, required this.future});

  /// 将要把输入框放在屏幕 left 多远的地方
  final double left;

  /// 将要把输入框放在屏幕 top 多远的地方
  final double top;

  /// 完成输入后的异步操作
  final Future<void> Function(String) future;

  /// 输入控制器
  final TextEditingController _txtEditingController = TextEditingController();

  @override
  Color get backgroundColor => Colors.black;

  @override
  double get backgroundOpacity => 0.5;

  @override
  bool get isUpPop => true;

  /// 键盘有关
  final FocusNode _focusNode = FocusNode();

  /// 是否隐藏加载状态
  bool _isHideLoading = true;

  /// 异步只能执行一次
  bool _futureOnceOk = false;

  @override
  bool get isBodyCenter => false;

  @override
  void init() {}

  @override
  void rebuild() {
    // 自动升起键盘
    FocusScope.of(context!).requestFocus(_focusNode);
  }

  @override
  List<Positioned> body() {
    return <Positioned>[
      _input(),
      _loading(),
    ];
  }

  /// 输入框
  Positioned _input() {
    return Positioned(
      top: top,
      left: left,
      width: 100,
      child: Container(
        child: TextField(
          focusNode: _focusNode,
          controller: _txtEditingController,
          onEditingComplete: () {
            // 点击提交时也 pop
            Navigator.pop(context!);
          },
        ),
        color: Colors.white,
      ),
    );
  }

  /// 等待画面
  Positioned _loading() {
    return Positioned(
      top: 0,
      width: MediaQueryData.fromWindow(window).size.width,
      height: MediaQueryData.fromWindow(window).size.height,
      child: Offstage(
        offstage: _isHideLoading,
        child: Opacity(
          opacity: 0.5,
          child: Container(
            alignment: Alignment.center,
            color: Colors.white,
            child: const Text('存储中...'),
          ),
        ),
      ),
    );
  }

  @override
  bool didPop(bool? result) {
    if (result == true) {
      // 无论 didPop 输入什么值，都会返回 true
      return super.didPop(null);
    }

    // 显示 loading
    _isHideLoading = false;
    setState(() {});

    // 执行异步。无论异步执行成功与否，只要执行完成便 pop
    if (!_futureOnceOk) {
      future(_txtEditingController.text).whenComplete(
        () {
          didPop(true);
        },
      );
      _futureOnceOk = true;
    }

    return false;
  }
}
