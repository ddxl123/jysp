/// 必须有以下成员，因为需要用 DBTableBase 实例调用 fields/getTableNameInstance
abstract class DBTableBase {
  Map<String, List<Object>> get fields;
  String getTableNameInstance = "";
}
