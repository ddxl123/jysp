// ignore_for_file: non_constant_identifier_names

abstract class MBase {
  ///

  /// 值只有 int String bool null 类型，没有枚举类型，而是枚举的 int 值
  Map<String, Object?> get getRowJson;

  /// 外键对应的表。key: 外键名；value: 对应的表名
  Map<String, String?> get getForeignKeyTables;

  /// 当删除当前 row 时，需要同时删除对应 row 的外键名
  List<String> get getDeleteChildFollowFathers;

  /// 当删除外键时，需要同时删除当前 row 的外键名
  List<String> get getDeleteFatherFollowChilds;

  String get getCurrentTableName;
  int? get get_id;
  int? get get_atid;
  String? get get_uuid;
  int? get get_updated_at;
  int? get get_created_at;

  ///
}
