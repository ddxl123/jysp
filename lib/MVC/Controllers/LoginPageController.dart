import 'dart:async';

import 'package:flutter/material.dart';
import 'package:jysp/mvc/request/online/register_and_login/RByEmail.dart';
import 'package:jysp/tools/RebuildHandler.dart';

class _Init extends ChangeNotifier {}

mixin _Root on _Init, RByEmail {
  ///
  TextEditingController emailTextEditingController = TextEditingController(text: '1033839760@qq.com');
  TextEditingController codeTextEditingController = TextEditingController();

  /// 触发 [setState], 同时返回代码, 根据代码进行处理。
  RebuildHandler<SendEmailButtonHandlerEnum> sendEmailButtonRebuildHandler = RebuildHandler<SendEmailButtonHandlerEnum>(SendEmailButtonHandlerEnum.unSent);

  @override
  void dispose() {
    final dynamic timer = sendEmailButtonRebuildHandler.state['timer'];
    if (timer is Timer) {
      timer.cancel();
    }
    emailTextEditingController.dispose();
    codeTextEditingController.dispose();
    super.dispose();
  }
}

mixin _Other on _Root {
  /// 其他逻辑
}

class LoginPageController extends _Init with RByEmail, _Root, _Other {}
