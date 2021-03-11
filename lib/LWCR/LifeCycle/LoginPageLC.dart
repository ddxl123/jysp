import 'dart:async';

import 'package:flutter/material.dart';
import 'package:jysp/LWCR/Controller/LoginPageController.dart';
import 'package:jysp/LWCR/WidgetBuild/LoginPageWB.dart';

class LoginPageLC extends StatefulWidget {
  LoginPageLC({required this.loginPageController});
  final LoginPageController loginPageController;

  @override
  _LoginPageLCState createState() => _LoginPageLCState();
}

class _LoginPageLCState extends State<LoginPageLC> {
  @override
  void dispose() {
    dynamic timer = widget.loginPageController.sendEmailButtonRebuildHandler.state["timer"];
    if (timer is Timer) {
      timer.cancel();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => LoginPageWB(widget);
}
