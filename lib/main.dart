import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:jysp/Global/Globaler.dart';
import 'package:jysp/MyTest.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _MyApp();
  }
}

class _MyApp extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: Globaler.instance.navigatorState,
      home: Scaffold(
        body: MainWidget(),
      ),
    );
  }
}

class MainWidget extends StatefulWidget {
  MainWidget({Key key}) : super(key: key);

  @override
  _MainWidgetState createState() => _MainWidgetState();
}

class _MainWidgetState extends State<MainWidget> {
  @override
  void initState() {
    super.initState();
    Globaler.instance.overlayState = Overlay.of(context);
  }

  @override
  Widget build(BuildContext context) {
    return MyTest();
  }
}
