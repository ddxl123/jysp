// ignore_for_file: non_constant_identifier_names

import 'package:jysp/Database/run/Create.dart';
import 'package:jysp/Database/run/main.dart';

abstract class FieldNameBase {
  void createModel() {
    CreateModel(
      tableNameWithS: tableNameWithS,
      createFields: (Map<String, List<Object>> Function({
        required String fieldName,
        required String? dartFieldType,
        required String? foreignKeyTableName,
        required String? foreignKeyRowName,
        required bool? isDeleteChildFollowFatherIfIsId,
        required SetFieldType setFieldType,
        required List<SqliteType>? sqliteFieldTypes,
      })
          setField) {
        this.setField = setField;

        setField_normal = ({
          required String fieldName,
          required List<SqliteType>? sqliteFieldTypes,
          required String? dartFieldType,
        }) {
          return setField(
            fieldName: fieldName,
            setFieldType: SetFieldType.normal,
            sqliteFieldTypes: sqliteFieldTypes,
            dartFieldType: dartFieldType,
            foreignKeyTableName: null,
            foreignKeyRowName: null,
            isDeleteChildFollowFatherIfIsId: null,
          );
        };
        setField_x_aiid_integer = ({
          required String fieldName,
          required String? foreignKeyTableName,
          required String? foreignKeyRowName,
          required bool? isDeleteChildFollowFatherIfIsId,
        }) {
          return setField(
            fieldName: fieldName,
            setFieldType: SetFieldType.foreign_key_x_aiid_integer,
            sqliteFieldTypes: null,
            dartFieldType: null,
            foreignKeyTableName: foreignKeyTableName,
            foreignKeyRowName: foreignKeyRowName,
            isDeleteChildFollowFatherIfIsId: isDeleteChildFollowFatherIfIsId,
          );
        };
        setField_x_uuid_text = ({
          required String fieldName,
          required String? foreignKeyTableName,
          required String? foreignKeyRowName,
          required bool? isDeleteChildFollowFatherIfIsId,
        }) {
          return setField(
            fieldName: fieldName,
            setFieldType: SetFieldType.foreign_key_x_uuid_text,
            sqliteFieldTypes: null,
            dartFieldType: null,
            foreignKeyTableName: foreignKeyTableName,
            foreignKeyRowName: foreignKeyRowName,
            isDeleteChildFollowFatherIfIsId: isDeleteChildFollowFatherIfIsId,
          );
        };
        setField_x_any_integer = ({
          required String fieldName,
          required String? foreignKeyTableName,
          required String? foreignKeyRowName,
          required bool? isDeleteChildFollowFatherIfIsId,
        }) {
          return setField(
            fieldName: fieldName,
            setFieldType: SetFieldType.foreign_key_any_integer,
            sqliteFieldTypes: null,
            dartFieldType: null,
            foreignKeyTableName: foreignKeyTableName,
            foreignKeyRowName: foreignKeyRowName,
            isDeleteChildFollowFatherIfIsId: isDeleteChildFollowFatherIfIsId,
          );
        };
        setField_x_any_text = ({
          required String fieldName,
          required String? foreignKeyTableName,
          required String? foreignKeyRowName,
          required bool? isDeleteChildFollowFatherIfIsId,
        }) {
          return setField(
            fieldName: fieldName,
            setFieldType: SetFieldType.foreign_key_any_text,
            sqliteFieldTypes: null,
            dartFieldType: null,
            foreignKeyTableName: foreignKeyTableName,
            foreignKeyRowName: foreignKeyRowName,
            isDeleteChildFollowFatherIfIsId: isDeleteChildFollowFatherIfIsId,
          );
        };
        return createFields;
      },
      createExtraEnums: (String Function(String, List<String>) setExtraEnumMembers) {
        this.setExtraEnumMembers = setExtraEnumMembers;

        return createExtraEnums ?? <String>[];
      },
      extraGlobalEnum: extraGlobalEnum ?? false,
    );
  }

  late Map<String, List<Object>> Function({
    required String fieldName,
    required SetFieldType setFieldType,
    required List<SqliteType>? sqliteFieldTypes,
    required String? dartFieldType,
    required String? foreignKeyTableName,
    required String? foreignKeyRowName,
    required bool? isDeleteChildFollowFatherIfIsId,
  }) setField;

  late Map<String, List<Object>> Function({
    required String fieldName,
    required List<SqliteType>? sqliteFieldTypes,
    required String? dartFieldType,
  }) setField_normal;

  late Map<String, List<Object>> Function({
    required String fieldName,
    required String? foreignKeyTableName,
    required String? foreignKeyRowName,
    required bool? isDeleteChildFollowFatherIfIsId,
  }) setField_x_aiid_integer;

  late Map<String, List<Object>> Function({
    required String fieldName,
    required String? foreignKeyTableName,
    required String? foreignKeyRowName,
    required bool? isDeleteChildFollowFatherIfIsId,
  }) setField_x_uuid_text;

  late Map<String, List<Object>> Function({
    required String fieldName,
    required String? foreignKeyTableName,
    required String? foreignKeyRowName,
    required bool? isDeleteChildFollowFatherIfIsId,
  }) setField_x_any_integer;

  late Map<String, List<Object>> Function({
    required String fieldName,
    required String? foreignKeyTableName,
    required String? foreignKeyRowName,
    required bool? isDeleteChildFollowFatherIfIsId,
  }) setField_x_any_text;

  /// 第一个参数：枚举名称。第二个参数：枚举成员。
  late String Function(String, List<String>) setExtraEnumMembers;

  String get tableNameWithS;
  List<Map<String, List<Object>>> get createFields;
  List<String>? createExtraEnums;
  bool? extraGlobalEnum;

  String id = 'id';
  String aiid = 'aiid';
  String uuid = 'uuid';
  String created_at = 'created_at';
  String updated_at = 'updated_at';
}
