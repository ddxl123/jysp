// ignore_for_file: non_constant_identifier_names

import 'dart:convert';
import 'dart:io';

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
      case 7:
        return 'int';
      case 8:
        return 'String';
      default:
        throw Exception('Unknown value!');
    }
  }
}

List<String> dartType = <String>['String', 'int'];

/// 模型名称、字段。eg. {"user_table":{"field1":[SqliteType.TEXT,"int"]}}
Map<String, Map<String, List<Object>>> modelFields = <String, Map<String, List<Object>>>{};

/// 模型对应的额外内容。eg. {"user_table":"static int id = "123";}
Map<String, String?> extraContents = <String, String?>{};

/// 模型对应的额外枚举内容。eg. {"user_table":"enum ABC {a,b,c}"}
Map<String, String?> extraEnumContents = <String, String?>{};

/// 模型是否需要全局枚举内容。eg. {"user_table":true}
Map<String, bool> extraGlobalEnumContents = <String, bool>{};

/// 全局枚举。eg. ["enum ABC {a,b,c}"]
List<String> globalEnum = <String>[];

/// 快捷 —— INTEGER 类型，非主键
List<Object> x_id_integer() => setFieldTypes(<Object>[SqliteType.INTEGER, SqliteType.UNSIGNED], 'int');

/// 快捷 —— TEXT 类型，非主键
List<Object> x_id_text() => setFieldTypes(<Object>[SqliteType.TEXT], 'String');

/// 设置字段类型
List<Object> setFieldTypes(List<Object> sqliteFieldTypes, String dartFieldType) {
  final List<Object> finalFieldTypes = <Object>[];
  finalFieldTypes.addAll(sqliteFieldTypes);
  finalFieldTypes.add(dartFieldType);
  return finalFieldTypes;
}

/// 创建字段
Map<String, List<Object>> createFields({required Map<String, List<Object>> fields}) {
  return <String, List<Object>>{
    'id': <Object>[SqliteType.INTEGER, SqliteType.UNSIGNED, SqliteType.PRIMARY_KEY, SqliteType.AUTOINCREMENT, 'int'],
    'atid': <Object>[SqliteType.INTEGER, 'int'],
    'uuid': <Object>[SqliteType.TEXT, 'String'],
    ...fields,
    'created_at': <Object>[SqliteType.INTEGER, SqliteType.UNSIGNED, 'int'],
    'updated_at': <Object>[SqliteType.INTEGER, SqliteType.UNSIGNED, 'int'],
  };
}

/// 创建模型
void createModel({
  required String tableNameWithS,
  required Map<String, List<Object>> createField,
  String? extra,
  String? extraEnum,
  bool extraGlobalEnum = false,
}) {
  modelFields.addAll(<String, Map<String, List<Object>>>{tableNameWithS: createField});
  extraContents.addAll(<String, String?>{tableNameWithS: extra});
  extraEnumContents.addAll(<String, String?>{tableNameWithS: extraEnum});
  extraGlobalEnumContents.addAll(<String, bool>{tableNameWithS: extraGlobalEnum});
}

/// 设置额外枚举类成员
String setExtraEnumMembers({required String enumTypeName, required List<String> members}) {
  String membersString = '';
  for (final String member in members) {
    membersString += member + ',';
  }
  return 'enum $enumTypeName {$membersString}';
}

