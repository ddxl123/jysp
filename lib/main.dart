import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:jysp/FragmentPool.dart';
import 'package:jysp/MyTest.dart';

void main() {
  runApp(MyTest());
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
      home: Scaffold(
        body: Stack(
          alignment: Alignment.topCenter,
          children: <Widget>[
            FragmentPool(),
            Positioned(
              top: MediaQueryData.fromWindow(window).padding.top,
              left: 0,
              child: ButtonTheme(
                minWidth: 0,
                child: FlatButton(
                  color: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(100),
                    ),
                  ),
                  onPressed: () {
                  },
                  child: Text("我的"),
                ),
              ),
            ),
            Positioned(
              top: MediaQueryData.fromWindow(window).padding.top,
              child: Row(
                children: <Widget>[
                  FlatButton(
                    color: Colors.white,
                    onPressed: () {},
                    child: Text("root"),
                  ),
                  ButtonTheme(
                    minWidth: 0,
                    child: FlatButton(
                      color: Colors.white,
                      onPressed: () {},
                      child: Text("🔍"),
                    ),
                  ),
                ],
              ),
            ),
            Positioned(
              top: MediaQueryData.fromWindow(window).padding.top,
              right: 0,
              child: ButtonTheme(
                minWidth: 0,
                child: FlatButton(
                  color: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(100),
                    ),
                  ),
                  onPressed: () {},
                  child: Text("..."),
                ),
              ),
            ),
            Positioned(
              bottom: 0,
              width: MediaQueryData.fromWindow(window).size.width,
              child: Column(
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Expanded(
                        child: ButtonTheme(
                          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
                          child: FlatButton(
                            color: Colors.white,
                            onPressed: () {},
                            child: Icon(Icons.ac_unit),
                          ),
                        ),
                      ),
                      Expanded(
                        child: ButtonTheme(
                          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
                          child: FlatButton(
                            color: Colors.white,
                            onPressed: () {},
                            child: Icon(Icons.ac_unit),
                          ),
                        ),
                      ),
                      Expanded(
                        child: ButtonTheme(
                          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
                          child: FlatButton(
                            color: Colors.white,
                            onPressed: () {},
                            child: Icon(Icons.ac_unit),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
