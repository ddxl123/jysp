import 'package:flutter/material.dart';
import 'package:jysp/Pages/FragmentPool.dart';

class MyTest extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Center(
          child: FlatButton(
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (_) => FragmentPool()));
              print("object");
            },
            child: Container(
              color: Colors.green,
              width: 100,
              height: 100,
              child: Text("enter"),
            ),
          ),
        ),
      ),
    );
  }
}

class PopRoute extends OverlayRoute {
  @override
  Iterable<OverlayEntry> createOverlayEntries() {
    return [
      OverlayEntry(
        builder: (_) => Container(
          alignment: Alignment.centerLeft,
          child: Material(
            child: Container(
              width: 200,
              height: 200,
              color: Colors.red,
              alignment: Alignment.centerLeft,
              child: Text(DateTime.now().toString()),
            ),
          ),
        ),
      )
    ];
  }
}
