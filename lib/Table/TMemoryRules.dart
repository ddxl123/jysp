import 'package:jysp/Table/TableBase.dart';

class TMemoryRules implements Table {
  @override
  String getTableNameInstance = getTableName;

  @override
  List<List> get fields => [];

  static String get getTableName => "memory_rules";

  static Map<String, dynamic> toMap() {
    return {};
  }
}
