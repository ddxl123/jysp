import 'package:flutter/cupertino.dart';
import 'package:jysp/Tools/TDebug.dart';

enum Compare { frontBig, backBig, equal }

class Helper {
  static Compare compare(int front, int back) {
    if (front > back) {
      return Compare.frontBig;
    } else if (front < back) {
      return Compare.backBig;
    } else {
      return Compare.equal;
    }
  }
}

typedef SetState = void Function(void Function());

/// 将 '111,222' 字符串转化成 Offset(111,222)
///
/// 若解析错误，则返回 [Offset.zero]
Offset stringToOffset(String? offsetStr) {
  try {
    final List<String> sp = offsetStr!.split(',');
    return Offset(double.parse(sp[0]), double.parse(sp[1]));
  } catch (e) {
    dLog(() => 'parse position err: ', () => e);
    return Offset.zero;
  }
}
