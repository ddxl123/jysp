import 'dart:async';

import 'package:flutter/material.dart';
import 'package:jysp/LWCR/Controller/LoginPageController.dart';
import 'package:jysp/LWCR/WidgetBuild/LoginPageWB.dart';

class LoginPageLC extends StatefulWidget {
  LoginPageLC({this.loginPageController});
  final LoginPageController loginPageController;

  @override
  _LoginPageLCState createState() => _LoginPageLCState();
}

class _LoginPageLCState extends State<LoginPageLC> {
  @override
  void dispose() {
    (widget.loginPageController.sendEmailButtonRebuildHandler.state["timer"] as Timer)?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => LoginPageWB(widget);
}
