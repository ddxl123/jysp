import 'package:flutter/material.dart';
import 'package:jysp/G/G.dart';
import 'package:jysp/Test/FlutterTest.dart';
import 'package:jysp/WillToHomePage.dart';

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
      home: Material(
        key: G.globalKey,
        child: WillToHomePage(),
      ),
    );
  }
}
