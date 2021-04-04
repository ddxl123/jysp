// ignore_for_file: non_constant_identifier_names

import 'dart:convert';
import 'dart:io';

import 'package:jysp/Database/Run/ModelConfig.dart';
import 'package:jysp/Database/base/SqliteType.dart';

/// 模型名称、字段
Map<String, Map<String, List<SqliteType>>> modelContents = {};

/// 下载模块
List<String> downloadBaseModules = [];

/// 快捷 —— INTEGER 类型，非主键
List<SqliteType> x_id_integer() => setFieldTypes([SqliteType.INTEGER, SqliteType.UNSIGNED], SqliteType.int);

/// 快捷 —— TEXT 类型，非主键
List<SqliteType> x_id_text() => setFieldTypes([SqliteType.TEXT], SqliteType.String);

/// 设置字段类型
List<SqliteType> setFieldTypes(List<SqliteType> sqliteFieldTypes, SqliteType dartFieldType) {
  List<SqliteType> finalFieldTypes = [];
  finalFieldTypes.addAll(sqliteFieldTypes);
  finalFieldTypes.add(dartFieldType);
  return finalFieldTypes;
}

/// 创建字段
Map<String, List<SqliteType>> createFields({
  required Map<String, List<SqliteType>> fields,
  required bool timestamp,
  required bool curd_status,
}) {
  Map<String, List<SqliteType>> finalFields = {};
  finalFields.addAll(fields);
  if (timestamp) {
    finalFields.addAll({
      "created_at": [SqliteType.INTEGER, SqliteType.UNSIGNED, SqliteType.NOT_NULL, SqliteType.int],
      "updated_at": [SqliteType.INTEGER, SqliteType.UNSIGNED, SqliteType.NOT_NULL, SqliteType.int],
    });
  }
  if (curd_status) {
    finalFields.addAll({
      "curd_status": [SqliteType.INTEGER, SqliteType.int],
    });
  }
  return finalFields;
}

/// 创建模型
void createModel({
  required String tableNameWithS,
  required Map<String, List<SqliteType>> createField,
}) {
  modelContents.addAll({tableNameWithS: createField});
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
  await runCreateModelsList();
}

Future<void> runWriteModels() async {
  for (int i = 0; i < modelContents.length; i++) {
    String tableNameWithS = modelContents.keys.elementAt(i);
    Map<String, List<SqliteType>> fields = modelContents[tableNameWithS]!;

    await File("lib/Database/models/M${toCamelCaseWillRemoveS(tableNameWithS)}.dart").writeAsString(modelContent(tableNameWithS, fields));
    print("Named '$tableNameWithS''s table model file is created successfully!");
  }
}

Future<void> runCreateModelsList() async {
  List<String> modelList = [];
  String modelImport = "";
  modelContents.forEach(
    (tableNameWithS, fields) {
      String modelName = "M${toCamelCaseWillRemoveS(tableNameWithS)}";
      modelList.add("$modelName()");
      modelImport += "import 'package:jysp/Database/models/$modelName.dart';";
    },
  );

  await File("lib/Database/models/ModelList.dart").writeAsString(modelListContent(modelImport, modelList));
  print("'ModelList' file is created successfully!");
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
String fieldNameQuickCall(Map<String, List<SqliteType>> fields) {
  String quickCall = "";
  fields.forEach(
    (fieldName, filedTypes) {
      quickCall += """

  static String get $fieldName => "$fieldName";
""";
    },
  );
  return quickCall;
}

/// 转化成 SQL 语句，需要把 fields 内的 List 的最后一个移除
String sql(Map<String, List<SqliteType>> fields) {
  Map<String, List<SqliteType>> newFields = {};
  fields.forEach(
    (fieldName, fieldTypes) {
      newFields[fieldName] = fieldTypes.sublist(0, fieldTypes.length - 1);
    },
  );
  return newFields.toString();
}

/// 字段映射成 Map
List<String> toMap(Map<String, List<SqliteType>> fields) {
  String input = "";
  String out = "";
  fields.forEach(
    (fieldName, fieldTypes) {
      input += "required ${fieldTypes[fieldTypes.length - 1].value} ${fieldName}_v,"; // 例子：required int username_v,
      out += (fieldName + ":" + fieldName + "_v,"); // 例子：username: username_v,
    },
  );
  return [input, out];
}

/// 模型内容
String modelContent(String tableNameWithS, Map<String, List<SqliteType>> fields) {
  return """
// ignore_for_file: non_constant_identifier_names

import 'package:jysp/Database/base/DBTableBase.dart';
import 'package:jysp/Database/base/SqliteType.dart';

class M${toCamelCaseWillRemoveS(tableNameWithS)} implements DBTableBase {
  @override
  String getTableNameInstance = getTableName;

  static String get getTableName => "$tableNameWithS";
${fieldNameQuickCall(fields)}
  @override
  Map<String, List<SqliteType>> get fields => ${sql(fields)};

  static Map<String, dynamic> toMap({${toMap(fields)[0]}}
  ) {
    return {${toMap(fields)[1]}};
  }
}
""";
}

/// 模型列表
String modelListContent(String modelImport, List<String> modelList) {
  return """
import 'package:jysp/Database/base/DBTableBase.dart';
$modelImport
class ModelList {
  static List<DBTableBase> models = $modelList;

  static List<String> downloadBaseModules = ${JsonEncoder.withIndent("").convert(downloadBaseModules)};
}
""";
}
