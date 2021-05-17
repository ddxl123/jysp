import 'package:flutter/material.dart';
import 'package:jysp/Tools/RoundedBox..dart';
import 'package:jysp/Tools/Toast/Toast.dart';

class NodeRenameRoute extends ToastRoute {
  @override
  AlignmentDirectional get stackAlignment => AlignmentDirectional.center;

  final FocusNode _focusNode = FocusNode();

  double positionedButtom = 0.0;

  @override
  List<Positioned> body() {
    return <Positioned>[
      Positioned(
        child: Container(
          alignment: Alignment.center,
          child: RoundedBox(
            width: 200,
            height: null,
            pidding: const EdgeInsets.all(20),
            children: <Widget>[
              Container(
                color: Colors.white,
                height: 50,
                child: TextField(
                  focusNode: _focusNode,
                ),
              ),
              Container(
                color: Colors.white,
                width: 500,
                height: 1000,
                child: const Text('data'),
              ),
              Container(
                color: Colors.white,
                height: 50,
                child: TextField(
                  focusNode: _focusNode,
                ),
              ),
            ],
          ),
        ),
      ),
    ];
  }

  @override
  void init() {
    // 自动对焦
    _focusNode.requestFocus();
  }

  @override
  void rebuild() {
    // 获取键盘高度
    positionedButtom = MediaQuery.of(context).viewInsets.bottom;
  }

  @override
  Future<Toast<bool>> Function(int? result)? get whenPop => null;
}
