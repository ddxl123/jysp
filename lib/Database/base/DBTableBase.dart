import 'package:jysp/Database/base/SqliteType.dart';

/// 必须有以下成员，因为需要用 DBTableBase 实例调用 fields/getTableNameInstance
abstract class DBTableBase {
  Map<String, List<SqliteType>> get fields;
  String getTableNameInstance = "";
}
