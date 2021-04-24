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
          'atid': <Object>[SqliteType.INTEGER, 'int'],
          'uuid': <Object>[SqliteType.TEXT, 'String'],
          ...() {
            final List<Map<String, List<Object>>> fieldsList = createFields(setFields, x_id_integer, x_id_text);
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
      <String, String?>{
        tableNameWithS: () {
          if (createExtraEnums == null) {
            return null;
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
    Map<String, List<Object>> Function(String fieldName, List<SqliteType> sqliteFieldTypes, String dartFieldType) setFields,
    Map<String, List<Object>> Function(String fieldName, String? foreignKeyTableName, {required bool isDeleteFatherFollowChild, required bool isDeleteChildFollowFather}) x_id_integer,
    Map<String, List<Object>> Function(String fieldName, String? foreignKeyTableName, {required bool isDeleteFatherFollowChild, required bool isDeleteChildFollowFather}) x_id_text,
  ) createFields;

  List<String> Function(String Function(String enumTypeName, List<String> members) setExtraEnumMembers)? createExtraEnums;

  final bool extraGlobalEnum;

  /// 设置字段类型
  Map<String, List<Object>> setFields(String fieldName, List<Object> sqliteFieldTypes, String dartFieldType) {
    return <String, List<Object>>{
      fieldName: <Object>[...sqliteFieldTypes, dartFieldType]
    };
  }

  /// 快捷 —— INTEGER 类型，非主键
  Map<String, List<Object>> x_id_integer(String fieldName, String? foreignKeyTableName, {required bool isDeleteFatherFollowChild, required bool isDeleteChildFollowFather}) {
    set_x_id(fieldName, foreignKeyTableName, isDeleteFatherFollowChild: isDeleteFatherFollowChild, isDeleteChildFollowFather: isDeleteChildFollowFather);
    return setFields(fieldName, <Object>[SqliteType.INTEGER, SqliteType.UNSIGNED], 'int');
  }

  /// 快捷 —— TEXT 类型，非主键
  Map<String, List<Object>> x_id_text(String fieldName, String? foreignKeyTableName, {required bool isDeleteFatherFollowChild, required bool isDeleteChildFollowFather}) {
    set_x_id(fieldName, foreignKeyTableName, isDeleteFatherFollowChild: isDeleteFatherFollowChild, isDeleteChildFollowFather: isDeleteChildFollowFather);
    return setFields(fieldName, <Object>[SqliteType.TEXT], 'String');
  }

  void set_x_id(String fieldName, String? foreignKeyTableName, {required bool isDeleteFatherFollowChild, required bool isDeleteChildFollowFather}) {
    if (foreignKeyTableNames[tableNameWithS] == null) {
      foreignKeyTableNames[tableNameWithS] = <String, String?>{fieldName: foreignKeyTableName};
    } else {
      foreignKeyTableNames[tableNameWithS]!.addAll(<String, String?>{fieldName: foreignKeyTableName});
    }

    if (isDeleteFatherFollowChild) {
      if (deleteFatherFollowChilds[tableNameWithS] == null) {
        deleteFatherFollowChilds[tableNameWithS] = <String>[fieldName];
      } else {
        deleteFatherFollowChilds[tableNameWithS]!.add(fieldName);
      }
    }
    if (isDeleteChildFollowFather) {
      if (deleteChildFollowFathers[tableNameWithS] == null) {
        deleteChildFollowFathers[tableNameWithS] = <String>[fieldName];
      } else {
        deleteChildFollowFathers[tableNameWithS]!.add(fieldName);
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
