import 'package:flutter/material.dart';
import 'package:jysp/database/g_sqlite/Token.dart';
import 'package:jysp/g/G.dart';
import 'package:jysp/g/GNavigatorPush.dart';
import 'package:jysp/g/g_http/GHttp.dart';
import 'package:jysp/g/g_http/RequestInterruptedType.dart';
import 'package:jysp/tools/RebuildHandler.dart';
import 'package:jysp/tools/TDebug.dart';

mixin RByEmail {
  ///

  Future<void> sendEmailRequest({
    required RebuildHandler<SendEmailButtonHandlerEnum> handler,
    required TextEditingController emailTextEditingController,
  }) async {
    await Future<void>(() async {
      //
      //
      // 本地验证：

      //
      //
      // 服务器验证：

      // TODO: POST api/register_and_login/by_email/send_email
      await GHttp.sendRequest<void>(
        method: 'POST',
        route: 'api/register_and_login/by_email/send_email',
        data: <String, String>{
          'email': emailTextEditingController.text,
        },
        isAuth: false,
        resultCallback: (int code, void data) {
          switch (code) {
            case 100:
              dLog(() => '邮箱发送异常');
              handler.rebuildHandle(SendEmailButtonHandlerEnum.unSent);
              break;
            case 101:
              dLog(() => '验证码存储异常');
              handler.rebuildHandle(SendEmailButtonHandlerEnum.unSent);
              break;
            case 102:
              dLog(() => '邮箱发送流程完全成功');
              break;
            case 103:
              dLog(() => '邮箱格式错误');
              handler.rebuildHandle(SendEmailButtonHandlerEnum.unSent);
              break;
            case 104:
              dLog(() => '邮箱格式检测异常');
              handler.rebuildHandle(SendEmailButtonHandlerEnum.unSent);
              break;
            default:
              dLog(() => '未知 code');
              handler.rebuildHandle(SendEmailButtonHandlerEnum.unSent);
          }
        },
        interruptedCallback: (RequestInterruptedType requestInterruptedType) {
          dLog(() => requestInterruptedType);
          handler.rebuildHandle(SendEmailButtonHandlerEnum.unSent);
        },
        sameNotConcurrent: '_sendEmailRequest',
      );
    });
  }

  Future<void> verifyEmailRequest({
    required TextEditingController qqEmailTextEditingController,
    required TextEditingController codeTextEditingController,
  }) async {
    await Future<void>(() async {
      //
      //
      // 本地验证

      //
      //
      // 服务器验证
      // TODO: POST api/register_and_login/by_email/verify_email
      await GHttp.sendCreateTokenRequest(
        route: 'api/register_and_login/by_email/verify_email',
        willVerifyData: <String, String>{
          'email': qqEmailTextEditingController.text,
          'code': codeTextEditingController.text,
        },
        resultCallback: (int code, Map<String, String> data) async {
          switch (code) {
            case 200:
              dLog(() => '邮箱验证码错误!');
              break;
            case 201:
              dLog(() => '邮箱验证异常!');
              break;
            case 202:
              dLog(() => '邮箱格式错误!');
              break;
            case 203:
              dLog(() => '邮箱格式检测异常!');
              break;
            case 204:
              dLog(() => '数据库查找该 email 异常!');
              break;
            case 205:
              dLog(() => '数据库创建新用户异常!');
              break;
            case 206:
              dLog(() => '用户 注册 成功并只响应 token!');
              await Token().setSqliteToken(
                tokens: data,
                success: () {
                  GNavigatorPush.pushInitDownloadPage(globalKey.currentContext!);
                },
                fail: (int failCode) {},
              );
              break;
            case 207:
              dLog(() => '生成 token 异常!');
              break;
            case 208:
              dLog(() => '用户 登陆 成功并只响应 token!');
              await Token().setSqliteToken(
                tokens: data,
                success: () {
                  GNavigatorPush.pushInitDownloadPage(globalKey.currentContext!);
                },
                fail: (int failCode) {},
              );
              break;
            case 209:
              dLog(() => '生成 token 异常!', () => data);
              break;
            default:
              dLog(() => '未知 code!');
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
