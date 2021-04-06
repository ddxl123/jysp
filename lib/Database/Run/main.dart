// ignore_for_file: non_constant_identifier_names

import 'dart:convert';
import 'dart:io';

import 'package:jysp/Database/Run/ModelConfig.dart';
import 'package:jysp/Database/base/SqliteType.dart';

List<String> dartType = ["String", "int"];

/// 模型名称、字段。eg. {"user_table":{"field1":[SqliteType.TEXT,"int"]}}
Map<String, Map<String, List<Object>>> modelFields = {};

/// 模型对应的额外内容。eg. {"user_table":"static int id = "123";}
Map<String, String?> extraContents = {};

/// 模型对应的额外内容。eg. {"user_table":"enum ABC {a,b,c}"}
Map<String, String?> extraEnumContents = {};

/// 下载队列基础模块。eg. ["用户信息"]
List<List<String>> downloadBaseModules = [];

/// 快捷 —— INTEGER 类型，非主键
List<Object> x_id_integer() => setFieldTypes([SqliteType.INTEGER, SqliteType.UNSIGNED], "int");

/// 快捷 —— TEXT 类型，非主键
List<Object> x_id_text() => setFieldTypes([SqliteType.TEXT], "String");

/// 设置字段类型
List<Object> setFieldTypes(List<Object> sqliteFieldTypes, String dartFieldType) {
  List<Object> finalFieldTypes = [];
  finalFieldTypes.addAll(sqliteFieldTypes);
  finalFieldTypes.add(dartFieldType);
  return finalFieldTypes;
}

/// 创建字段
Map<String, List<Object>> createFields({
  required Map<String, List<Object>> fields,
  required bool timestamp,
  required bool curd_status,
}) {
  Map<String, List<Object>> finalFields = {};
  finalFields.addAll(fields);
  if (timestamp) {
    finalFields.addAll({
      "created_at": [SqliteType.INTEGER, SqliteType.UNSIGNED, "int"],
      "updated_at": [SqliteType.INTEGER, SqliteType.UNSIGNED, "int"],
    });
  }
  if (curd_status) {
    finalFields.addAll({
      "curd_status": [SqliteType.INTEGER, "int"],
    });
  }
  return finalFields;
}

/// 创建模型
void createModel({
  required String tableNameWithS,
  required Map<String, List<Object>> createField,
  String? extra,
  String? extraEnum,
}) {
  modelFields.addAll({tableNameWithS: createField});
  extraContents.addAll({tableNameWithS: extra});
  extraEnumContents.addAll({tableNameWithS: extraEnum});
}

/// 设置额外枚举类成员
String setExtraEnumMembers({required String enumTypeName, required List<String> members}) {
  String membersString = "";
  members.forEach(
    (member) {
      membersString += member + ",";
    },
  );
  return "enum $enumTypeName {$membersString}";
}

/// 创建额外枚举类
String createExtraEnums(List<String> extraEnums) {
  String extraEnumsString = "";
  extraEnums.forEach(
    (extraEnum) {
      extraEnumsString += extraEnum;
    },
  );
  return extraEnumsString;
}

///
///
///
///
///
///
///
///
///
///
///
///
///
///
/// 执行模块
///

void main(List<String> args) async {
  runCreateModels();
  await runWriteModels();
  await runParseIntoSqls();
}

Future<void> runWriteModels() async {
  for (int i = 0; i < modelFields.length; i++) {
    String tableNameWithS = modelFields.keys.elementAt(i);
    Map<String, List<Object>> fields = modelFields[tableNameWithS]!;

    await File("lib/Database/models/M${toCamelCaseWillRemoveS(tableNameWithS)}.dart").writeAsString(modelContent(tableNameWithS, fields));
    print("Named '$tableNameWithS''s table model file is created successfully!");
  }
}

Future<void> runParseIntoSqls() async {
  Map<String, String> rawSqls = {};
  modelFields.forEach(
    (tableName, fieldTypes) {
      String rawFieldsSql = ""; // 最终: "CREATE TABLE table_name (username TEXT UNIQUE,password TEXT,),"
      fieldTypes.forEach(
        (fieldName, fieldTypes) {
          String rawFieldSql = "$fieldName";
          List<SqliteType> newFieldTypes = fieldTypes.sublist(0, fieldTypes.length - 1) as List<SqliteType>;
          newFieldTypes.forEach(
            (fieldType) {
              rawFieldSql += (" " + fieldType.value); // 形成 "username TEXT UNIQUE,"
            },
          );
          rawFieldsSql += "$rawFieldSql,"; // 形成 "username TEXT UNIQUE,password TEXT,"
        },
      );
      rawFieldsSql = rawFieldsSql.replaceAll(RegExp(r",$"), ""); // 去掉结尾逗号
      rawSqls.addAll({tableName: "CREATE TABLE $tableName ($rawFieldsSql)"}); // 形成 "CREATE TABLE table_name (username TEXT UNIQUE,password TEXT,),"
    },
  );

  await File("lib/Database/models/ParseIntoSqls.dart").writeAsString(parseIntoSqlsContent(rawSqls));
  print("'ParseIntoSqls' file is created successfully!");
}

