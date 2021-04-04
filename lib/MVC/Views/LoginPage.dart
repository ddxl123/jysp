import 'dart:async';

import 'package:flutter/material.dart';
import 'package:jysp/MVC/Controllers/LoginPageController.dart';
import 'package:jysp/Tools/RebuildHandler.dart';
import 'package:jysp/Tools/TDebug.dart';
import 'package:provider/provider.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
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
                  "登陆/注册",
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
        controller: context.read<LoginPageController>().emailTextEditingController,
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
        controller: context.read<LoginPageController>().codeTextEditingController,
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
    return RebuildHandleWidget<SendEmailButtonHandlerEnum>(
      rebuildHandler: context.read<LoginPageController>().sendEmailButtonRebuildHandler,
      builder: (handler) {
        if (handler.handleCode == SendEmailButtonHandlerEnum.countdown) {
          // 倒计时状态
          handler.state["banOnPressed"] = true;
          handler.state["time"] ??= 10;
          handler.state["text"] = "${handler.state["time"]} s";
          handler.state["timer"] ??= Timer.periodic(
            Duration(seconds: 1),
            (timer) {
              if (handler.state["time"] == 0) {
                (handler.state["timer"] as Timer).cancel();
                handler.rebuildHandle(SendEmailButtonHandlerEnum.unSent, true);
              } else {
                handler.state["time"] -= 1;
                handler.rebuildHandle(SendEmailButtonHandlerEnum.countdown);
              }
            },
          );
        } else if (handler.handleCode == SendEmailButtonHandlerEnum.unSent) {
          // 未发送状态
          handler.state["timer"]?.cancel();
          handler.state.clear();
          handler.state["banOnPressed"] = false;
          handler.state["text"] = "发送验证码";
        }

        return TextButton(
          style: ButtonStyle(
            side: MaterialStateProperty.all(BorderSide(color: Colors.green)),
          ),
          child: Text(handler.state["text"]),
          onPressed: () {
            if (handler.state["banOnPressed"] == true) {
              dLog(() => "banOnPressed");
              return;
            }
            handler.rebuildHandle(SendEmailButtonHandlerEnum.countdown);
            context.read<LoginPageController>().sendEmailRequest(
                  handler: handler,
                  emailTextEditingController: context.read<LoginPageController>().emailTextEditingController,
                );
          },
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
          onPressed: () {
            context.read<LoginPageController>().verifyEmailRequest(
                  qqEmailTextEditingController: context.read<LoginPageController>().emailTextEditingController,
                  codeTextEditingController: context.read<LoginPageController>().codeTextEditingController,
                );
          },
        ),
      ),
    );
  }
}
