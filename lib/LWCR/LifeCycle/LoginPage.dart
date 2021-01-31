import 'dart:async';

import 'package:flutter/material.dart';
import 'package:jysp/LWCR/Controller/LoginPageController.dart';
import 'package:jysp/LWCR/WidgetBuild/LoginPageWB.dart';

class LoginPage extends StatefulWidget {
  LoginPage({this.loginPageController});
  final LoginPageController loginPageController;

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  void dispose() {
    (widget.loginPageController.sendEmailButtonRebuildHandler.state["timer"] as Timer)?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => LoginPageWB(widget);
}
