import 'package:flutter/material.dart';
import 'package:jysp/G/G.dart';
import 'package:jysp/Tools/RebuildHandler.dart';
import 'package:jysp/Tools/Toast.dart';

mixin ByEmailRequest {
  ///

  // TODO: POST /api/register_and_login/by_email/send_email
  void sendEmailRequest({
    @required RebuildHandler sendEmailButtonRebuildHandler,
    @required TextEditingController qqEmailTextEditingController,
  }) async {
    if (sendEmailButtonRebuildHandler.state["banOnPressed"] == true) {
      print("banOnPressed");
      return;
    }

    //
    //
    // 本地验证：

    //
    //
    // 服务器验证：
    sendEmailButtonRebuildHandler.rebuildHandle(1);

    await G.http.sendRequest(
      method: "POST",
      route: "/register_and_login/by_email/send_email",
      data: {
        "qq_email": qqEmailTextEditingController.text,
      },
      result: ({response, unknownCode}) {
        switch (response.data["code"]) {
          case 100:
            showToast("验证码已发送，请注意查收!");
            break;
          case 101:
            showToast("验证码发送异常!");
            sendEmailButtonRebuildHandler.rebuildHandle(0);
            break;
          case 103:
            showToast("邮箱格式错误!");
            sendEmailButtonRebuildHandler.rebuildHandle(0);
            break;
          case 104:
            showToast("数据库存在多个该邮箱!");
            sendEmailButtonRebuildHandler.rebuildHandle(0);
            break;
          default:
            unknownCode();
            sendEmailButtonRebuildHandler.rebuildHandle(0);
        }
      },
      haveError: () {
        sendEmailButtonRebuildHandler.rebuildHandle(0);
      },
      notConcurrent: "_sendEmailRequest",
    );
  }

  // TODO: POST /api/register_and_login/by_email/verify_email
  void verifyEmailRequest({
    @required TextEditingController qqEmailTextEditingController,
    @required TextEditingController codeTextEditingController,
  }) async {
    //
    //
    // 本地验证

    //
    //
    // 服务器验证
    await G.http.sendRequest(
      method: "POST",
      route: "/register_and_login/by_email/verify_email",
      data: {
        "qq_email": qqEmailTextEditingController.text,
        "code": codeTextEditingController.text,
      },
      result: ({unknownCode, response}) {
        switch (response.data["code"]) {
          case 105:
            showToast("验证码正确!");
            break;
          case 106:
            showToast("验证码错误!");
            break;
          case 107:
            showToast("邮箱验证异常!");
            break;
          case 108:
            showToast("邮箱格式错误!");
            break;
          default:
            unknownCode();
        }
      },
      haveError: null,
      notConcurrent: "_verifyEmailRequest",
    );
  }

  ///
}
