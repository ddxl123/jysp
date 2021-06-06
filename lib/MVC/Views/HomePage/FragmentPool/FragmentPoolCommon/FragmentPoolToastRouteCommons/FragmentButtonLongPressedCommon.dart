import 'package:flutter/material.dart';
import 'package:jysp/Tools/RoundedBox..dart';
import 'package:jysp/Tools/TDebug.dart';
import 'package:jysp/Tools/Toast/ShowToast.dart';

import 'package:jysp/Tools/Toast/ToastRoute.dart';

class FragmentButtonLongPressedCommon extends ToastRoute {
  FragmentButtonLongPressedCommon(BuildContext fatherContext) : super(fatherContext);

  @override
  Color get backgroundColor => Colors.transparent;

  @override
  double get backgroundOpacity => 0.0;

  @override
  List<Widget> body() {
    return <Widget>[
      AutoPositioned(
        child: RoundedBox(
          children: <Widget>[
            TextButton(onPressed: () {}, child: const Text('data')),
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
  Future<Toast<bool>> whenPop(PopResult? popResult) async {
    try {
      if (popResult == null || popResult.popResultSelect == PopResultSelect.clickBackground) {
        return showToast<bool>(text: '未选择', returnValue: true);
      } else {
        throw 'unknown result: $popResult';
      }
    } catch (e, r) {
      dLog(() => '$e---$r');
      return showToast(text: 'err', returnValue: false);
    }
  }
}
