import 'package:flutter/material.dart';

class MyTest extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Center(
          child: AAA(),
        ),
      ),
    );
  }
}

class AAA extends StatefulWidget {
  AAA({Key key}) : super(key: key);

  @override
  _AAAState createState() => _AAAState();
}

class _AAAState extends State<AAA> {
  OverlayEntry overlayEntry;
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      child: FloatingActionButton(
        onPressed: () {
          OverlayState overlayState = Overlay.of(context);
          overlayEntry = OverlayEntry(
            builder: (BuildContext context) {
              return Positioned(
                width: 100,
                height: 100,
                child: Container(
                  color: Colors.red,
                ),
              );
            },
          );
          overlayState.insert(overlayEntry);
        },
        child: Text("add"),
      ),
      onWillPop: () {
        print('onWillPop');
        overlayEntry.remove();
        return Future.value(false);
      },
    );
  }
}
