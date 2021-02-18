import 'package:flutter/material.dart';
import 'package:jysp/G/G.dart';
import 'package:jysp/G/GHttp.dart';
import 'package:jysp/TableModel/local/TToken.dart';
import 'package:jysp/Tools/RebuildHandler.dart';
import 'package:jysp/Tools/TDebug.dart';

mixin ByEmailRequest {
  ///

  // TODO: POST /api/register_and_login/by_email/send_email
  Future<void> sendEmailRequest({
    @required RebuildHandler sendEmailButtonRebuildHandler,
    @required TextEditingController qqEmailTextEditingController,
  }) async {
    await Future(() async {
      if (sendEmailButtonRebuildHandler.state["banOnPressed"] == true) {
        dPrint("banOnPressed");
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
          "email": qqEmailTextEditingController.text,
        },
        isAuth: false,
        resultCallback: ({code, data}) {
          switch (code) {
            case 100:
              dPrint("邮箱发送异常");
              sendEmailButtonRebuildHandler.rebuildHandle(0);
              break;
            case 101:
              dPrint("验证码存储异常");
              sendEmailButtonRebuildHandler.rebuildHandle(0);
              break;
            case 102:
              dPrint("邮箱发送流程完全成功");
              break;
            case 103:
              dPrint("邮箱格式错误");
              sendEmailButtonRebuildHandler.rebuildHandle(0);
              break;
            case 104:
              dPrint("邮箱格式检测异常");
              sendEmailButtonRebuildHandler.rebuildHandle(0);
              break;
            default:
              dPrint("未知 code");
              sendEmailButtonRebuildHandler.rebuildHandle(0);
          }
        },
        interruptedCallback: (TokenStatus tokenStatus) {
          dPrint(tokenStatus.toString());
          sendEmailButtonRebuildHandler.rebuildHandle(0);
        },
        sameNotConcurrent: "_sendEmailRequest",
      );
    });
  }

  // TODO: POST /api/register_and_login/by_email/verify_email
  void verifyEmailRequest({
    @required TextEditingController qqEmailTextEditingController,
    @required TextEditingController codeTextEditingController,
  }) async {
    await Future(() async {
      //
      //
      // 本地验证

      //
      //
      // 服务器验证
      await G.http.sendCreateTokenRequest(
        route: "/register_and_login/by_email/verify_email",
        willVerifyData: {
          "email": qqEmailTextEditingController.text,
          "code": codeTextEditingController.text,
        },
        resultCallback: ({code, data}) async {
          switch (code) {
            case 200:
              dPrint("邮箱验证码错误!");
              break;
            case 201:
              dPrint("邮箱验证异常!");
              break;
            case 202:
              dPrint("邮箱格式错误!");
              break;
            case 203:
              dPrint("邮箱格式检测异常!");
              break;
            case 204:
              dPrint("数据库查找该 email 异常!");
              break;
            case 205:
              dPrint("数据库创建新用户异常!");
              break;
            case 206:
              dPrint("用户 注册 成功并只响应 token!");
              await _saveToken(data);
              break;
            case 207:
              dPrint("生成 token 异常!");
              break;
            case 208:
              dPrint("用户 登陆 成功并只响应 token!");
              await _saveToken(data);
              break;
            case 209:
              dPrint("生成 token 异常!");
              break;
            default:
              dPrint("未知 code!");
          }
        },
        tokenCreateFailCallback: (TokenStatus tokenStatus) {
          dPrint(tokenStatus.toString());
          switch (tokenStatus) {
            case TokenStatus.creating:
              break;
            case TokenStatus.localDioError:
              break;
            case TokenStatus.localUnknownError:
              break;
            default:
          }
        },
      );
    });
  }

  Future<void> _saveToken(dynamic tokens) async {
    if (tokens[TToken.access_token] == null || tokens[TToken.refresh_token] == null) {
      dPrint("响应的 tokens 数据异常!");
    } else {
      dPrint("响应的 tokens 数据正常!");
      // 先清空表，再插入
      await G.sqlite.db.transaction((txn) async {
        await txn.delete(TToken.getTableName);
        await txn.insert(TToken.getTableName, TToken.toMap(tokens[TToken.access_token], tokens[TToken.refresh_token]));
      }).then((onValue) async {
        dPrint("token sqlite 存储成功");
        dLog("", (await G.sqlite.db.query(TToken.getTableName)));
      }).catchError((onError) async {
        dPrint("token sqlite 存储失败");
      });
    }
  }

  ///
}
