// ignore_for_file: non_constant_identifier_names
import 'dart:convert';

import 'package:jysp/Database/Run/main.dart';

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

  /// 若 [byId] 为 null，则 query 的是全部 row。
  static Future<List<Map<String, Object?>>> queryRowsAsJsons([int? byId]) async {
    if (byId == null) {
      return await db.query(getTableName);
    } else {
      return await db.query(getTableName, where: 'id = ?', whereArgs: <int>[byId]);
    }
  }

  /// 若 [byId] 为 null，则 query 的是全部 row。
  static Future<List<M${toCamelCaseWillRemoveS(tableNameWithS)}>> queryRowsAsModels([int? byId]) async {
    final List<Map<String, Object?>> rows = await queryRowsAsJsons(byId);
    final List<M${toCamelCaseWillRemoveS(tableNameWithS)}> rowModels = <M${toCamelCaseWillRemoveS(tableNameWithS)}>[];
    for (final Map<String, Object?> row in rows) {
        final M${toCamelCaseWillRemoveS(tableNameWithS)} newRowModel = M${toCamelCaseWillRemoveS(tableNameWithS)}();
        newRowModel._rowJson.addAll(row);
        rowModels.add(newRowModel);
    }
    return rowModels;
  }

  @override
  Map<String, Object?> get getRowJson => _rowJson;

  @override
  Map<String, String?> get getForeignKeyTableNames => _foreignKeyTableNames;

  @override
  List<String> get getDeleteChildFollowFathers => _deleteChildFollowFathers;

  @override
  List<String> get getDeleteFatherFollowChilds => _deleteFatherFollowChilds;

  final Map<String, Object?> _rowJson = <String, Object?>{};

  final Map<String, String?> _foreignKeyTableNames = <String, String?>${foreignKeyTableNames[tableNameWithS] == null ? '{}' : const JsonEncoder.withIndent('  ').convert(foreignKeyTableNames[tableNameWithS]).replaceAll(RegExp(r'"'), '\'')};

  final List<String> _deleteChildFollowFathers = <String>${deleteChildFollowFathers[tableNameWithS] == null ? '[]' : '[' + deleteChildFollowFathers[tableNameWithS]!.join(',') + ',]'};

  final List<String> _deleteFatherFollowChilds =<String>${deleteFatherFollowChilds[tableNameWithS] == null ? '[]' : '[' + deleteFatherFollowChilds[tableNameWithS]!.join(',') + ',]'};

  @override
  String get getCurrentTableName => getTableName;

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

/// MBase
String baseModelContent() {
  String importContent = '';
  String queryByTableNameAsModelsContent = '';
  String queryByTableNameAsJsonsContent = '';
  for (int i = 0; i < modelFields.keys.length; i++) {
    importContent += """import 'package:jysp/Database/Models/M${toCamelCaseWillRemoveS(modelFields.keys.elementAt(i))}.dart';""";
    queryByTableNameAsModelsContent += """
        case '${modelFields.keys.elementAt(i)}':
        return await M${toCamelCaseWillRemoveS(modelFields.keys.elementAt(i))}.queryRowsAsModels(byId);""";
    queryByTableNameAsJsonsContent += """
        case '${modelFields.keys.elementAt(i)}':
        return await M${toCamelCaseWillRemoveS(modelFields.keys.elementAt(i))}.queryRowsAsJsons(byId);""";
  }

  return """
// ignore_for_file: non_constant_identifier_names
$importContent

abstract class MBase {
  ///

  /// 值只有 int String bool null 类型，没有枚举类型（而是枚举的 int 值）
  Map<String, Object?> get getRowJson;

  /// 外键对应的表。key: 外键名；value: 对应的表名
  Map<String, String?> get getForeignKeyTableNames;

  /// 当删除当前 row 时，需要同时删除对应 row 的外键名
  List<String> get getDeleteChildFollowFathers;

  /// 当删除外键时，需要同时删除当前 row 的外键名
  List<String> get getDeleteFatherFollowChilds;

  String get getCurrentTableName;
  int? get get_id;
  int? get get_atid;
  String? get get_uuid;
  int? get get_updated_at;
  int? get get_created_at;

  /// 若 [byId] 为 null，则 query 的是全部 row。
  static Future<List<MBase>> queryByTableNameAsModels(String tableName, [int? byId]) async {
    switch (tableName) {
      $queryByTableNameAsModelsContent
      default:
        throw 'tableName is unknown';
    }
  }

  /// 若 [byId] 为 null，则 query 的是全部 row。
  static Future<List<Map<String, Object?>>> queryByTableNameAsJsons(String tableName, [int? byId]) async {
    switch (tableName) {
      $queryByTableNameAsJsonsContent
      default:
        throw 'tableName is unknown';
    }
  }

  ///
}

  """;
}