/// 将 demo_texts 形式转化成 DemoText 形式;
String toCamelCaseWillRemoveS(String demo_texts) {
  String removeS = demo_texts.substring(0, demo_texts.length - 1);
  List<String> split = removeS.split("_");
  for (int i = 0; i < split.length; i++) {
    split[i] = split[i][0].toUpperCase() + split[i].substring(1);
  }
  return split.join("");
}

/// 模型字段对应的快速调用成员字段
String fieldNameQuickCall(Map<String, List<Object>> fields) {
  String quickCall = "";
  fields.forEach(
    (fieldName, fieldTypes) {
      quickCall += """
  static String get $fieldName => "$fieldName";
""";
    },
  );
  return quickCall;
}

/// 模型实例对应的 get 字段
String instanceFieldValues(Map<String, List<Object>> fields) {
  String fieldValues = "";
  fields.forEach(
    (fieldName, filedTypes) {
      fieldValues += """
  ${filedTypes.last}? get get_$fieldName => _rowModel[$fieldName] as ${filedTypes.last}?;
"""; // eg. int? get name => _row[name] as int?;
    },
  );
  return fieldValues;
}

/// 模型字段组转成 Sqlite 字段组
List<String> toSqliteMap(Map<String, List<Object>> fields) {
  String input = "";
  String out = "";
  fields.forEach(
    (fieldName, fieldTypes) {
      input += "required ${fieldTypes[fieldTypes.length - 1]}? ${fieldName}_v,"; // 例子：required int? username_v,
      out += () {
        if (dartType.contains(fieldTypes[fieldTypes.length - 1])) {
          return (fieldName + ":" + fieldName + "_v,"); // 例子：username: username_v,
        } else {
          return (fieldName + ":" + fieldName + "_v?.index,"); // 例子：username: username_v?.index --- username: nodeTypeEnum?.index,
        }
      }();
    },
  );
  return [input, out];
}

/// Sqlite 字段组转成模型字段组
String toModelMap(Map<String, List<Object>> fields) {
  String out = "";
  fields.forEach(
    (fieldName, fieldTypes) {
      out += () {
        if (dartType.contains(fieldTypes[fieldTypes.length - 1])) {
          // eg. username: sqliteMap[username],
          return (fieldName + ":" + "sqliteMap[$fieldName],");
        } else {
          // eg. username: sqliteMap[username] == null ? null : NodeType.values[sqliteMap[username] as int],
          return (fieldName + ":" + "sqliteMap[$fieldName] == null ? null : ${fieldTypes[fieldTypes.length - 1]}.values[sqliteMap[$fieldName] as int],");
        }
      }();
    },
  );
  return out;
}

/// 模型内容
String modelContent(String tableNameWithS, Map<String, List<Object>> fields) {
  return """
// ignore_for_file: non_constant_identifier_names
import 'package:jysp/G/GSqlite/GSqlite.dart';
${extraEnumContents[tableNameWithS] ?? ""}
class M${toCamelCaseWillRemoveS(tableNameWithS)} {

  M${toCamelCaseWillRemoveS(tableNameWithS)}();

  M${toCamelCaseWillRemoveS(tableNameWithS)}.createModel({${toSqliteMap(fields)[0]}}) {
    _rowModel.addAll({${toSqliteMap(fields)[1]}});
  }

  static String get getTableName => "$tableNameWithS";

${fieldNameQuickCall(fields)}

  static Map<String, Object?> toSqliteMap({${toSqliteMap(fields)[0]}}
  ) {
    return {${toSqliteMap(fields)[1]}};
  }

  static Map<String, Object?> toModelMap(Map<String, Object?> sqliteMap) {
    return {${toModelMap(fields)}};
  }

  static Future<List<M${toCamelCaseWillRemoveS(tableNameWithS)}>> getAllRowsAsModel() async {
    List<Map<String, Object?>> allRows = await GSqlite.db.query(getTableName);
    List<M${toCamelCaseWillRemoveS(tableNameWithS)}> allRowModels = [];
    allRows.forEach(
      (row) {
        M${toCamelCaseWillRemoveS(tableNameWithS)} newRowModel = M${toCamelCaseWillRemoveS(tableNameWithS)}();
        newRowModel._rowModel = toModelMap(row);
        allRowModels.add(newRowModel);
      },
    );
    return allRowModels;
  }

  Map<String, Object?> _rowModel = {};

${extraContents[tableNameWithS] ?? ""}

${instanceFieldValues(fields)}
}
""";
}

/// raw sqls
String parseIntoSqlsContent(Map<String, String> rawSqls) {
  return """
class ParseIntoSqls {
  Map<String, String> parseIntoSqls = ${JsonEncoder.withIndent("  ").convert(rawSqls)};
}
""";
}
