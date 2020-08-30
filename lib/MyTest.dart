import 'package:flutter/material.dart';

class MyTest extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Center(
          child: Stack(
            alignment: Alignment.bottomCenter,
            children: [
              Positioned(
                bottom: 0,
                width: 100,
                height: 100,
                child: Container(
                  color: Colors.yellow,
                  alignment: Alignment.center,
                  child: DraggableScrollableSheet(
                    expand: false,
                    initialChildSize: 0.5,
                    minChildSize: 0,
                    maxChildSize: 1,
                    builder: (_, sc) {
                      return SingleChildScrollView(
                        controller: sc,
                        child: Container(
                          width: 50,
                          height: 50,
                          color: Colors.red,
                          child: Text("data"),
                        ),
                      );
                    },
                  ),
                ),
              ),
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
