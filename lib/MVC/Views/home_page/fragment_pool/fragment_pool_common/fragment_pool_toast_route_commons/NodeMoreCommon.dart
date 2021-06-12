import 'package:flutter/material.dart';
import 'package:jysp/database/merge_models/MMPoolNode.dart';
import 'package:jysp/g/GNavigatorPush.dart';
import 'package:jysp/tools/RoundedBox..dart';
import 'package:jysp/tools/TDebug.dart';
import 'package:jysp/tools/toast/ShowToast.dart';
import 'package:jysp/tools/toast/ToastRoute.dart';

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
  Future<Toast<bool>> whenPop(PopResult? popResult) async {
    try {
      if (popResult == null || popResult.popResultSelect == PopResultSelect.clickBackground) {
        return showToast<bool>(text: '未选择', returnValue: true);
      } else {
        throw 'unknown result.popResultSelect: ${popResult.popResultSelect}';
      }
    } catch (e) {
      dLog(() => e);
      return showToast<bool>(text: 'err', returnValue: false);
    }
  }
}
