import 'package:jysp/Table/TableBase.dart';

class TSeparateRules implements Table {
  @override
  String getTableNameInstance = getTableName;

  @override
  List<List> get fields => [];

  static String get getTableName => "separate_rules";

  static Map<String, dynamic> toMap() {
    return {};
  }
}
