import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:jysp/G/G.dart';
import 'package:jysp/Pages/HomePage.dart';
import 'package:jysp/Tools/TDebug.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _MyApp();
  }
}

GlobalKey<NavigatorState> n = GlobalKey<NavigatorState>();

class _MyApp extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Material(
        key: G.globalKey,
        child: Main(),
      ),
    );
  }
}

class Main extends StatefulWidget {
  @override
  _MainState createState() => _MainState();
}

class _MainState extends State<Main> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _future(),
      builder: _builder,
    );
  }

  Future<void> _future() async {
      G.http.init();
      await G.sqlite.init();
  }

  Widget _builder(BuildContext context, AsyncSnapshot<dynamic> snapshot) {
    /// 因为 FutureBuilder 里的 future 调用了 then，异常被直接捕获了
    if (snapshot.hasError) {
      throw snapshot.error.toString();
    }
    switch (snapshot.connectionState) {
      case ConnectionState.none:
        return Center(child: Text("future为null"));
      case ConnectionState.active:
        return Center(child: Text("active"));
      case ConnectionState.waiting:
        return Center(child: Text("正在初始化..."));
      case ConnectionState.done:
        return _indexWidget();
      default:
        return Center(child: Text("未知快照"));
    }
  }

  Widget _indexWidget() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          FlatButton(
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (_) => HomePage()));
            },
            child: Text("To home"),
          ),
          FlatButton(
            onPressed: () {
              G.sqlite.removeTables();
            },
            child: Text("deleteDatabase"),
          ),
        ],
      ),
    );
  }
}
