// ignore_for_file: non_constant_identifier_names

abstract class MBase {
  ///

  /// 值只有 int String bool null 类型，没有枚举类型，而是枚举的 int 值
  Map<String, Object?> get getRowJson;

  String get getCurrentTableName;
  int? get get_id;
  int? get get_atid;
  String? get get_uuid;
  int? get get_updated_at;
  int? get get_created_at;

  ///
}