/// 创建额外枚举类
/// ```
/// createExtraEnums([setExtraEnumMembers(enumTypeName: "SqliteDownloadStatus", members: ["downloaded", "notDownload"])]);
/// ```
String createExtraEnums(List<String> extraEnums) {
  String extraEnumsString = '';
  for (final String extraEnum in extraEnums) {
    extraEnumsString += extraEnum;
  }
  return extraEnumsString;
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

Future<void> main(List<String> args) async {
  runCreateModels();
  await runWriteModels();
  await runParseIntoSqls();
  await runWriteGlobalEnum();
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

/// 将 demo_texts 形式转化成 DemoText 形式;
String toCamelCaseWillRemoveS(String demo_texts) {
  final String removeS = demo_texts.substring(0, demo_texts.length - 1);
  final List<String> split = removeS.split('_');
  for (int i = 0; i < split.length; i++) {
    split[i] = split[i][0].toUpperCase() + split[i].substring(1);
  }
  return split.join('');
}

/// 模型字段对应的快速调用成员字段
String fieldNameQuickCall(Map<String, List<Object>> fields) {
  String quickCall = '';
  fields.forEach(
    (String fieldName, List<Object> fieldTypes) {
      quickCall += '''
  static String get $fieldName => '$fieldName';
''';
    },
  );
  return quickCall;
}

/// 模型实例对应的 get 字段
String instanceFieldValues(Map<String, List<Object>> fields) {
  // int? get get_pn_pending_pool_node_id => _rowJson[pn_pending_pool_node_id] == null ? null : _rowJson[pn_pending_pool_node_id] as int?;
  // PendingPoolNodeType? get get_type => _rowJson[type] == null ? null : PendingPoolNodeType.values[_rowJson[type] as int];
  String fieldValues = '';
  fields.forEach(
    (String fieldName, List<Object> fieldTypes) {
      fieldValues += () {
        String haveOverride = '';
        if (fieldName == 'id' || fieldName == 'atid' || fieldName == 'uuid' || fieldName == 'updated_at' || fieldName == 'created_at') {
          haveOverride = '@override';
        }
        if (dartType.contains(fieldTypes[fieldTypes.length - 1])) {
          // eg. String? get get_username => _rowJson[username]
          return '''$haveOverride ${fieldTypes.last}? get get_$fieldName => _rowJson[$fieldName] as ${fieldTypes[fieldTypes.length - 1]}?;''';
        } else {
          // eg. String? get get_username => _rowJson[username] == null ? null : NodeType.values[_rowJson[username] as int],
          return '''$haveOverride ${fieldTypes.last}? get get_$fieldName => _rowJson[$fieldName] == null ? null : ${fieldTypes[fieldTypes.length - 1]}.values[_rowJson[$fieldName]! as int];''';
        }
      }();
    },
  );
  return fieldValues;
}

/// 模型字段组转成 Sqlite 字段组
List<String> asJsonNoId(Map<String, List<Object>> fields) {
  String input = '';
  String out = '';
  fields.forEach(
    (String fieldName, List<Object> fieldTypes) {
      if (fieldName == 'id') {
        return;
      }
      input += 'required ${fieldTypes[fieldTypes.length - 1]}? ${fieldName}_v,'; // 例子：required int? username_v,
      out += () {
        if (dartType.contains(fieldTypes[fieldTypes.length - 1])) {
          return fieldName + ':' + fieldName + '_v,'; // 例子：username: username_v,
        } else {
          return fieldName + ':' + fieldName + '_v?.index,'; // 例子：username: username_v?.index --- username: nodeTypeEnum?.index,
        }
      }();
    },
  );
  return <String>[input, out];
}

/// Sqlite 字段组转成模型字段组
String asModelNoId(Map<String, List<Object>> fields) {
  String out = '';
  fields.forEach(
    (String fieldName, List<Object> fieldTypes) {
      if (fieldName == 'id') {
        return;
      }
      out += () {
        if (dartType.contains(fieldTypes[fieldTypes.length - 1])) {
          // eg. username: json[username],
          return fieldName + ':' + 'json[$fieldName],';
        } else {
          // eg. username: json[username] == null ? null : NodeType.values[json[username] as int],
          return fieldName + ':' + 'json[$fieldName] == null ? null : ${fieldTypes[fieldTypes.length - 1]}.values[json[$fieldName]! as int],';
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
import 'package:jysp/Database/Base/MBase.dart';
import 'package:jysp/G/GSqlite/GSqlite.dart';
${extraGlobalEnumContents[tableNameWithS] == true ? "import 'package:jysp/Database/Models/GlobalEnum.dart';" : ""}
${extraEnumContents[tableNameWithS] ?? ""}
class M${toCamelCaseWillRemoveS(tableNameWithS)} implements MBase{

  M${toCamelCaseWillRemoveS(tableNameWithS)}();

  /// 1. insert 时，无需传入 id ，id 是自增的。
  /// 2. 若只创建 model 而并非 inset，id 的值为 null。
  M${toCamelCaseWillRemoveS(tableNameWithS)}.createModel({${asJsonNoId(fields)[0]}}) {
    _rowJson.addAll(<String, Object?>{${asJsonNoId(fields)[1]}});
  }

  static String get getTableName => '$tableNameWithS';

${fieldNameQuickCall(fields)}

  static Map<String, Object?> asJsonNoId({${asJsonNoId(fields)[0]}}
  ) {
    return <String, Object?>{${asJsonNoId(fields)[1]}};
  }

  static Map<String, Object?> asModelNoId(Map<String, Object?> json) {
    return <String, Object?>{${asModelNoId(fields)}};
  }

  static Future<List<Map<String, Object?>>> getAllRowsAsJson() async {
    return await db.query(getTableName);
  }

  static Future<List<M${toCamelCaseWillRemoveS(tableNameWithS)}>> getAllRowsAsModel() async {
    final List<Map<String, Object?>> allRows = await getAllRowsAsJson();
    final List<M${toCamelCaseWillRemoveS(tableNameWithS)}> allRowModels = <M${toCamelCaseWillRemoveS(tableNameWithS)}>[];
    for (final Map<String, Object?> row in allRows) {
        final M${toCamelCaseWillRemoveS(tableNameWithS)} newRowModel = M${toCamelCaseWillRemoveS(tableNameWithS)}();
        newRowModel._rowJson.addAll(row);
        allRowModels.add(newRowModel);
    }
    return allRowModels;
  }

  /// 值只有 int String bool null 类型，没有枚举类型，而是枚举的 int 值
  final Map<String, Object?> _rowJson = <String, Object?>{};

  @override
  Map<String, Object?> get getRowJson=> _rowJson;

  @override
  String get getCurrentTableName => getTableName;

${extraContents[tableNameWithS] ?? ""}

${instanceFieldValues(fields)}
}
""";
}

/// raw sqls
String parseIntoSqlsContent(Map<String, String> rawSqls) {
  return """
class ParseIntoSqls {
  Map<String, String> parseIntoSqls = <String, String>${const JsonEncoder.withIndent('  ').convert(rawSqls).replaceAll(RegExp(r'"'), '\'')};
}
""";
}
