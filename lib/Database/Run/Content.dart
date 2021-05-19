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
  // int? get get_pn_pending_pool_node_id => getRowJson[pn_pending_pool_node_id] == null ? null : getRowJson[pn_pending_pool_node_id] as int?;
  // PendingPoolNodeType? get get_type => getRowJson[type] == null ? null : PendingPoolNodeType.values[getRowJson[type] as int];
  String fieldValues = '';
  fields.forEach(
    (String fieldName, List<Object> fieldTypes) {
      fieldValues += () {
        String haveOverride = '';
        if (fieldName == 'id' || fieldName == 'aiid' || fieldName == 'uuid' || fieldName == 'updated_at' || fieldName == 'created_at') {
          haveOverride = '@override';
        }
        if (dartType.contains(fieldTypes[fieldTypes.length - 1])) {
          // eg. String? get get_username => getRowJson[username]
          return '''$haveOverride ${fieldTypes.last}? get get_$fieldName => getRowJson[$fieldName] as ${fieldTypes[fieldTypes.length - 1]}?;''';
        } else {
          // eg. String? get get_username => getRowJson[username] == null ? null : NodeType.values[getRowJson[username] as int],
          return '''$haveOverride ${fieldTypes.last}? get get_$fieldName => getRowJson[$fieldName] == null ? null : ${fieldTypes[fieldTypes.length - 1]}.values[getRowJson[$fieldName]! as int];''';
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
import 'package:jysp/Database/Models/MBase.dart';
${extraGlobalEnumContents[tableNameWithS] == true ? "import 'package:jysp/Database/Models/MGlobalEnum.dart';" : ""}

${extraEnumContents[tableNameWithS] ?? ""}

class M${toCamelCaseWillRemoveS(tableNameWithS)} implements MBase{

  M${toCamelCaseWillRemoveS(tableNameWithS)}();

  /// 1. insert 时，无需传入 id ，id 是自增的。
  /// 2. 若只创建 model 而并非 inset，id 的值为 null。
  M${toCamelCaseWillRemoveS(tableNameWithS)}.createModel({${asJsonNoId(fields)[0]}}) {
    getRowJson.addAll(<String, Object?>{${asJsonNoId(fields)[1]}});
  }

  static String get tableName => '$tableNameWithS';

${fieldNameQuickCall(fields)}

  static Map<String, Object?> asJsonNoId({${asJsonNoId(fields)[0]}}
  ) {
    return <String, Object?>{${asJsonNoId(fields)[1]}};
  }

  static Map<String, Object?> asModelNoId(Map<String, Object?> json) {
    return <String, Object?>{${asModelNoId(fields)}};
  }

  // ====================================================================
  // ====================================================================

  @override
  String? getForeignKeyBelongsTos({required String foreignKeyName}) => ${foreignKeyBelongsTos[tableNameWithS] == null ? '<String,String?>{}' : () {
          String result = '';
          foreignKeyBelongsTos[tableNameWithS]!.forEach((String key, String? value) {
            result += "$key: ${value == null ? 'null' : "'$value'"},";
          });
          return '<String,String?>{$result}';
        }()}[foreignKeyName];

  @override
  Set<String> get getDeleteForeignKeyFollowCurrentForTwo => <String>${deleteForeignKeyFollowCurrentForTwo[tableNameWithS] == null ? '{}' : '{' + deleteForeignKeyFollowCurrentForTwo[tableNameWithS]!.join(',') + ',}'};

  @override
  Set<String> get getDeleteForeignKeyFollowCurrentForSingle => <String>${deleteForeignKeyFollowCurrentForSingle[tableNameWithS] == null ? '{}' : '{' + deleteForeignKeyFollowCurrentForSingle[tableNameWithS]!.join(',') + ',}'};

  // ====================================================================

  @override
  List<String> get getDeleteManyForeignKeyForTwo => ${deleteManyForeignKeyForTwo[tableNameWithS] == null ? '<String>[]' : () {
          String result = '';
          for (int i = 0; i < deleteManyForeignKeyForTwo[tableNameWithS]!.length; i++) {
            result += "'${deleteManyForeignKeyForTwo[tableNameWithS]!.elementAt(i)}',";
          }
          return '<String>[$result]';
        }()};

  @override
  List<String> get getDeleteManyForeignKeyForSingle => ${deleteManyForeignKeyForSingle[tableNameWithS] == null ? '<String>[]' : () {
          String result = '';
          for (int i = 0; i < deleteManyForeignKeyForSingle[tableNameWithS]!.length; i++) {
            result += "'${deleteManyForeignKeyForSingle[tableNameWithS]!.elementAt(i)}',";
          }
          return '<String>[$result]';
        }()};

  // ====================================================================
  // ====================================================================

  final Map<String, Object?> _rowJson = <String, Object?>{};

  @override
  Map<String, Object?> get getRowJson => _rowJson;


  @override
  String get getTableName => tableName;

${instanceFieldValues(fields)}
}
""";
}

/// raw sqls
String parseIntoSqlsContent(Map<String, String> rawSqls) {
  return """
class MParseIntoSqls {
  Map<String, String> parseIntoSqls = <String, String>${const JsonEncoder.withIndent('  ').convert(rawSqls).replaceAll(RegExp(r'"'), '\'')};
}
""";
}

/// MBase
String baseModelContent() {
  String importContent = '';
  String createEmptyModelByTableNameContent = '';
  for (int i = 0; i < modelFields.keys.length; i++) {
    importContent += """import 'package:jysp/Database/Models/M${toCamelCaseWillRemoveS(modelFields.keys.elementAt(i))}.dart';""";
    createEmptyModelByTableNameContent += 'case \'${modelFields.keys.elementAt(i)}\': return M${toCamelCaseWillRemoveS(modelFields.keys.elementAt(i))}() as T;';
  }

  String modelCategoryEnumContentBase = '';
  String modelCategoryEnumContent = '';
  for (int i = 0; i < ModelCategory.values.length; i++) {
    modelCategoryEnumContentBase += '${ModelCategory.values[i].toString().replaceFirst('ModelCategory.', '')},';
  }
  modelCategoryEnumContent = 'enum ModelCategory {$modelCategoryEnumContentBase}';

  String modelCategorysContentBase = '';
  String modelCategorysContent = '';
  for (int i = 0; i < modelCategorys.keys.length; i++) {
    final String tableName = modelCategorys.keys.elementAt(i);
    final ModelCategory modelCategory = modelCategorys[tableName]!;
    modelCategorysContentBase += '\'${modelCategorys.keys.elementAt(i)}\':${modelCategory.toString()},';
  }
  modelCategorysContent = '<String,ModelCategory>{$modelCategorysContentBase}';

  return """
// ignore_for_file: non_constant_identifier_names
$importContent
import 'package:jysp/G/GSqlite/GSqlite.dart';
import 'package:sqflite/sqflite.dart';

$modelCategoryEnumContent

abstract class MBase {
  ///

  /// 值只有 int String bool null 类型，没有枚举类型（而是枚举的 int 值）
  Map<String, Object?> get getRowJson;

  // ====================================================================
  // ====================================================================

  /// 外键对应的 table 名称和 column 名称
  ///
  /// 不能被分成 _uuid 或 _aiid，因为有 虚主键 uuid 和 aiid
  ///
  /// [return]：null 或者 'table_name.column_name'
  String? getForeignKeyBelongsTos({required String foreignKeyName});

  /// 当删除当前 row 时，需要同时删除对应 row 的外键名
  ///
  /// xx_aiid 和 xx_uuid 合并成 xx
  ///
  /// 其外键的值需要自行再分解成 String 和 int
  ///
  /// eg. {'foreign_key_name1','foreign_key_name2',}
  Set<String> get getDeleteForeignKeyFollowCurrentForTwo;

  /// 当删除当前 row 时，需要同时删除对应 row 的外键名
  ///
  /// 其外键的值可能是 String 也可能是 int
  ///
  /// eg. {'foreign_key_name1','foreign_key_name2',}
  Set<String> get getDeleteForeignKeyFollowCurrentForSingle;

  // ====================================================================

  /// 被其他表的外键关联的 key（需要被约束删除的）
  ///
  /// 中间的 xx_aiid 和 xx_uuid 会合并成 xx
  ///
  /// 尾部的 aiid 和 uuid 会合并成 ''，xx_aiid 和 xx_uuid 会合并成 xx
  ///
  /// [return]：关联的 ['table_name1.column_name1.'(尾缀是 aiid 和 uuid),'table_name2.column_name2.yy'(尾缀是 xx_aiid 和 xx_uuid)]
  List<String> get getDeleteManyForeignKeyForTwo;

  /// 被其他表的外键关联的 key（需要被约束删除的）
  ///
  /// [return]：关联的 ['table_name.foreign_key_name.the_key']
  List<String> get getDeleteManyForeignKeyForSingle;

  // ====================================================================
  // ====================================================================

  String get getTableName;
  int? get get_id;
  int? get get_aiid;
  String? get get_uuid;
  int? get get_updated_at;
  int? get get_created_at;

  /// 使用 tableName 创建模型
  static T createEmptyModelByTableName<T extends MBase>(String tableName){
    switch(tableName){
      $createEmptyModelByTableNameContent
      default: throw 'unknown tableName: \$tableName';
    }
  }

  /// 若 [where]/[whereArgs] 为 null，则 query 的是全部 row。
  static Future<List<Map<String, Object?>>> queryRowsAsJsons({required String tableName, required String? where, required List<Object?>? whereArgs, required Transaction? connectTransaction}) async {
    if (connectTransaction != null) {
      return await connectTransaction.query(tableName, where: where, whereArgs: whereArgs);
    }
    return await db.query(tableName, where: where, whereArgs: whereArgs);
  }

  /// 若 [where]/[whereArgs] 为 null，则 query 的是全部 row。
  static Future<List<T>> queryRowsAsModels<T extends MBase>({required String tableName, required String? where, required List<Object?>? whereArgs, required Transaction? connectTransaction}) async {
    final List<Map<String, Object?>> rows = await queryRowsAsJsons(tableName: tableName, where: where, whereArgs: whereArgs, connectTransaction: connectTransaction);
    final List<T> rowModels = <T>[];
    for (final Map<String, Object?> row in rows) {
      final T newRowModel = createEmptyModelByTableName(tableName) as T;
      newRowModel.getRowJson.addAll(row);
      rowModels.add(newRowModel);
    }
    return rowModels;
  }


  /// 当前 Model 的类型
  static ModelCategory? modelCategory({required String tableName}){
    return $modelCategorysContent[tableName];
  }
}

""";
}
