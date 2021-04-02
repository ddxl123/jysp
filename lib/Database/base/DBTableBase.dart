import 'package:jysp/Database/base/SqliteType.dart';

abstract class DBTableBase {
  Map<String, List<SqliteType>> get fields;
  String getTableNameInstance = "";
}
