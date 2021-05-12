import 'package:flutter/material.dart';
import 'package:jysp/AppInit/AppInit.dart';
import 'package:jysp/AppInit/AppInitEnum.dart';
import 'package:jysp/G/GNavigatorPush.dart';
import 'package:jysp/G/GSqlite/SqliteTools.dart';
import 'package:jysp/MVC/Controllers/LoginPageController.dart';

class WillToHomePage extends StatefulWidget {
  @override
  _WillToHomePageState createState() => _WillToHomePageState();
}

class _WillToHomePageState extends State<WillToHomePage> {
  LoginPageController loginPageController = LoginPageController();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Object>(
      initialData: 1,
      future: _future(),
      builder: _builder,
    );
  }

  Future<Object> _future() async {
    print(await AppInit().appInit());
    return 2;
  }

  Widget _builder(BuildContext context, AsyncSnapshot<Object> snapshot) {
    /// 因为 FutureBuilder 里的 future 调用了 then，异常被直接捕获了
    if (snapshot.hasError) {
      throw snapshot.error.toString();
    }
    if (snapshot.data == null) {
      throw 'snapshot.data is null';
    }
    switch (snapshot.connectionState) {
      case ConnectionState.none:
        return const Center(child: Text('future为null'));
      case ConnectionState.active:
        return const Center(child: Text('active'));
      case ConnectionState.waiting:
        return const Center(child: Text('正在初始化...'));
      case ConnectionState.done:
        return _appInitResultWidget(snapshot.data!);
      default:
        return const Center(child: Text('未知快照'));
    }
  }

  Widget _appInitResultWidget(Object appInitResult) {
    if (appInitResult is AppInitStatus) {
      final AppInitStatus appInitStatus = appInitResult;
      switch (appInitStatus) {
        case AppInitStatus.ok:
          return _appInitResultOk();
        case AppInitStatus.tableLost:
          return _appInitResultTableLost();
        case AppInitStatus.initialized:
          return _appInitResultInitialized();
        default:
          return _appInitResultUnknown();
      }
    } else if (appInitResult is VersionStatus) {
      switch (appInitResult) {
        case VersionStatus.back:
          return _appInitResultBack();
        case VersionStatus.notChangeDB:
          return _appInitResultOk();
        case VersionStatus.changeDbNotUpload:
          return _appInitResultChangeDbNotUpload();
        case VersionStatus.changeDbAfterUpload:
          return _appInitResultChangeDbAfterUpload();
        default:
          return _appInitResultUnknown();
      }
    } else {
      return _appInitResultUnknown();
    }
  }

  Widget _appInitResultTableLost() {
    return Center(
      child: TextButton(
        child: const Text('数据丢失, 点击清空数据并初始化应用!'),
        onPressed: () {
          SqliteTools().clearSqlite();
          setState(() {});
        },
      ),
    );
  }

  Widget _appInitResultBack() {
    return Center(
      child: TextButton(
        child: const Text('应用版本过高!'),
        onPressed: () {},
      ),
    );
  }

  Widget _appInitResultChangeDbNotUpload() {
    return Center(
      child: TextButton(
        child: const Text('需要先进行 sqlite 覆盖处理'),
        onPressed: () {},
      ),
    );
  }

  Widget _appInitResultChangeDbAfterUpload() {
    return Center(
      child: TextButton(
        child: const Text('需要先进行上传处理, 再进行 sqlite 覆盖处理'),
        onPressed: () {},
      ),
    );
  }

  Widget _appInitResultOk() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          TextButton(
            onPressed: () {
              GNavigatorPush.pushLoginPage(context);
            },
            child: const Text('To login page'),
          ),
          TextButton(
            onPressed: () {
              SqliteTools().clearSqlite();
            },
            child: const Text('deleteDatabase'),
          ),
        ],
      ),
    );
  }

  Widget _appInitResultInitialized() {
    return const Center(
      child: Text('AppInitResultInitialized'),
    );
  }

  Widget _appInitResultUnknown() {
    return const Center(
      child: Text('AppInitResultUnknown'),
    );
  }
}
