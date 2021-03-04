// ignore_for_file: non_constant_identifier_names

import 'package:jysp/Database/DBTableBase.dart';

class TTest implements DBTableBase {
  @override
  String getTableNameInstance = getTableName;

  static String get getTableName => "tests";

  static String get data => "data";

  @override
  List<List<dynamic>> get fields => [
        [data, SqliteType.INTEGER],
      ];

  static Map<String, dynamic> toMap(
    String data_v,
  ) {
    return {
      data: data_v,
    };
  }
}
