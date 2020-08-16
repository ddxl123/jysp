import 'package:flutter/material.dart';

class MyTest extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              AAA(),
              AAA(),
              BBB(),
            ],
          ),
        ),
      ),
    );
  }
}

class AAA extends StatefulWidget {
  @override
  _AAAState createState() => _AAAState();
}

class _AAAState extends State<AAA> with CCC {
  @override
  Widget build(BuildContext context) {
    return FlatButton(
      onPressed: () {
        i++;
        print(i.toString());
      },
      child: Text("i++"),
    );
  }
}

class BBB extends StatefulWidget {
  @override
  _BBBState createState() => _BBBState();
}

class _BBBState extends State<BBB> with CCC {
  @override
  Widget build(BuildContext context) {
    return FlatButton(
      onPressed: () {
        print(i.toString());
      },
      child: Text("print"),
    );
  }
}

mixin CCC {
  int i = 0;
}
