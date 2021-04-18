import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:jysp/Tools/TDebug.dart';

class NodeJustCreated extends OverlayRoute {
  ///

  NodeJustCreated({required this.left, required this.top, required this.future});

  /// 将要把输入框放在屏幕 left 多远的地方
  final double left;

  /// 将要把输入框放在屏幕 top 多远的地方
  final double top;

  /// 完成输入后的异步操作
  final Future<void> Function(String) future;

  /// 键盘有关
  FocusNode _focusNode = FocusNode();

  /// 输入控制器
  TextEditingController _txtEditingController = TextEditingController();

  /// 当前路由内在的 context
  late BuildContext _thisContext;

  /// 当前路由内在的 setState
  late Function(Function()) _thisSetState;

  /// 是否隐藏加载状态
  bool _isHideLoading = true;

  /// 异步只能执行一次
  bool _futureOnceOk = false;

  @override
  Iterable<OverlayEntry> createOverlayEntries() {
    return [
      OverlayEntry(
        builder: (_) {
          return StatefulBuilder(
            builder: (ctx, setState) {
              _thisContext = ctx;
              _thisSetState = setState;
              // 自动升起键盘
              FocusScope.of(ctx).requestFocus(_focusNode);
              return Material(
                type: MaterialType.transparency,
                child: Stack(
                  children: [
                    _background(),
                    _input(),
                    _loading(),
                  ],
                ),
              );
            },
          );
        },
      ),
    ];
  }

  /// 背景
  Widget _background() {
    return Positioned(
      top: 0,
      width: MediaQueryData.fromWindow(window).size.width,
      height: MediaQueryData.fromWindow(window).size.height,
      child: Listener(
        onPointerUp: (_) {
          dLog(() => "onPointerUp");
          Navigator.pop(_thisContext);
        },
        child: Opacity(
          opacity: 0.5,
          child: Container(color: Colors.black),
        ),
      ),
    );
  }

  /// 输入框
  Widget _input() {
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
            Navigator.pop(_thisContext);
          },
        ),
        color: Colors.white,
      ),
    );
  }

  /// 等待画面
  Widget _loading() {
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
            child: Text("存储中..."),
          ),
        ),
      ),
    );
  }

  @override
  bool didPop(isPop) {
    if (isPop == true) {
      // 无论 didPop 输入什么值，都会返回 true
      return super.didPop(null);
    }

    // 显示 loading
    _isHideLoading = false;
    _thisSetState(() {});

    // 执行异步。无论异步执行成功与否，只要执行完成便 pop
    if (!_futureOnceOk) {
      future(_txtEditingController.text).whenComplete(
        () {
          this.didPop(true);
        },
      );
      _futureOnceOk = true;
    }

    return false;
  }

  ///
}
