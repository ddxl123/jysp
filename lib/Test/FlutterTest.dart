import 'package:flutter/material.dart';
import 'package:jysp/G/GSqlite/GSqlite.dart';
import 'package:jysp/G/GSqlite/SqliteTools.dart';
import 'package:sqflite_common/sqlite_api.dart';

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
          await db.execute('CREATE TABLE a (id INTEGER PRIMARY KEY AUTOINCREMENT,name TEXT, age INTEGER)');
          print(await db.rawQuery('PRAGMA table_info(\'a\')'));
          await db.insert('a', <String, String>{'name': 'hhh'});
          print(await db.query('a'));

          try {
            await db.transaction<void>(
              (Transaction txn) async {
                await txn.update('a', <String, String>{'name': 'zzzz'});
                print(await txn.query('a'));
                await txn.insert('a', <String, String>{'name': 'ccccccccccc'});
                await txn.update('a', <String, Object?>{'age': 111, 'name': null});
              },
            );
          } catch (e) {
            print(e);
          }

          // await db.execute('DROP TABLE IF EXISTS a');

          print(await db.query('a', where: 'id = ?', whereArgs: <Object?>[null]));
        },
      ),
    );
  }
}
