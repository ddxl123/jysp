// ignore_for_file: non_constant_identifier_names

import 'package:jysp/Database/run/main.dart';

/// 创建模型
class CreateModel {
  ///

  ///
  /// - [tableNameWithS]：要创建的表的名称。
  /// - [createField]：要创建的表的字段。
  /// - [createExtraEnums]：创建额外枚举类。
  ///   - ```
  ///     return [ setExtraEnumMembers(enumTypeName: "SqliteDownloadStatus", members: ["downloaded", "notDownload"]) ];
  ///     ```
  /// - [extraGlobalEnum]：是否需要全局枚举。
  CreateModel({
    required this.tableNameWithS,
    required this.createFields,
    this.createExtraEnums,
    this.extraGlobalEnum = false,
  }) {
    modelFields.addAll(
      <String, Map<String, List<Object>>>{
        tableNameWithS: <String, List<Object>>{
          'id': <Object>[SqliteType.INTEGER, SqliteType.UNSIGNED, SqliteType.PRIMARY_KEY, SqliteType.AUTOINCREMENT, 'int'],
          'aiid': <Object>[SqliteType.INTEGER, 'int'],
          'uuid': <Object>[SqliteType.TEXT, 'String'],
          ...() {
            final List<Map<String, List<Object>>> fieldsList = createFields(setFields);
            final Map<String, List<Object>> fieldsMap = <String, List<Object>>{};
            for (int i = 0; i < fieldsList.length; i++) {
              fieldsMap.addAll(fieldsList[i]);
            }
            return fieldsMap;
          }(),
          'created_at': <Object>[SqliteType.INTEGER, SqliteType.UNSIGNED, 'int'],
          'updated_at': <Object>[SqliteType.INTEGER, SqliteType.UNSIGNED, 'int'],
        },
      },
    );
    extraEnumContents.addAll(
      <String, String>{
        tableNameWithS: () {
          if (createExtraEnums == null) {
            throw 'createExtraEnums can not be null';
          }
          String extraEnumsString = '';
          for (final String extraEnum in createExtraEnums!(setExtraEnumMembers)) {
            extraEnumsString += extraEnum;
          }
          return extraEnumsString;
        }()
      },
    );
    extraGlobalEnumContents.addAll(<String, bool>{tableNameWithS: extraGlobalEnum});
  }

  final String tableNameWithS;

  final List<Map<String, List<Object>>> Function(
    Map<String, List<Object>> Function({
      required String fieldName,
      required SetFieldType setFieldType,
      required List<SqliteType>? sqliteFieldTypes,
      required String? dartFieldType,
      required String? foreignKeyTableName,
      required String? foreignKeyRowName,
      required bool? isDeleteChildFollowFatherIfIsId,
    })
        setFields,
  ) createFields;

  List<String> Function(String Function(String enumTypeName, List<String> members) setExtraEnumMembers)? createExtraEnums;

  final bool extraGlobalEnum;

