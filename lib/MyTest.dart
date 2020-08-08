import 'package:flutter/material.dart';
import 'package:jysp/main.dart';

class MyTest extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Center(
          child: OOO(),
        ),
      ),
    );
  }
}

class OOO extends StatefulWidget {
  OOO({Key key}) : super(key: key);

  @override
  _OOOState createState() => _OOOState();
}

class _OOOState extends State<OOO> {
  @override
  Widget build(BuildContext context) {
    return FlatButton(
      onPressed: () {
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => MyApp(),
        ));
      },
      child: Text("data"),
    );
  }
}

class HHH extends StatefulWidget {
  HHH({Key key}) : super(key: key);

  @override
  _HHHState createState() => _HHHState();
}

class _HHHState extends State<HHH> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: <Widget>[
          FlatButton(
            onPressed: () {
              setState(() {});
            },
            child: Text("AAAAAA"),
          ),
          BBB(),
        ],
      ),
    );
  }
}

class BBB extends StatefulWidget {
  BBB({Key key}) : super(key: key);

  @override
  _BBBState createState() => _BBBState();
}

class _BBBState extends State<BBB> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print("init");
  }

  @override
  void didUpdateWidget(BBB oldWidget) {
    // TODO: implement didUpdateWidget
    super.didUpdateWidget(oldWidget);
    print("duw");
  }

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    print("dcd");
  }

  @override
  Widget build(BuildContext context) {
    print("build");
    return Container(
      child: FlatButton(
        onPressed: () {
          setState(() {});
        },
        child: Text("BBBBB"),
      ),
    );
  }
}
