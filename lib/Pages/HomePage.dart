import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:jysp/FragmentPool/Main/FragmentPool.dart';

class HomePage extends StatefulWidget {
  HomePage({Key key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.topCenter,
      children: <Widget>[
        FragmentPool(),
        Positioned(
          bottom: 50,
          right: 0,
          child: FlatButton(
            onPressed: () {},
            child: Icon(Icons.adjust),
          ),
        ),
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
              onPressed: () {},
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
    );
  }
}
