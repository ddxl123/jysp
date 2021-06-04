import 'package:flutter/material.dart';
import 'package:jysp/Database/MergeModels/MMPoolNode.dart';
import 'package:jysp/G/GNavigatorPush.dart';
import 'package:jysp/Tools/RoundedBox..dart';
import 'package:jysp/Tools/TDebug.dart';
import 'package:jysp/Tools/Toast/ShowToast.dart';
import 'package:jysp/Tools/Toast/ToastRoute.dart';

class NodeMoreCommon extends ToastRoute {
  NodeMoreCommon(BuildContext fatherContext, {required this.mmodel}) : super(fatherContext);
  final MMPoolNode mmodel;

  @override
  Color get backgroundColor => Colors.white;

  @override
  double get backgroundOpacity => 0.0;

  @override
  List<Widget> body() {
    return <Widget>[
      AutoPositioned(
        child: RoundedBox(
          children: <Widget>[
            TextButton(
              child: const Text('创建新碎片'),
              onPressed: () {
                GNavigatorPush.pushCreateFragmentPage(context, mmodel);
              },
            ),
          ],
        ),
      ),
    ];
  }

  @override
  void init() {}

  @override
  void rebuild() {}

  @override
  Future<Toast<bool>> Function(PopResult? result) get whenPop {
    return (PopResult? result) async {
      try {
        if (result == null || result.popResultSelect == PopResultSelect.clickBackground) {
          return showToast<bool>(text: '未选择', returnValue: true);
        } else {
          throw 'unknown result.popResultSelect: ${result.popResultSelect}';
        }
      } catch (e) {
        dLog(() => e);
        return showToast<bool>(text: 'err', returnValue: false);
      }
    };
  }
}
