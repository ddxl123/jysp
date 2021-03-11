import 'package:flutter/material.dart';
import 'package:jysp/G/G.dart';
import 'package:jysp/LWCR/Controller/LoginPageController.dart';
import 'package:jysp/LWCR/LifeCycle/LoginPageLC.dart';

class WillToHome extends StatefulWidget {
  @override
  _WillToHomeState createState() => _WillToHomeState();
}

class _WillToHomeState extends State<WillToHome> {
  LoginPageController loginPageController = LoginPageController();

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
          TextButton(
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (_) => LoginPageLC(loginPageController: loginPageController)));
            },
            child: Text("To home"),
          ),
          TextButton(
            onPressed: () {
              G.sqlite.clearSqlite();
            },
            child: Text("deleteDatabase"),
          ),
        ],
      ),
    );
  }
}
