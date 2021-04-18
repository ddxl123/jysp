import 'package:flutter/material.dart';
import 'package:jysp/G/G.dart';
import 'package:jysp/G/GHttp/GHttp.dart';
import 'package:jysp/G/GHttp/RequestInterruptedType.dart';
import 'package:jysp/G/GNavigatorPush.dart';
import 'package:jysp/G/GSqlite/Token.dart';
import 'package:jysp/MVC/Views/HomePage/HomePage.dart';
import 'package:jysp/Tools/RebuildHandler.dart';
import 'package:jysp/Tools/TDebug.dart';

mixin RByEmail {
  ///

  Future<void> sendEmailRequest({
    required RebuildHandler<SendEmailButtonHandlerEnum> handler,
    required TextEditingController emailTextEditingController,
  }) async {
    await Future(() async {
      //
      //
      // 本地验证：

      //
      //
      // 服务器验证：

      // TODO: POST api/register_and_login/by_email/send_email
      await GHttp.sendRequest<Null>(
        method: "POST",
        route: "api/register_and_login/by_email/send_email",
        data: {
          "email": emailTextEditingController.text,
        },
        isAuth: false,
        resultCallback: (code, data) {
          switch (code) {
            case 100:
              dLog(() => "邮箱发送异常");
              handler.rebuildHandle(SendEmailButtonHandlerEnum.unSent);
              break;
            case 101:
              dLog(() => "验证码存储异常");
              handler.rebuildHandle(SendEmailButtonHandlerEnum.unSent);
              break;
            case 102:
              dLog(() => "邮箱发送流程完全成功");
              break;
            case 103:
              dLog(() => "邮箱格式错误");
              handler.rebuildHandle(SendEmailButtonHandlerEnum.unSent);
              break;
            case 104:
              dLog(() => "邮箱格式检测异常");
              handler.rebuildHandle(SendEmailButtonHandlerEnum.unSent);
              break;
            default:
              dLog(() => "未知 code");
              handler.rebuildHandle(SendEmailButtonHandlerEnum.unSent);
          }
        },
        interruptedCallback: (RequestInterruptedType requestInterruptedType) {
          dLog(() => requestInterruptedType);
          handler.rebuildHandle(SendEmailButtonHandlerEnum.unSent);
        },
        sameNotConcurrent: "_sendEmailRequest",
      );
    });
  }

  void verifyEmailRequest({
    required TextEditingController qqEmailTextEditingController,
    required TextEditingController codeTextEditingController,
  }) async {
    await Future(() async {
      //
      //
      // 本地验证

      //
      //
      // 服务器验证
      // TODO: POST api/register_and_login/by_email/verify_email
      await GHttp.sendCreateTokenRequest<Map<String, dynamic>>(
        route: "api/register_and_login/by_email/verify_email",
        willVerifyData: {
          "email": qqEmailTextEditingController.text,
          "code": codeTextEditingController.text,
        },
        resultCallback: (code, data) async {
          switch (code) {
            case 200:
              dLog(() => "邮箱验证码错误!");
              break;
            case 201:
              dLog(() => "邮箱验证异常!");
              break;
            case 202:
              dLog(() => "邮箱格式错误!");
              break;
            case 203:
              dLog(() => "邮箱格式检测异常!");
              break;
            case 204:
              dLog(() => "数据库查找该 email 异常!");
              break;
            case 205:
              dLog(() => "数据库创建新用户异常!");
              break;
            case 206:
              dLog(() => "用户 注册 成功并只响应 token!");
              await Token().setSqliteToken(
                tokens: data,
                success: () {
                  GNavigatorPush.pushInitDownloadPage(G.globalKey.currentContext!);
                },
                fail: (failCode) {},
              );
              break;
            case 207:
              dLog(() => "生成 token 异常!");
              break;
            case 208:
              dLog(() => "用户 登陆 成功并只响应 token!");
              await Token().setSqliteToken(
                tokens: data,
                success: () {
                  GNavigatorPush.pushInitDownloadPage(G.globalKey.currentContext!);
                },
                fail: (failCode) {},
              );
              break;
            case 209:
              dLog(() => "生成 token 异常!", () => data);
              break;
            default:
              dLog(() => "未知 code!");
          }
        },
        tokenCreateFailCallback: (RequestInterruptedType requestInterruptedType) {
          dLog(() => requestInterruptedType);
        },
      );
    });
  }

  ///
}
