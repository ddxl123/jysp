// ignore_for_file: non_constant_identifier_names

import 'dart:io';

import 'package:jysp/Database/Run/Content.dart';
import 'package:jysp/Database/Run/ModelConfig.dart';

enum SqliteType {
  // Sqlite 类型
  TEXT,
  INTEGER,
  UNIQUE,
  PRIMARY_KEY,
  NOT_NULL,
  UNSIGNED,
  AUTOINCREMENT,
}

extension SqliteTypeValue on SqliteType {
  String get value {
    switch (index) {
      case 0:
        return 'TEXT';
      case 1:
        return 'INTEGER';
      case 2:
        return 'UNIQUE';
      case 3:
        return 'PRIMARY_KEY';
      case 4:
        return 'NOT_NULL';
      case 5:
        return 'UNSIGNED';
      case 6:
        return 'AUTO_INCREMENT';
      default:
        throw Exception('Unknown value!');
    }
  }
}

List<String> dartType = <String>['String', 'int'];

/// 全局枚举。eg. ["enum ABC {a,b,c}"]
List<String> globalEnum = <String>[];

/// 模型名称、字段。eg. {"table_name":{"field1":[SqliteType.TEXT,"int"]}}
Map<String, Map<String, List<Object>>> modelFields = <String, Map<String, List<Object>>>{};

/// 模型外键对应的表。{"table_name":{"foreign_key":"table_name"}}
Map<String, Map<String, String?>> foreignKeyTableNames = <String, Map<String, String?>>{};

/// 当删除当前 row 时，需要同时删除对应 row 的外键名
/// - eg.{"table_name":["foreign_key1","foreign_key2"]}
Map<String, List<String>> deleteChildFollowFathers = <String, List<String>>{};

/// 当删除外键时，需要同时删除当前 row 的外键名
/// - eg.{"table_name":["foreign_key1","foreign_key2"]}
Map<String, List<String>> deleteFatherFollowChilds = <String, List<String>>{};

/// 模型对应的额外枚举内容。eg. {"table_name":"enum ABC {a,b,c}"}
Map<String, String?> extraEnumContents = <String, String?>{};

/// 模型是否需要全局枚举内容。eg. {"table_name":true}
Map<String, bool> extraGlobalEnumContents = <String, bool>{};

Future<void> main(List<String> args) async {
  runCreateModels();
  await runWriteModels();
  await runParseIntoSqls();
  await runWriteGlobalEnum();
  await runWriteMBase();
}

Future<void> runWriteModels() async {
  for (int i = 0; i < modelFields.length; i++) {
    final String tableNameWithS = modelFields.keys.elementAt(i);
    final Map<String, List<Object>> fields = modelFields[tableNameWithS]!;

    await File('lib/Database/Models/M${toCamelCaseWillRemoveS(tableNameWithS)}.dart').writeAsString(modelContent(tableNameWithS, fields));
    print("Named '$tableNameWithS''s table model file is created successfully!");
  }
}

Future<void> runParseIntoSqls() async {
  final Map<String, String> rawSqls = <String, String>{};
  modelFields.forEach(
    (String tableName, Map<String, List<Object>> fieldTypes) {
      String rawFieldsSql = ''; // 最终: "CREATE TABLE table_name (username TEXT UNIQUE,password TEXT,),"
      fieldTypes.forEach(
        (String fieldName, List<Object> fieldTypes) {
          String rawFieldSql = fieldName;
          final List<Object> newFieldTypes = fieldTypes.sublist(0, fieldTypes.length - 1);
          for (final Object fieldType in newFieldTypes) {
            rawFieldSql += ' ' + (fieldType as SqliteType).value; // 形成 "username TEXT UNIQUE,"
          }
          rawFieldsSql += '$rawFieldSql,'; // 形成 "username TEXT UNIQUE,password TEXT,"
        },
      );
      rawFieldsSql = rawFieldsSql.replaceAll(RegExp(r',$'), ''); // 去掉结尾逗号
      rawSqls.addAll(<String, String>{tableName: 'CREATE TABLE $tableName ($rawFieldsSql)'}); // 形成 "CREATE TABLE table_name (username TEXT UNIQUE,password TEXT,),"
    },
  );

  await File('lib/Database/Models/ParseIntoSqls.dart').writeAsString(parseIntoSqlsContent(rawSqls));
  print("'ParseIntoSqls' file is created successfully!");
}

Future<void> runWriteGlobalEnum() async {
  String globalEnumString = '';
  for (final String gEnum in globalEnum) {
    globalEnumString += gEnum;
  }
  await File('lib/Database/Models/GlobalEnum.dart').writeAsString(globalEnumString);
  print("'GlobalEnum' file is created successfully!");
}

Future<void> runWriteMBase() async {
  await File('lib/Database/Base/MBase.dart').writeAsString(baseModelContent());
  print("'MBase' file is created successfully!");
}
