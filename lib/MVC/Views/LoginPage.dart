import 'dart:async';

import 'package:flutter/material.dart';
import 'package:jysp/mvc/controllers/LoginPageController.dart';
import 'package:jysp/tools/RebuildHandler.dart';
import 'package:jysp/tools/RoundedBox..dart';
import 'package:jysp/tools/TDebug.dart';
import 'package:provider/provider.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        alignment: Alignment.center,
        color: Colors.green,
        child: RoundedBox(
          width: MediaQuery.of(context).size.width * 4 / 5,
          pidding: const EdgeInsets.fromLTRB(20, 20, 20, 5),
          children: <Widget>[
            const Flexible(
              child: Text(
                '登陆/注册',
                style: TextStyle(fontSize: 18),
              ),
            ),
            _emailInputField(),
            const Flexible(child: SizedBox(height: 10)),
            Flexible(
              child: Row(
                children: <Widget>[
                  _codeInputField(),
                  _sendEmailButton(),
                ],
              ),
            ),
            const Flexible(child: SizedBox(height: 10)),
            _verifyEmailButton(),
          ],
        ),
      ),
    );
  }

  Widget _emailInputField() {
    return Flexible(
      child: TextField(
        controller: context.read<LoginPageController>().emailTextEditingController,
        decoration: const InputDecoration(
          contentPadding: EdgeInsets.zero,
          icon: Icon(Icons.person),
          labelText: '邮箱',
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
        decoration: const InputDecoration(
          contentPadding: EdgeInsets.zero,
          icon: Icon(Icons.lock),
          labelText: '验证码',
        ),
        minLines: 1,
        maxLines: 1,
      ),
    );
  }

  Widget _sendEmailButton() {
    return RebuildHandleWidget<SendEmailButtonHandlerEnum>(
      rebuildHandler: context.read<LoginPageController>().sendEmailButtonRebuildHandler,
      builder: (RebuildHandler<SendEmailButtonHandlerEnum> handler) {
        if (handler.handleCode == SendEmailButtonHandlerEnum.countdown) {
          // 倒计时状态
          handler.state['banOnPressed'] = true;
          handler.state['time'] ??= 10;
          handler.state['text'] = "${handler.state["time"]} s";
          handler.state['timer'] ??= Timer.periodic(
            const Duration(seconds: 1),
            (Timer timer) {
              if (handler.state['time'] == 0) {
                (handler.state['timer'] as Timer).cancel();
                handler.rebuildHandle(SendEmailButtonHandlerEnum.unSent, true);
              } else {
                handler.state['time'] -= 1;
                handler.rebuildHandle(SendEmailButtonHandlerEnum.countdown);
              }
            },
          );
        } else if (handler.handleCode == SendEmailButtonHandlerEnum.unSent) {
          // 未发送状态
          handler.state['timer']?.cancel();
          handler.state.clear();
          handler.state['banOnPressed'] = false;
          handler.state['text'] = '发送验证码';
        }

        return TextButton(
          style: ButtonStyle(
            side: MaterialStateProperty.all(const BorderSide(color: Colors.green)),
          ),
          child: Text(handler.state['text'] as String),
          onPressed: () {
            if (handler.state['banOnPressed'] == true) {
              dLog(() => 'banOnPressed');
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
            side: MaterialStateProperty.all(const BorderSide(color: Colors.green)),
          ),
          child: const Text('登陆/注册'),
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
