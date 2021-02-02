import 'package:flutter/material.dart';
import 'package:jysp/LWCR/Request/RegisterAndLoginRequest/ByEmailRequest.dart';
import 'package:jysp/Tools/RebuildHandler.dart';

class _Init extends ChangeNotifier {
  /// 书写构造函数进行初始化的地方。
  /// 继承 ChangeNotifier 的目的是进行 setState
}

mixin _Root on _Init, ByEmailRequest {
  /// 顶层调用的地方。
  ///
  TextEditingController qqEmailTextEditingController = TextEditingController();
  TextEditingController codeTextEditingController = TextEditingController();

  /// 触发 [rebuild], 同时返回代码, 根据代码进行处理。
  RebuildHandler sendEmailButtonRebuildHandler = RebuildHandler();
}

mixin _Other on _Root {
  /// 其他逻辑
}

class LoginPageController extends _Init with ByEmailRequest, _Root, _Other {}