  /// 设置字段类型
  Map<String, List<Object>> setFields({
    required String fieldName,
    required SetFieldType setFieldType,
    required List<SqliteType>? sqliteFieldTypes,
    required String? dartFieldType,
    required String? foreignKeyTableName,
    required String? foreignKeyRowName,
    required bool? isDeleteChildFollowFatherIfIsId,
  }) {
    if (setFieldType == SetFieldType.normal) {
      if (sqliteFieldTypes == null || dartFieldType == null) {
        throw 'The sqliteFieldTypes or dartFieldType can not be null when sqliteFieldTypes == SetFieldType.normal';
      }
      if (foreignKeyTableName != null || foreignKeyRowName != null || isDeleteChildFollowFatherIfIsId != null) {
        throw 'The foreignKeyTableName or foreignKeyRowName or foreignKeyRowName must be null when sqliteFieldTypes == SetFieldType.normal';
      }
      return toSetFieldType(
        fieldName: fieldName,
        sqliteFieldTypes: sqliteFieldTypes,
        dartFieldType: dartFieldType,
      );
    }
    //
    else if (setFieldType == SetFieldType.foreign_key_x_aiid_integer) {
      if (sqliteFieldTypes != null || dartFieldType != null) {
        throw 'The sqliteFieldTypes or dartFieldType must be null when sqliteFieldTypes == SetFieldType.foreign_key_x_aiid_integer';
      }
      if (isDeleteChildFollowFatherIfIsId == null) {
        throw 'The isDeleteChildFollowFatherIfIsId can not be null when sqliteFieldTypes == SetFieldType.foreign_key_x_aiid_integer';
      }
      toSetForeignKeyBelongsTo(fieldName: fieldName, foreignKeyTableName: foreignKeyTableName, foreignKeyRowName: foreignKeyRowName);
      toSetIsDeleteChildFollowFather_ForTwo(fieldName: fieldName, isDeleteChildFollowFatherIfIsId: isDeleteChildFollowFatherIfIsId);
      return toSetFieldType(
        fieldName: fieldName,
        sqliteFieldTypes: <SqliteType>[SqliteType.INTEGER, SqliteType.UNSIGNED],
        dartFieldType: 'int',
      );
    }
    //
    else if (setFieldType == SetFieldType.foreign_key_x_uuid_text) {
      if (sqliteFieldTypes != null || dartFieldType != null) {
        throw 'The sqliteFieldTypes or dartFieldType must be null when sqliteFieldTypes == SetFieldType.foreign_key_x_uuid_text';
      }
      if (isDeleteChildFollowFatherIfIsId == null) {
        throw 'The isDeleteChildFollowFatherIfIsId can not be null when sqliteFieldTypes == SetFieldType.foreign_key_x_uuid_text';
      }
      toSetForeignKeyBelongsTo(fieldName: fieldName, foreignKeyTableName: foreignKeyTableName, foreignKeyRowName: foreignKeyRowName);
      toSetIsDeleteChildFollowFather_ForTwo(fieldName: fieldName, isDeleteChildFollowFatherIfIsId: isDeleteChildFollowFatherIfIsId);
      return toSetFieldType(
        fieldName: fieldName,
        sqliteFieldTypes: <SqliteType>[SqliteType.TEXT],
        dartFieldType: 'String',
      );
    }
    //
    else if (setFieldType == SetFieldType.foreign_key_any_integer) {
      if (sqliteFieldTypes != null || dartFieldType != null) {
        throw 'The sqliteFieldTypes or dartFieldType must be null when sqliteFieldTypes == SetFieldType.foreign_key_single_integer';
      }
      if (isDeleteChildFollowFatherIfIsId == null) {
        throw 'The isDeleteChildFollowFatherIfIsId can not be null when sqliteFieldTypes == SetFieldType.foreign_key_any_integer';
      }
      toSetForeignKeyBelongsTo(fieldName: fieldName, foreignKeyTableName: foreignKeyTableName, foreignKeyRowName: foreignKeyRowName);
      toSetIsDeleteChildFollowFather_ForSingle(fieldName: fieldName, isDeleteChildFollowFatherIfIsId: isDeleteChildFollowFatherIfIsId);
      return toSetFieldType(
        fieldName: fieldName,
        sqliteFieldTypes: <SqliteType>[SqliteType.INTEGER, SqliteType.UNSIGNED],
        dartFieldType: 'int',
      );
    }
    //
    else if (setFieldType == SetFieldType.foreign_key_any_text) {
      if (sqliteFieldTypes != null || dartFieldType != null) {
        throw 'The sqliteFieldTypes or dartFieldType must be null when sqliteFieldTypes == SetFieldType.foreign_key_single_text';
      }
      if (isDeleteChildFollowFatherIfIsId == null) {
        throw 'The isDeleteChildFollowFatherIfIsId can not be null when sqliteFieldTypes == SetFieldType.foreign_key_any_text';
      }
      toSetForeignKeyBelongsTo(fieldName: fieldName, foreignKeyTableName: foreignKeyTableName, foreignKeyRowName: foreignKeyRowName);
      toSetIsDeleteChildFollowFather_ForSingle(fieldName: fieldName, isDeleteChildFollowFatherIfIsId: isDeleteChildFollowFatherIfIsId);
      return toSetFieldType(
        fieldName: fieldName,
        sqliteFieldTypes: <SqliteType>[SqliteType.TEXT],
        dartFieldType: 'String',
      );
    }
    //
    else {
      throw 'unknown setFieldType: $setFieldType';
    }
  }

