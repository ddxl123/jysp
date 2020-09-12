import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:jysp/Global/Globaler.dart';
import 'package:jysp/Pages/HomePage.dart';

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
      home: Material(
        child: Center(
          child: FlatButton(
            onPressed: () {
              Navigator.push(Globaler.instance.navigatorState.currentContext, MaterialPageRoute(builder: (_) => HomePage()));
            },
            child: Text("To home"),
          ),
        ),
      ),
    );
  }
}
