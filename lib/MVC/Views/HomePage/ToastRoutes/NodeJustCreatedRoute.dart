import 'package:flutter/material.dart';
import 'package:jysp/Tools/TDebug.dart';
import 'package:jysp/Tools/Toast/ShowToast.dart';
import 'package:jysp/Tools/Toast/Toast.dart';

class NodeJustCreatedRoute extends ToastRoute {
  NodeJustCreatedRoute({required this.left, required this.top, required this.future});

  /// 将要把输入框放在屏幕 left 多远的地方
  final double left;

  /// 将要把输入框放在屏幕 top 多远的地方
  final double top;

  @override
  AlignmentDirectional get stackAlignment => AlignmentDirectional.topStart;

  /// 完成输入后的异步操作
  final Future<void> Function(String) future;

  /// 输入控制器
  final TextEditingController _txtEditingController = TextEditingController();

  /// 键盘有关
  final FocusNode _focusNode = FocusNode();

  @override
  void init() {}

  @override
  void rebuild() {
    // 自动升起键盘
    FocusScope.of(context).requestFocus(_focusNode);
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  List<Positioned> body() {
    return <Positioned>[
      _input(),
    ];
  }

  /// 输入框
  Positioned _input() {
    return Positioned(
      top: top,
      left: left,
      child: Container(
        width: 100,
        color: Colors.white,
        child: TextField(
          focusNode: _focusNode,
          controller: _txtEditingController,
          onEditingComplete: () {
            // 不仅返回时执行 future ，点击键盘的提交按钮时也 pop->future
            Navigator.pop(context);
          },
        ),
      ),
    );
  }

  @override
  Future<Toast<bool>> Function(int?) get whenPop {
    return (int? result) async {
      try {
        if (result == null) {
          await future(_txtEditingController.text);
          return showToast(text: '创建成功', returnValue: true);
        } else {
          throw 'result err: $result';
        }
      } catch (e) {
        dLog(() => e);
        return showToast(text: '创建失败', returnValue: false);
      }
    };
  }
}
