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

enum SetFieldType {
  /// 非 in 类型
  normal,

  /// x_aiid 类型
  foreign_key_x_aiid_integer,

  /// x_uuid 类型
  foreign_key_x_uuid_text,

  /// x_id_integer 类型
  foreign_key_any_integer,

  /// x_id_text 类型
  foreign_key_any_text,

  /// id、aiid、uuid 都已经在 [CreateModel] 中默认配置了
}

List<String> dartType = <String>['String', 'int'];

/// 全局枚举。eg. ["enum ABC {a,b,c}"]
List<String> globalEnum = <String>[];

/// 模型名称、字段。eg. {"table_name":{"field1":[SqliteType.TEXT,"int"]}}
Map<String, Map<String, List<Object>>> modelFields = <String, Map<String, List<Object>>>{};

/// 模型对应的额外枚举内容。eg. {"table_name":"enum ABC {a,b,c}"}
///
/// 值不能为 []，要么是 null 要么元素至少一个
Map<String, String> extraEnumContents = <String, String>{};

/// 模型是否需要全局枚举内容。eg. {"table_name":true}
Map<String, bool> extraGlobalEnumContents = <String, bool>{};

String modelsPath = 'lib/Database/Models';

// ===============================================================================
// ===============================================================================

/// 模型外键对应的 table_name 和 Column_name。{"table_name":{"foreign_key":"table_name.Column_name"}}
Map<String, Map<String, String?>> foreignKeyBelongsTos = <String, Map<String, String?>>{};

/// 当删除当前 row 时，需要同时删除对应外键的 row 的外键名
///
/// xx_aiid 和 xx_uuid 会合并成 xx
///
/// eg.{"table_name":{"foreign_key1","foreign_key2"}}
Map<String, Set<String>> deleteForeignKeyFollowCurrentForTwo = <String, Set<String>>{};

Map<String, Set<String>> deleteForeignKeyFollowCurrentForSingle = <String, Set<String>>{};

// ===============================================================================

/// 当删除当前 row 对应的外键的 row 时，需要同时删除当前 row 的键名
///
/// xx_aiid 和 xx_uuid 会合并成 xx
///
/// eg.{'table_name':{'foreign_key1','foreign_key2'}}
Map<String, Set<String>> deleteCurrentFollowForeignKeyForTwo = <String, Set<String>>{};

Map<String, Set<String>> deleteCurrentFollowForeignKeyForSingle = <String, Set<String>>{};

/// [foreignKeyBelongsTos] 的反向 for Two
///
/// 含义：当前表被哪个表的哪个外键所关联
///
/// 中间的 xx_aiid 和 xx_uuid 会合并成 xx
///
/// 尾部的 aiid 和 uuid 会合并成 ''，xx_aiid 和 xx_uuid 会合并成 xx
///
/// eg. {'table_name':{'table_name1.Column_name1.'(尾缀是 aiid 和 uuid),'table_name2.Column_name2.yy'(尾缀是 xx_aiid 和 xx_uuid)}}
Map<String, Set<String>> foreignKeyHaveManyForTwo = <String, Set<String>>{};

/// eg. {'table_name':{'table_name1.Column_name1.the_key','table_name2.Column_name2.the_key'}}
Map<String, Set<String>> foreignKeyHaveManyForSingle = <String, Set<String>>{};

/// 仅保留【当前表被哪个表的哪个外键所关联】中的【当前表被删除时需同时删除其表】的 Column
///
/// eg. {'table_name':{'table_name1.Column_name1.'(尾缀是 aiid 和 uuid),'table_name2.Column_name2.yy'(尾缀是 xx_aiid 和 xx_uuid)}}
Map<String, Set<String>> deleteManyForeignKeyForTwo = <String, Set<String>>{};

/// eg. {'table_name':{'table_name1.Column_name1.the_key','table_name2.Column_name2.the_key'}}
Map<String, Set<String>> deleteManyForeignKeyForSingle = <String, Set<String>>{};

// ===============================================================================
// ===============================================================================

Future<void> main(List<String> args) async {
  await setPath();
  runCreateModels();
  afterRunCreateModels();
  await runWriteModels();
  await runParseIntoSqls();
  await runWriteGlobalEnum();
  await runWriteMBase();
}

