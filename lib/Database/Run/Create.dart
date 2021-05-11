// ignore_for_file: non_constant_identifier_names

import 'package:jysp/Database/Run/main.dart';

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
            final List<Map<String, List<Object>>> fieldsList = createFields(setField);
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

  /// [isDeleteForeignKeyFollowCurrent]：删除当前 row 后是否需要同时删除该键对应的 row
  /// [isDeleteCurrentFollowForeignKey]：删除外键对应的 row 后是否需要同时删除当前 row
  final List<Map<String, List<Object>>> Function(
    Map<String, List<Object>> Function({
      required String fieldName,
      required SetFieldType setFieldType,
      required List<SqliteType>? sqliteFieldTypes,
      required String? dartFieldType,
      required String? foreignKeyColumnNameWithTableName,
      required bool? isDeleteForeignKeyFollowCurrent,
      required bool? isDeleteCurrentFollowForeignKey,
    })
        setField,
  ) createFields;

  List<String> Function(String Function(String enumTypeName, List<String> members) setExtraEnumMembers)? createExtraEnums;

  final bool extraGlobalEnum;

  /// 设置字段类型
  Map<String, List<Object>> setField({
    required String fieldName,
    required SetFieldType setFieldType,
    required List<SqliteType>? sqliteFieldTypes,
    required String? dartFieldType,
    required String? foreignKeyColumnNameWithTableName,
    required bool? isDeleteForeignKeyFollowCurrent,
    required bool? isDeleteCurrentFollowForeignKey,
  }) {
    // 当前键是普通的键时
    if (setFieldType == SetFieldType.normal) {
      if (sqliteFieldTypes == null || dartFieldType == null) {
        throw 'sqliteFieldTypes == null || dartFieldType == null --- $sqliteFieldTypes,$dartFieldType';
      }
      if (foreignKeyColumnNameWithTableName != null) {
        throw 'foreignKeyColumnNameWithTableName != null --- $foreignKeyColumnNameWithTableName';
      }
      return toSetFieldType(fieldName: fieldName, sqliteFieldTypes: sqliteFieldTypes, dartFieldType: dartFieldType);
    }

    // 当前键是外键或是被其他表关联的键时
    if (sqliteFieldTypes != null || dartFieldType != null) {
      throw 'sqliteFieldTypes != null || dartFieldType != null --- $sqliteFieldTypes,$dartFieldType';
    }
    if (isDeleteForeignKeyFollowCurrent == null || isDeleteCurrentFollowForeignKey == null) {
      throw 'isDeleteForeignKeyFollowCurrent == null || isDeleteCurrentFollowForeignKey == null --- $isDeleteForeignKeyFollowCurrent,$isDeleteCurrentFollowForeignKey';
    }

    toSetBelongsTo(fieldName: fieldName, foreignKeyColumnNameWithTableName: foreignKeyColumnNameWithTableName);

    // 有对应的 uuid 时使用
    if (setFieldType == SetFieldType.foreign_key_x_aiid_integer) {
      toSetManyForTwo(fieldName: fieldName, foreignKeyColumnNameWithTableName: foreignKeyColumnNameWithTableName);
      toSetDeleteForTwo(fieldName: fieldName, isDeleteForeignKeyFollowCurrent: isDeleteForeignKeyFollowCurrent, isDeleteCurrentFollowForeignKey: isDeleteCurrentFollowForeignKey);
      return toSetFieldType(fieldName: fieldName, sqliteFieldTypes: <SqliteType>[SqliteType.INTEGER, SqliteType.UNSIGNED], dartFieldType: 'int');
    }
    // 有对应的 aaid 时使用
    else if (setFieldType == SetFieldType.foreign_key_x_uuid_text) {
      toSetManyForTwo(fieldName: fieldName, foreignKeyColumnNameWithTableName: foreignKeyColumnNameWithTableName);
      toSetDeleteForTwo(fieldName: fieldName, isDeleteForeignKeyFollowCurrent: isDeleteForeignKeyFollowCurrent, isDeleteCurrentFollowForeignKey: isDeleteCurrentFollowForeignKey);
      return toSetFieldType(fieldName: fieldName, sqliteFieldTypes: <SqliteType>[SqliteType.TEXT], dartFieldType: 'String');
    }
    //
    else if (setFieldType == SetFieldType.foreign_key_any_integer) {
      toSetManyForSingle(fieldName: fieldName, foreignKeyColumnNameWithTableName: foreignKeyColumnNameWithTableName);
      toSetDeleteForSingle(fieldName: fieldName, isDeleteForeignKeyFollowCurrent: isDeleteForeignKeyFollowCurrent, isDeleteCurrentFollowForeignKey: isDeleteCurrentFollowForeignKey);
      return toSetFieldType(fieldName: fieldName, sqliteFieldTypes: <SqliteType>[SqliteType.INTEGER, SqliteType.UNSIGNED], dartFieldType: 'int');
    }
    //
    else if (setFieldType == SetFieldType.foreign_key_any_text) {
      toSetManyForSingle(fieldName: fieldName, foreignKeyColumnNameWithTableName: foreignKeyColumnNameWithTableName);
      toSetDeleteForSingle(fieldName: fieldName, isDeleteForeignKeyFollowCurrent: isDeleteForeignKeyFollowCurrent, isDeleteCurrentFollowForeignKey: isDeleteCurrentFollowForeignKey);
      return toSetFieldType(fieldName: fieldName, sqliteFieldTypes: <SqliteType>[SqliteType.TEXT], dartFieldType: 'String');
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

  // ================================================================================
  // ================================================================================

  /// 设置当前外键字段归属的 table 和 Column
  void toSetBelongsTo({required String fieldName, required String? foreignKeyColumnNameWithTableName}) {
    if (foreignKeyBelongsTos[tableNameWithS] == null) {
      foreignKeyBelongsTos[tableNameWithS] = <String, String?>{fieldName: foreignKeyColumnNameWithTableName};
    } else {
      foreignKeyBelongsTos[tableNameWithS]!.addAll(<String, String?>{fieldName: foreignKeyColumnNameWithTableName});
    }
  }

  /// 设置反向 foreignKeyBelongsTo for Two
  void toSetManyForTwo({required String fieldName, required String? foreignKeyColumnNameWithTableName}) {
    if (foreignKeyColumnNameWithTableName != null) {
      // 只需要外键对应的表名，无需外键对应表名的 Column 名，因为对应的 Column 名可能会是 aiid/uuid，而非 _aiid/_uuid
      final List<String> foreignKeyTableNameAndColumnName = foreignKeyColumnNameWithTableName.split('.');
      final String foreignKeyTableName = foreignKeyTableNameAndColumnName[0];
      final String foreignKeyColumnName = foreignKeyTableNameAndColumnName[1];

      // 去掉尾缀
      final String currentAsSingle = fieldName.substring(0, fieldName.length - 5);

      // 去掉尾缀
      // 减到 xx_/xx
      String foreignKeyAsSingle = foreignKeyColumnName.substring(0, foreignKeyColumnName.length - 4);
      // 减到 xx/xx
      if (foreignKeyAsSingle.endsWith('_')) {
        foreignKeyAsSingle = foreignKeyAsSingle.substring(0, foreignKeyAsSingle.length - 1);
      }

      // foreignTableName 这个表被当前表的 asSingle 这个外键所关联
      if (!foreignKeyHaveManyForTwo.containsKey(foreignKeyTableName)) {
        foreignKeyHaveManyForTwo.addAll(<String, Set<String>>{foreignKeyTableName: <String>{}});
      }
      if (!foreignKeyHaveManyForTwo[foreignKeyTableName]!.contains('$tableNameWithS.$currentAsSingle.$foreignKeyAsSingle')) {
        foreignKeyHaveManyForTwo[foreignKeyTableName]!.add('$tableNameWithS.$currentAsSingle.$foreignKeyAsSingle');
      }
    }
  }

  /// 设置反向 foreignKeyBelongsTo for Single
  void toSetManyForSingle({required String fieldName, required String? foreignKeyColumnNameWithTableName}) {
    if (foreignKeyColumnNameWithTableName != null) {
      // 只需要外键对应的表名，无需外键对应表名的 Column 名
      final List<String> foreignKeyTableNameAndColumnName = foreignKeyColumnNameWithTableName.split('.');
      final String foreignKeyTableName = foreignKeyTableNameAndColumnName[0];
      final String foreignKeyColumnName = foreignKeyTableNameAndColumnName[1];

      // foreignTableName 这个表被当前表的 fieldName 这个外键所关联
      if (!foreignKeyHaveManyForTwo.containsKey(foreignKeyTableName)) {
        foreignKeyHaveManyForTwo.addAll(<String, Set<String>>{foreignKeyTableName: <String>{}});
      }
      if (!foreignKeyHaveManyForTwo[foreignKeyTableName]!.contains('$tableNameWithS.$fieldName.$foreignKeyColumnName')) {
        foreignKeyHaveManyForTwo[foreignKeyTableName]!.add('$tableNameWithS.$fieldName.$foreignKeyColumnName');
      }
    }
  }

  // ================================================================================

  /// 以下是 belongsTo 和 many 一起 set

  /// 如果是 xx_aiid 和 xx_uuid 的话，需移除尾缀合并成一个
  void toSetDeleteForTwo({required String fieldName, required bool isDeleteForeignKeyFollowCurrent, required bool isDeleteCurrentFollowForeignKey}) {
    // 去掉尾缀再添加
    final String asSingle = fieldName.substring(0, fieldName.length - 5);

    if (isDeleteForeignKeyFollowCurrent) {
      if (deleteForeignKeyFollowCurrentForTwo.containsKey(tableNameWithS)) {
        deleteForeignKeyFollowCurrentForTwo[tableNameWithS]!.add(asSingle);
      } else {
        deleteForeignKeyFollowCurrentForTwo[tableNameWithS] = <String>{asSingle};
      }
    }

    if (isDeleteCurrentFollowForeignKey) {
      if (deleteCurrentFollowForeignKeyForTwo.containsKey(tableNameWithS)) {
        deleteCurrentFollowForeignKeyForTwo[tableNameWithS]!.add(asSingle);
      } else {
        deleteCurrentFollowForeignKeyForTwo[tableNameWithS] = <String>{asSingle};
      }
    }
  }

  /// 如果是 single 的话，直接添加
  void toSetDeleteForSingle({required String fieldName, required bool isDeleteForeignKeyFollowCurrent, required bool isDeleteCurrentFollowForeignKey}) {
    if (isDeleteForeignKeyFollowCurrent) {
      if (deleteForeignKeyFollowCurrentForSingle.containsKey(tableNameWithS)) {
        deleteForeignKeyFollowCurrentForSingle[tableNameWithS]!.add(fieldName);
      } else {
        deleteForeignKeyFollowCurrentForSingle[tableNameWithS] = <String>{fieldName};
      }
    }

    if (isDeleteCurrentFollowForeignKey) {
      if (deleteCurrentFollowForeignKeyForSingle.containsKey(tableNameWithS)) {
        deleteCurrentFollowForeignKeyForSingle[tableNameWithS]!.add(fieldName);
      } else {
        deleteCurrentFollowForeignKeyForSingle[tableNameWithS] = <String>{fieldName};
      }
    }
  }

  // ================================================================================
  // ================================================================================

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
