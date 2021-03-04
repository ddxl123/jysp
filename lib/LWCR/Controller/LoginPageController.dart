import 'package:flutter/material.dart';
import 'package:jysp/LWCR/Request/RegisterAndLoginRequest/ByEmailRequest.dart';
import 'package:jysp/Tools/RebuildHandler.dart';

class _Init extends ChangeNotifier {}

mixin _Root on _Init, ByEmailRequest {
  ///
  TextEditingController emailTextEditingController = TextEditingController(text: "1033839760@qq.com");
  TextEditingController codeTextEditingController = TextEditingController();

  /// 触发 [rebuild], 同时返回代码, 根据代码进行处理。
  RebuildHandler<SendEmailButtonHandlerEnum> sendEmailButtonRebuildHandler = RebuildHandler<SendEmailButtonHandlerEnum>(SendEmailButtonHandlerEnum.unSent);
}

mixin _Other on _Root {
  /// 其他逻辑
}

class LoginPageController extends _Init with ByEmailRequest, _Root, _Other {}
