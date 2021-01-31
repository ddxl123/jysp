import 'package:jysp/Table/TableBase.dart';

class TFragments implements Table {
  @override
  String getTableNameInstance = getTableName;

  @override
  List<List> get fields => [
        [text, SqliteType.TEXT],
      ];

  static String get getTableName => "fragments";

  static String get text => "text";

  // ignore: non_constant_identifier_names
  static Map<String, dynamic> toMap(String text_v) {
    return {
      text: text_v,
    };
  }
}
