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

  /// 参数除了 connectTransaction，其他的与 db.query 相同
  static Future<List<Map<String, Object?>>> queryRowsAsJsons({
    required Transaction? connectTransaction,
    required String tableName,
    bool? distinct,
    List<String>? columns,
    String? where,
    List<Object?>? whereArgs,
    String? groupBy,
    String? having,
    String? orderBy,
    int? limit,
    int? offset,
  }) async {
    if (connectTransaction != null) {
      return await connectTransaction.query(
        tableName,
        distinct: distinct,
        columns: columns,
        where: where,
        whereArgs: whereArgs,
        groupBy: groupBy,
        having: having,
        orderBy: orderBy,
        limit: limit,
        offset: offset,
      );
    }
    return await db.query(
      tableName,
      distinct: distinct,
      columns: columns,
      where: where,
      whereArgs: whereArgs,
      groupBy: groupBy,
      having: having,
      orderBy: orderBy,
      limit: limit,
      offset: offset,
    );
  }

  /// 参数除了 connectTransaction，其他的与 db.query 相同
  static Future<List<T>> queryRowsAsModels<T extends MBase>({
    required Transaction? connectTransaction,
    required String tableName,
    bool? distinct,
    List<String>? columns,
    String? where,
    List<Object?>? whereArgs,
    String? groupBy,
    String? having,
    String? orderBy,
    int? limit,
    int? offset,
  }) async {
    final List<Map<String, Object?>> rows = await queryRowsAsJsons(
      connectTransaction: connectTransaction,
      tableName: tableName,
      distinct: distinct,
      columns: columns,
      where: where,
      whereArgs: whereArgs,
      groupBy: groupBy,
      having: having,
      orderBy: orderBy,
      limit: limit,
      offset: offset,
    );
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

/// mmodel
String mmodelContent(String mmodelName, List<String> tableNames) {
  String importContent = '';
  String switchTypeContent = '';
  String object = '';
  String setValueContent = '';
  final Set<String> fieldKeysNotRespeat = <String>{};
  String getTableNameCallbackContent = '';
  String getRowJsonCallbackContent = '';
  for (int i = 0; i < tableNames.length; i++) {
    importContent += '''import 'package:jysp/Database/Models/M${toCamelCaseWillRemoveS(tableNames[i])}.dart';''';
    switchTypeContent += '''
      case M${toCamelCaseWillRemoveS(tableNames[i])}:
        m${toCamelCaseWillRemoveS(tableNames[i])} = model as M${toCamelCaseWillRemoveS(tableNames[i])};
      break;''';
    object += '''M${toCamelCaseWillRemoveS(tableNames[i])}? m${toCamelCaseWillRemoveS(tableNames[i])};''';
    setValueContent += '''
    if (m${toCamelCaseWillRemoveS(tableNames[i])} != null) {
      return values[$i]();
    }''';
    fieldKeysNotRespeat.addAll(modelFields[tableNames[i]]!.keys);
    getTableNameCallbackContent += '''() => m${toCamelCaseWillRemoveS(tableNames[i])}!.getTableName,''';
    getRowJsonCallbackContent += '''() => m${toCamelCaseWillRemoveS(tableNames[i])}!.getRowJson,''';
  }
  final String getTableNameContent = '''
  String get getTableName => setValue<String>(
      <String Function()>[
        $getTableNameCallbackContent
        ]);
  ''';

  final String getRowJsonContent = '''
  Map<String, Object?> get getRowJson => setValue<Map<String, Object?>>(
      <Map<String, Object?> Function()>[
        $getRowJsonCallbackContent
      ]);
  ''';

  String fieldKeysContent = '';
  String fieldValuesContent = '';
  for (int i = 0; i < fieldKeysNotRespeat.length; i++) {
    final Map<String, String?> tableNameAndFieldTypes = <String, String?>{};
    for (int tn = 0; tn < tableNames.length; tn++) {
      if (modelFields[tableNames[tn]]!.keys.contains(fieldKeysNotRespeat.elementAt(i))) {
        final String fieldType = modelFields[tableNames[tn]]![fieldKeysNotRespeat.elementAt(i)]!.last as String;
        tableNameAndFieldTypes.addAll(<String, String?>{tableNames[tn]: fieldType});
      } else {
        tableNameAndFieldTypes.addAll(<String, String?>{tableNames[tn]: null});
      }
    }

    String fieldKeysCallbackContent = '';
    for (int tn = 0; tn < tableNames.length; tn++) {
      if (modelFields[tableNames[tn]]!.keys.contains(fieldKeysNotRespeat.elementAt(i))) {
        fieldKeysCallbackContent += '''() => M${toCamelCaseWillRemoveS(tableNames[tn])}.${fieldKeysNotRespeat.elementAt(i)},''';
      } else {
        fieldKeysCallbackContent += '''argumentErr(),''';
      }
    }

    fieldKeysContent += '''
      String get ${fieldKeysNotRespeat.elementAt(i)} => setValue<String>(
        <String Function()>[
          $fieldKeysCallbackContent
          ]);''';

    final Set<String> fieldTypesNotRespeat = <String>{};
    for (int tnaft = 0; tnaft < tableNameAndFieldTypes.length; tnaft++) {
      final String? ft = tableNameAndFieldTypes.values.elementAt(tnaft);
      if (ft != null) {
        fieldTypesNotRespeat.add(ft);
      }
    }
    if (fieldTypesNotRespeat.length == 1) {
      String fieldValuesCallbackContent = '';
      for (int tn = 0; tn < tableNames.length; tn++) {
        if (modelFields[tableNames[tn]]!.keys.contains(fieldKeysNotRespeat.elementAt(i))) {
          fieldValuesCallbackContent += '''() => m${toCamelCaseWillRemoveS(tableNames[tn])}!.get_${fieldKeysNotRespeat.elementAt(i)},''';
        } else {
          fieldValuesCallbackContent += '''argumentErr(),''';
        }
      }
      fieldValuesContent += '''
      ${fieldTypesNotRespeat.first}? get get_${fieldKeysNotRespeat.elementAt(i)} => setValue<${fieldTypesNotRespeat.first}?>(
        <${fieldTypesNotRespeat.first}? Function()>[
          $fieldValuesCallbackContent
        ]);''';
    } else {
      for (int tnaft = 0; tnaft < tableNameAndFieldTypes.length; tnaft++) {
        if (tableNameAndFieldTypes.values.elementAt(tnaft) != null) {
          String fieldValuesCallbackContent = '';
          for (int tn = 0; tn < tableNames.length; tn++) {
            if (modelFields[tableNames[tn]]!.keys.contains(fieldKeysNotRespeat.elementAt(i))) {
              final String fieldType = modelFields[tableNames[tn]]![fieldKeysNotRespeat.elementAt(i)]!.last as String;
              if (fieldType == tableNameAndFieldTypes.values.elementAt(tnaft)) {
                fieldValuesCallbackContent += '''() => m${toCamelCaseWillRemoveS(tableNames[tn])}!.get_${fieldKeysNotRespeat.elementAt(i)},''';
              } else {
                fieldValuesCallbackContent += '''argumentErr(),''';
              }
            } else {
              fieldValuesCallbackContent += '''argumentErr(),''';
            }
          }
          fieldValuesContent += '''
      ${tableNameAndFieldTypes.values.elementAt(tnaft)}? get get_${fieldKeysNotRespeat.elementAt(i)}_${tableNameAndFieldTypes.keys.elementAt(tnaft)} => setValue<${tableNameAndFieldTypes.values.elementAt(tnaft)}?>(
        <${tableNameAndFieldTypes.values.elementAt(tnaft)}? Function()>[
          $fieldValuesCallbackContent
        ]);''';
        }
      }
    }
  }

  String getDeleteForeignKeyFollowCurrentForSingleContent = '';
  String getDeleteForeignKeyFollowCurrentForSingleCallbackContent = '';
  for (int tn = 0; tn < tableNames.length; tn++) {
    getDeleteForeignKeyFollowCurrentForSingleCallbackContent += '''() => m${toCamelCaseWillRemoveS(tableNames[tn])}!.getDeleteForeignKeyFollowCurrentForSingle,''';
  }
  getDeleteForeignKeyFollowCurrentForSingleContent += '''
  Set<String> get getDeleteForeignKeyFollowCurrentForSingle => setValue<Set<String>>(<Set<String> Function()>[
        $getDeleteForeignKeyFollowCurrentForSingleCallbackContent
      ]);
''';

  String getDeleteForeignKeyFollowCurrentForTwoContent = '';
  String getDeleteForeignKeyFollowCurrentForTwoCallbackContent = '';
  for (int tn = 0; tn < tableNames.length; tn++) {
    getDeleteForeignKeyFollowCurrentForTwoCallbackContent += '''() => m${toCamelCaseWillRemoveS(tableNames[tn])}!.getDeleteForeignKeyFollowCurrentForTwo,''';
  }
  getDeleteForeignKeyFollowCurrentForTwoContent += '''
  Set<String> get getDeleteForeignKeyFollowCurrentForTwo => setValue<Set<String>>(<Set<String> Function()>[
        $getDeleteForeignKeyFollowCurrentForTwoCallbackContent
      ]);
''';

  String getDeleteManyForeignKeyForSingleContent = '';
  String getDeleteManyForeignKeyForSingleCallbackContent = '';
  for (int tn = 0; tn < tableNames.length; tn++) {
    getDeleteManyForeignKeyForSingleCallbackContent += '''() => m${toCamelCaseWillRemoveS(tableNames[tn])}!.getDeleteManyForeignKeyForSingle,''';
  }
  getDeleteManyForeignKeyForSingleContent += '''
  List<String> get getDeleteManyForeignKeyForSingle => setValue<List<String>>(<List<String> Function()>[
        $getDeleteManyForeignKeyForSingleCallbackContent
      ]);
''';

  String getDeleteManyForeignKeyForTwoContent = '';
  String getDeleteManyForeignKeyForTwoCallbackContent = '';
  for (int tn = 0; tn < tableNames.length; tn++) {
    getDeleteManyForeignKeyForTwoCallbackContent += '''() => m${toCamelCaseWillRemoveS(tableNames[tn])}!.getDeleteManyForeignKeyForTwo,''';
  }
  getDeleteManyForeignKeyForTwoContent += '''
  List<String> get getDeleteManyForeignKeyForTwo => setValue<List<String>>(<List<String> Function()>[
        $getDeleteManyForeignKeyForTwoCallbackContent
      ]);
''';

  String getForeignKeyBelongsTosContent = '';
  String getForeignKeyBelongsTosCallbackContent = '';
  for (int tn = 0; tn < tableNames.length; tn++) {
    getForeignKeyBelongsTosCallbackContent += '''() => m${toCamelCaseWillRemoveS(tableNames[tn])}!.getForeignKeyBelongsTos(foreignKeyName: foreignKeyName),''';
  }
  getForeignKeyBelongsTosContent += '''
  String? getForeignKeyBelongsTos({required String foreignKeyName}) => setValue<String?>(<String? Function()>[
        $getForeignKeyBelongsTosCallbackContent
      ]);
''';

  String isGlobalEnumContent = '';
  bool isGlobalEnum = false;
  for (int tn = 0; tn < tableNames.length; tn++) {
    if (extraGlobalEnumContents[tableNames[tn]] == true) {
      isGlobalEnum = true;
    }
  }
  isGlobalEnumContent += isGlobalEnum == true ? 'import \'package:jysp/Database/Models/MGlobalEnum.dart\';' : '';

  return """
// ignore_for_file: non_constant_identifier_names
import 'package:jysp/Database/Models/MBase.dart';

$isGlobalEnumContent

$importContent

class $mmodelName {
  $mmodelName({required MBase model}) {
    switch (model.runtimeType) {
      $switchTypeContent
      default:
    }
  }

  $object

  /// [values] 必须严格按照 0-1 对应的模型顺序
  V setValue<V>(List<V Function()> values) {
    $setValueContent
    throw 'unknown model';
  }

  V Function() argumentErr<V>() {
    throw 'argument err';
  }

$getTableNameContent

$fieldKeysContent

$getRowJsonContent

$fieldValuesContent

$getDeleteForeignKeyFollowCurrentForSingleContent

$getDeleteForeignKeyFollowCurrentForTwoContent

$getDeleteManyForeignKeyForSingleContent

$getDeleteManyForeignKeyForTwoContent

$getForeignKeyBelongsTosContent

}
""";
}
