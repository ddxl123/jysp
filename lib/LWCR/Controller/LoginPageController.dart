import 'package:flutter/material.dart';
import 'package:jysp/LWCR/Request/RegisterAndLoginRequest/ByEmailRequest.dart';
import 'package:jysp/Tools/RebuildHandler.dart';

class LoginPageController with ByEmailRequest {
  TextEditingController qqEmailTextEditingController = TextEditingController();
  TextEditingController codeTextEditingController = TextEditingController();

  /// 触发 [rebuild], 同时返回代码, 根据代码进行处理。
  RebuildHandler sendEmailButtonRebuildHandler = RebuildHandler();
}
