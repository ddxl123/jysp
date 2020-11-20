import 'package:flutter/material.dart';

class MyTest extends StatefulWidget {
  @override
  _MyTestState createState() => _MyTestState();
}

class _MyTestState extends State<MyTest> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: GestureDetector(
          onScaleStart: (details) {
            lastLocalFocalPoint = details.localFocalPoint;
          },
          onScaleUpdate: (details) {
            Offset deltaLFP = details.localFocalPoint - lastLocalFocalPoint;
            offset += deltaLFP;
            lastLocalFocalPoint = details.localFocalPoint;
            setState(() {});
          },
          child: _body(),
        ),
      ),
    );
  }

  var offset = Offset.zero;
  var lastLocalFocalPoint = Offset.zero;

  Widget _body() {
    return Container(
      alignment: Alignment.center,
      color: Colors.green,
      width: 300,
      height: 300,
      child: Stack(
        children: [
          Positioned(
            top: 0,
            child: Transform.translate(
              offset: offset,
              child: Container(
                color: Colors.red,
                width: 500,
                height: 200,
                child: FlatButton(
                  child: Text("button"),
                  onPressed: () {},
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
