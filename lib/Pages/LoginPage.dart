import 'dart:async';

import 'package:flutter/material.dart';
import 'package:jysp/G/G.dart';
import 'package:jysp/Tools/RebuildHandler.dart';
import 'package:jysp/Tools/Toast.dart';

class LoginPage extends StatefulWidget {
  LoginPage({Key key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController _qqEmailTextEditingController = TextEditingController();
  TextEditingController _codeTextEditingController = TextEditingController();

  /// 触发 [rebuild], 同时返回代码, 根据代码进行处理。
  RebuildHandler _sendEmailButtonRebuildHandler = RebuildHandler();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.green,
      body: Center(
        child: Container(
          width: 300,
          padding: EdgeInsets.fromLTRB(20, 20, 20, 5),
          decoration: BoxDecoration(
            color: Colors.yellow,
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(offset: Offset(10, 10), blurRadius: 10, spreadRadius: -10),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Flexible(
                child: Text(
                  "登陆",
                  style: TextStyle(fontSize: 18),
                ),
              ),
              _emailInputField(),
              Flexible(child: SizedBox(height: 10)),
              Flexible(
                child: Row(
                  children: [
                    _codeInputField(),
                    _sendEmailButton(),
                  ],
                ),
              ),
              Flexible(child: SizedBox(height: 10)),
              _verifyEmailButton(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _emailInputField() {
    return Flexible(
      child: TextField(
        controller: _qqEmailTextEditingController,
        decoration: InputDecoration(
          contentPadding: EdgeInsets.zero,
          icon: Icon(Icons.person),
          labelText: "邮箱",
        ),
        minLines: 1,
        maxLines: 1,
      ),
    );
  }

  Widget _codeInputField() {
    return Expanded(
      child: TextField(
        controller: _codeTextEditingController,
        decoration: InputDecoration(
          contentPadding: EdgeInsets.zero,
          icon: Icon(Icons.lock),
          labelText: "密码",
        ),
        minLines: 1,
        maxLines: 1,
      ),
    );
  }

  Widget _sendEmailButton() {
    return RebuildHandleWidget(
      rebuildHandler: _sendEmailButtonRebuildHandler,
      builder: (handler) {
        if (handler.handleCode == 1) {
          // 倒计时状态
          handler.state["banOnPressed"] = true;
          var time = (handler.state["time"] ??= 5);
          handler.state["text"] = "$time s";
          handler.state["timer"] ??= Timer.periodic(
            Duration(seconds: 1),
            (timer) {
              if (handler.state["time"] == 0) {
                (handler.state["timer"] as Timer).cancel();
                handler.reset(true);
              } else {
                handler.state["time"] -= 1;
                handler.rebuild();
              }
            },
          );
        } else {
          // 未发送状态
          handler.state["banOnPressed"] = false;
          (handler.state["timer"] as Timer)?.cancel();
          handler.reset(false);
          handler.state["text"] = "发送验证码";
        }
        return TextButton(
          style: ButtonStyle(
            side: MaterialStateProperty.all(BorderSide(color: Colors.green)),
          ),
          child: Text(handler.state["text"]),
          onPressed: _sendEmailRequest,
        );
      },
    );
  }

  Widget _verifyEmailButton() {
    return Flexible(
      child: Container(
        width: double.maxFinite,
        child: TextButton(
          style: ButtonStyle(
            side: MaterialStateProperty.all(BorderSide(color: Colors.green)),
          ),
          child: Text("登陆/注册"),
          onPressed: _verifyEmailRequest,
        ),
      ),
    );
  }

  // TODO: /api/register_and_login/by_email/send_email
  void _sendEmailRequest() async {
    if (_sendEmailButtonRebuildHandler.state["banOnPressed"] == true) {
      print("banOnPressed");
      return;
    }

    //
    //
    // 本地验证：

    //
    //
    // 服务器验证：
    _sendEmailButtonRebuildHandler.rebuildHandle(1);

    await G.http.sendPostRequest(
      route: "/register_and_login/by_email/send_email",
      data: {
        "qq_email": this._qqEmailTextEditingController.text,
      },
      result: ({response, unknownCode}) {
        switch (response.data["code"]) {
          case 100:
            showToast("验证码已发送，请注意查收!");
            break;
          case 101:
            showToast("验证码发送异常!");
            _sendEmailButtonRebuildHandler.rebuildHandle(0);
            break;
          case 103:
            showToast("邮箱格式错误!");
            _sendEmailButtonRebuildHandler.rebuildHandle(0);
            break;
          case 104:
            showToast("数据库存在多个该邮箱!");
            _sendEmailButtonRebuildHandler.rebuildHandle(0);
            break;
          default:
            unknownCode();
            _sendEmailButtonRebuildHandler.rebuildHandle(0);
        }
      },
      onError: () {
        _sendEmailButtonRebuildHandler.rebuildHandle(0);
      },
      notConcurrent: "_sendEmailRequest",
    );
  }

  // TODO: /api/register_and_login/by_email/verify_email
  void _verifyEmailRequest() async {
    //
    //
    // 本地验证

    //
    //
    // 服务器验证
    await G.http.sendPostRequest(
      route: "/register_and_login/by_email/verify_email",
      data: {
        "qq_email": _qqEmailTextEditingController.text,
        "code": _codeTextEditingController.text,
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
      onError: null,
      notConcurrent: "_verifyEmailRequest",
    );
  }

  @override
  void dispose() {
    (_sendEmailButtonRebuildHandler.state["timer"] as Timer)?.cancel();
    super.dispose();
  }
}
