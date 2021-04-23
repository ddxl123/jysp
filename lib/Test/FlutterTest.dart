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
        child: const Text('data'),
        onPressed: () async {
          await openDb();
          await SqliteTools().clearSqlite();
          await db.execute('CREATE TABLE a(name,TEXT)');
          await db.insert('a', <String, String>{'name': 'hhh'});
          await db.execute('DROP TABLE IF EXISTS a');

          print(await SqliteTools().getAllTableNames());
        },
      ),
    );
  }
}
