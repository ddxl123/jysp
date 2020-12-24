import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:jysp/G/G.dart';
import 'package:jysp/Pages/HomePage.dart';

void main() {
  G.http.defaultHttpOptions();
  runApp(MyApp());
  // /data/user/0/com.example.jysp/databases
  //  1 /data/user/0/com.example.jysp/databases/my_db.db
}

class MyApp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _MyApp();
  }
}

GlobalKey<NavigatorState> n = GlobalKey<NavigatorState>();

class _MyApp extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    // () async {
    //   var databasesPath = await getDatabasesPath();
    //   String path = databasesPath + '/demo.db';
    //   await deleteDatabase(path);
    //   var od1 = await openDatabase(path, version: 1);
    //   var rq = await od1.rawQuery("SELECT * FROM sqlite_master WHERE type='table' AND name = 'aaa'");
    //   log(rq.toString());
    //   // var oi = await od.rawInsert("""
    //   // CREATE TABLE bbb (
    //   // id INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT UNIQUE,
    //   // orderId Text NOT NULL,
    //   // type TEXT NOT NULL);
    //   // """);
    //   // print(oi);
    //   // var rq = await od.rawQuery('SELECT name FROM sqlite_master WHERE type = "table"');
    // }();
    return MaterialApp(
      home: Material(
        key: G.globalKey,
        child: Main(),
      ),
    );
  }
}

class Main extends StatefulWidget {
  @override
  _MainState createState() => _MainState();
}

class _MainState extends State<Main> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: FlatButton(
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (_) => HomePage()));
        },
        child: Text("To home"),
      ),
    );
  }
}
