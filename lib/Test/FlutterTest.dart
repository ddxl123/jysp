import 'package:flutter/material.dart';
import 'package:jysp/G/GSqlite/GSqlite.dart';
import 'package:jysp/G/GSqlite/SqliteTools.dart';
import 'package:sqflite_common/sqlite_api.dart';

class FlutterTest extends StatefulWidget {
  @override
  _FlutterTestState createState() => _FlutterTestState();
}

class _FlutterTestState extends State<FlutterTest> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Positioned(
          top: 0,
          child: Container(
            height: 1001,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  for (int i = 0; i < 20; i++)
                    Container(
                      height: 50,
                      width: 100,
                      color: Colors.green,
                      child: Text(i.toString()),
                    ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
