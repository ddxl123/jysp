import 'package:flutter/material.dart';
import 'package:jysp/Pages/FragmentPool.dart';

class MyTest extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Center(
          child: Container(
            alignment: Alignment.center,
            color: Colors.green,
            width: 100,
            height: 100,
            child: FlatButton(
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(builder: (_) => FragmentPool()));
              },
              child: Text("enter"),
            ),
          ),
        ),
      ),
    );
  }
}

class Test extends StatefulWidget {
  Test({Key key}) : super(key: key);

  @override
  _TestState createState() => _TestState();
}

class _TestState extends State<Test> {
  @override
  Widget build(BuildContext context) {
    return FlatButton(
      onPressed: () {
        Navigator.push(context, PopRoute(context));
        print("object");
      },
      child: Text("data"),
    );
  }
}

class PopRoute extends OverlayRoute {
  PopRoute(this.context);
  final BuildContext context;
  @override
  Iterable<OverlayEntry> createOverlayEntries() {
    return [
      OverlayEntry(
        maintainState: true,
        builder: (_) => Container(
          alignment: Alignment.centerLeft,
          child: AAA(_),
        ),
      ),
    ];
  }
}

class AAA extends StatefulWidget {
  AAA(this.context);
  final BuildContext context;
  @override
  _AAAState createState() => _AAAState();
}

class _AAAState extends State<AAA> {
  /// 当 [_modalRoute] 关联的 [relyContext] 发生变化时会调用 [didChangeDependencies] , [initState] 时也会被调用
  /// 因为 [addScopedWillPopCallback] 会把 [willPopCallback对象] 添加到 [List] 中,因此需要赋予同一个 [willPopCallback对象]
  @override
  // void didChangeDependencies() {
  //   super.didChangeDependencies();
  //   _modalRoute?.removeScopedWillPopCallback(willPopCallback);
  //   _modalRoute = ModalRoute.of(this.context);
  //   _modalRoute?.addScopedWillPopCallback(willPopCallback);
  // }

  /// 当第一次点击返回时,调用 [_remove()] ,而调用 [_remove()] 则会调用 [this.dispose()]
  /// 即第一次点击返回时, [sheet] 会被下降并移除,移除后第二次点击返回时,会返回到上一个 [route]
  Future<bool> willPopCallback() {
    print("willPopCallback");
    return Future.value(false);
  }

  @override
  void initState() {
    super.initState();
    ModalRoute.of(widget.context).addScopedWillPopCallback(willPopCallback);
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Container(
        width: 200,
        height: 200,
        color: Colors.red,
        alignment: Alignment.centerLeft,
        child: Text(DateTime.now().toString()),
      ),
    );
  }
}
