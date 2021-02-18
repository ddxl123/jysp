import 'dart:async';

import 'package:flutter/material.dart';
import 'package:jysp/LWCR/LifeCycle/LoginPage.dart';
import 'package:jysp/LWCR/WidgetBuild/WidgetBuildBase.dart';
import 'package:jysp/Tools/RebuildHandler.dart';

class LoginPageWB extends WidgetBuildBase<LoginPage> {
  LoginPageWB(LoginPage widget) : super(widget);

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
        controller: widget.loginPageController.qqEmailTextEditingController,
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
        controller: widget.loginPageController.codeTextEditingController,
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
      rebuildHandler: widget.loginPageController.sendEmailButtonRebuildHandler,
      builder: (handler) {
        if (handler.handleCode == 1) {
          // 倒计时状态
          handler.state["banOnPressed"] = true;
          var time = (handler.state["time"] ??= 10);
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
          onPressed: () {
            widget.loginPageController.sendEmailRequest(
              sendEmailButtonRebuildHandler: widget.loginPageController.sendEmailButtonRebuildHandler,
              qqEmailTextEditingController: widget.loginPageController.qqEmailTextEditingController,
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
            widget.loginPageController.verifyEmailRequest(
              qqEmailTextEditingController: widget.loginPageController.qqEmailTextEditingController,
              codeTextEditingController: widget.loginPageController.codeTextEditingController,
            );
          },
        ),
      ),
    );
  }
}
