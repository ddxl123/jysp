import 'package:flutter/material.dart';
import 'package:jysp/G/GSqlite/GSqlite.dart';
import 'package:jysp/G/GSqlite/SqliteTools.dart';

class FlutterTest extends StatefulWidget {
  @override
  _FlutterTestState createState() => _FlutterTestState();
}

class _FlutterTestState extends State<FlutterTest> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: TextButton(
        child: Text("data"),
        onPressed: () async {
          await GSqlite.openDb();
          await SqliteTools().clearSqlite();
          await GSqlite.db.execute("CREATE TABLE a(name,TEXT)");
          await GSqlite.db.insert("a", {"name": "hhh"});
          await GSqlite.db.execute("DROP TABLE IF EXISTS a");

          print(await SqliteTools().getAllTableNames());
        },
      ),
    );
  }
}
