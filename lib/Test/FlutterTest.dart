import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class FlutterTest extends StatefulWidget {
  @override
  _FlutterTestState createState() => _FlutterTestState();
}

class _FlutterTestState extends State<FlutterTest> {
  @override
  Widget build(BuildContext context) {
    // return ChangeNotifierProvider(
    //   create: (_) => Controller(),
    //   child: Demo(),
    // );
    return GestureDetector(
      child: Container(
        alignment: Alignment.center,
        color: Colors.blue,
        child: GestureDetector(
          behavior: HitTestBehavior.deferToChild,
          child: Container(
            alignment: Alignment.center,
            width: 300,
            height: 300,
            color: Colors.transparent,
            child: Text("data"),
          ),
          onPanUpdate: (_) {
            print("in");
          },
        ),
      ),
      onPanUpdate: (_) {
        print("out");
      },
    );
  }
}

class Controller extends ChangeNotifier {
  int count = 0;
  void countIncrement() {
    count++;
    notifyListeners();
  }
}

class Demo extends StatefulWidget {
  @override
  _DemoState createState() => _DemoState();
}

class _DemoState extends State<Demo> {
  @override
  Widget build(BuildContext context) {
    print("build");
    return GestureDetector(
      child: Container(
        color: Colors.yellow,
        alignment: Alignment.center,
        width: 300,
        height: 300,
        child: Text(context.watch<Controller>().count.toString()),
      ),
      onScaleUpdate: (details) {
        print("details");
        context.read<Controller>().countIncrement();
      },
    );
  }
}