  /// 设置字段名和对应的 sqlite 类型、dart 类型
  Map<String, List<Object>> toSetFieldType({
    required String fieldName,
    required List<SqliteType> sqliteFieldTypes,
    required String dartFieldType,
  }) {
    return <String, List<Object>>{
      fieldName: <Object>[...sqliteFieldTypes, dartFieldType]
    };
  }

  /// 设置当前外键字段归属的 table 和 row
  void toSetForeignKeyBelongsTo({required String fieldName, String? foreignKeyTableName, String? foreignKeyRowName}) {
    if ((foreignKeyTableName == null && foreignKeyRowName != null) || (foreignKeyTableName != null && foreignKeyRowName == null)) {
      throw 'ForeignKeyTableName and foreignKeyRowName are either empty or neither.';
    }
    if (foreignKeyBelongsTo[tableNameWithS] == null) {
      foreignKeyBelongsTo[tableNameWithS] = <String, String?>{fieldName: '$foreignKeyTableName.$foreignKeyRowName'};
    } else {
      foreignKeyBelongsTo[tableNameWithS]!.addAll(<String, String?>{fieldName: '$foreignKeyTableName.$foreignKeyRowName'});
    }
  }

  /// 如果是 aiid 和 uuid 的话，需移除尾缀合并成一个
  void toSetIsDeleteChildFollowFather_ForTwo({required String fieldName, required bool isDeleteChildFollowFatherIfIsId}) {
    if (isDeleteChildFollowFatherIfIsId) {
      // 去掉尾缀再添加
      final String asSingle = fieldName.substring(0, fieldName.length - 5);
      if (deleteChildFollowFatherKeysForTwo.containsKey(tableNameWithS)) {
        deleteChildFollowFatherKeysForTwo[tableNameWithS]!.add('\'$asSingle\'');
      } else {
        deleteChildFollowFatherKeysForTwo[tableNameWithS] = <String>{'\'$asSingle\''};
      }
    }
  }

  /// 如果是 single 的话，直接添加
  void toSetIsDeleteChildFollowFather_ForSingle({required String fieldName, required bool isDeleteChildFollowFatherIfIsId}) {
    if (isDeleteChildFollowFatherIfIsId) {
      if (deleteChildFollowFatherKeysForSingle.containsKey(tableNameWithS)) {
        deleteChildFollowFatherKeysForSingle[tableNameWithS]!.add('\'$fieldName\'');
      } else {
        deleteChildFollowFatherKeysForSingle[tableNameWithS] = <String>{'\'$fieldName\''};
      }
    }
  }

  /// 设置额外枚举类成员
  String setExtraEnumMembers(String enumTypeName, List<String> members) {
    String membersString = '';
    for (final String member in members) {
      membersString += member + ',';
    }
    return 'enum $enumTypeName {$membersString}';
  }
}

/// 创建全局枚举类
void createGlobalEnums(List<List<String>> enumNameAndMembers) {
  for (final List<String> element in enumNameAndMembers) {
    String enumString = 'enum ' + element[0] + '{';
    for (int i = 0; i < element.length; i++) {
      if (i != 0) {
        enumString += element[i] + ',';
      }
    }
    enumString += '}';
    globalEnum.add(enumString);
  }
}