void afterRunCreateModels() {
  for (int x = 0; x < foreignKeyHaveManyForTwo.values.length; x++) {
    for (int y = 0; y < foreignKeyHaveManyForTwo.values.elementAt(x).length; y++) {
      // 遍历 foreignKeyHaveManyForTwo 的 tableNameAndColumnName
      final List<String> tableNameAndColumnName = foreignKeyHaveManyForTwo.values.elementAt(x).elementAt(y).split('.');
      // 检查 deleteForeignKeyHaveManyForTwo 中是否存在
      if (deleteCurrentFollowForeignKeyForTwo.containsKey(tableNameAndColumnName[0]) && deleteCurrentFollowForeignKeyForTwo[tableNameAndColumnName[0]]!.contains(tableNameAndColumnName[1])) {
        // 存在的话 给 deleteCurrentFollowForeignKeyForTwo 添加
        if (!deleteManyForeignKeyForTwo.containsKey(foreignKeyHaveManyForTwo.keys.elementAt(x))) {
          deleteManyForeignKeyForTwo.addAll(<String, Set<String>>{foreignKeyHaveManyForTwo.keys.elementAt(x): <String>{}});
        }
        if (!deleteManyForeignKeyForTwo[foreignKeyHaveManyForTwo.keys.elementAt(x)]!.contains(foreignKeyHaveManyForTwo.values.elementAt(x).elementAt(y))) {
          deleteManyForeignKeyForTwo[foreignKeyHaveManyForTwo.keys.elementAt(x)]!.add(foreignKeyHaveManyForTwo.values.elementAt(x).elementAt(y));
        }
      }
    }
  }
  for (int x = 0; x < foreignKeyHaveManyForSingle.values.length; x++) {
    for (int y = 0; y < foreignKeyHaveManyForSingle.values.elementAt(x).length; y++) {
      // 遍历 foreignKeyHaveManyForTwo 的 tableNameAndColumnName
      final List<String> tableNameAndColumnName = foreignKeyHaveManyForSingle.values.elementAt(x).elementAt(y).split('.');
      // 检查 deleteForeignKeyHaveManyForTwo 中是否存在
      if (deleteCurrentFollowForeignKeyForSingle.containsKey(tableNameAndColumnName[0]) && deleteCurrentFollowForeignKeyForSingle[tableNameAndColumnName[0]]!.contains(tableNameAndColumnName[1])) {
        // 存在的话 给 deleteCurrentFollowForeignKeyForTwo 添加
        if (!deleteManyForeignKeyForSingle.containsKey(foreignKeyHaveManyForSingle.keys.elementAt(x))) {
          deleteManyForeignKeyForSingle.addAll(<String, Set<String>>{foreignKeyHaveManyForSingle.keys.elementAt(x): <String>{}});
        }
        if (!deleteManyForeignKeyForSingle[foreignKeyHaveManyForSingle.keys.elementAt(x)]!.contains(foreignKeyHaveManyForSingle.values.elementAt(x).elementAt(y))) {
          deleteManyForeignKeyForSingle[foreignKeyHaveManyForSingle.keys.elementAt(x)]!.add(foreignKeyHaveManyForSingle.values.elementAt(x).elementAt(y));
        }
      }
    }
  }
}

Future<void> setPath() async {
  // ignore: avoid_slow_async_io
  if (await Directory(modelsPath).exists()) {
    await Directory(modelsPath).list().forEach((FileSystemEntity element) {
      if (element.uri.pathSegments.last[0] != 'M') {
        throw 'Unknown file in Models folder: ${element.uri.pathSegments.last}';
      }
    });
  } else {
    await Directory(modelsPath).create();
  }
}

Future<void> runWriteModels() async {
  for (int i = 0; i < modelFields.length; i++) {
    final String tableNameWithS = modelFields.keys.elementAt(i);
    final Map<String, List<Object>> fields = modelFields[tableNameWithS]!;

    await File('$modelsPath/M${toCamelCaseWillRemoveS(tableNameWithS)}.dart').writeAsString(modelContent(tableNameWithS, fields));
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

  await File('$modelsPath/MParseIntoSqls.dart').writeAsString(parseIntoSqlsContent(rawSqls));
  print("'MParseIntoSqls' file is created successfully!");
}

Future<void> runWriteGlobalEnum() async {
  String globalEnumString = '';
  for (final String gEnum in globalEnum) {
    globalEnumString += gEnum;
  }
  await File('$modelsPath/MGlobalEnum.dart').writeAsString(globalEnumString);
  print("'MGlobalEnum' file is created successfully!");
}

Future<void> runWriteMBase() async {
  await File('$modelsPath/MBase.dart').writeAsString(baseModelContent());
  print("'MBase' file is created successfully!");
}
