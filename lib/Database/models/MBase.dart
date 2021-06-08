// ignore_for_file: non_constant_identifier_names
import 'package:jysp/database/merge_models/MMBase.dart';
import 'package:jysp/database/models/MVersionInfo.dart';import 'package:jysp/database/models/MToken.dart';import 'package:jysp/database/models/MUser.dart';import 'package:jysp/database/models/MUpload.dart';import 'package:jysp/database/models/MDownloadModule.dart';import 'package:jysp/database/models/MPnPendingPoolNode.dart';import 'package:jysp/database/models/MPnMemoryPoolNode.dart';import 'package:jysp/database/models/MPnCompletePoolNode.dart';import 'package:jysp/database/models/MPnRulePoolNode.dart';import 'package:jysp/database/models/MFragmentsAboutPendingPoolNode.dart';import 'package:jysp/database/models/MFragmentsAboutMemoryPoolNode.dart';import 'package:jysp/database/models/MFragmentsAboutCompletePoolNode.dart';import 'package:jysp/database/models/MFragmentsAboutRulePoolNode.dart';
import 'package:jysp/database/g_sqlite/GSqlite.dart';
import 'package:sqflite/sqflite.dart';

enum ModelCategory {onlySqlite,SqliteAndMysql,}

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
      case 'version_infos': return MVersionInfo() as T;case 'tokens': return MToken() as T;case 'users': return MUser() as T;case 'uploads': return MUpload() as T;case 'download_modules': return MDownloadModule() as T;case 'pn_pending_pool_nodes': return MPnPendingPoolNode() as T;case 'pn_memory_pool_nodes': return MPnMemoryPoolNode() as T;case 'pn_complete_pool_nodes': return MPnCompletePoolNode() as T;case 'pn_rule_pool_nodes': return MPnRulePoolNode() as T;case 'fragments_about_pending_pool_nodes': return MFragmentsAboutPendingPoolNode() as T;case 'fragments_about_memory_pool_nodes': return MFragmentsAboutMemoryPoolNode() as T;case 'fragments_about_complete_pool_nodes': return MFragmentsAboutCompletePoolNode() as T;case 'fragments_about_rule_pool_nodes': return MFragmentsAboutRulePoolNode() as T;
      default: throw 'unknown tableName: $tableName';
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

  /// [M]：MBase 类型
  ///
  /// [MM]：MMBase 类型
  ///
  /// [R]：要返回的元素类型，[M] 与 [MM] 二选一
  ///
  /// [returnMWhere]: 对每个 model 进行操作, 并返回 models
  ///
  /// [returnMMWhere]：对每个 model 进行操作, 并将 Model 类型元素转换成 MModel 类型元素进行返回
  ///
  /// [returnMWhere] 与 [returnMMWhere] 不能同时为 null，且不能同时不为 null
  static Future<List<R>> queryRowsAsModels<M extends MBase, MM extends MMBase, R>({
    required Transaction? connectTransaction,
    required M Function(M model)? returnMWhere,
    required MM Function(M model)? returnMMWhere,
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
    if (R.runtimeType != M.runtimeType && R.runtimeType != MM.runtimeType){
      throw 'R type is not M or MM';
    }
    if (returnMWhere == null && returnMMWhere == null || returnMWhere != null && returnMMWhere != null)
    {
      throw 'returnMWhere and returnMMWhere err';
    }

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

    if (returnMWhere != null) {
      final List<M> rowModels = <M>[];
      for (final Map<String, Object?> row in rows) {
        final M newRowModel = createEmptyModelByTableName(tableName) as M;
        newRowModel.getRowJson.addAll(row);
        rowModels.add(newRowModel);
        returnMWhere(newRowModel);
      }
      return rowModels as List<R>;
    }

    if (returnMMWhere != null) {
      final List<MM> rowMModels = <MM>[];
      for (final Map<String, Object?> row in rows) {
        final M newRowModel = createEmptyModelByTableName(tableName) as M;
        newRowModel.getRowJson.addAll(row);
        final MM mm = returnMMWhere(newRowModel);
        rowMModels.add(mm);
      }
      return rowMModels as List<R>;
    }

    throw 'unknown return';
  }

  /// 当前 Model 的类型
  static ModelCategory? modelCategory({required String tableName}){
    return <String, ModelCategory>{ 'version_infos':ModelCategory.onlySqlite,'tokens':ModelCategory.onlySqlite,'users':ModelCategory.SqliteAndMysql,'uploads':ModelCategory.onlySqlite,'download_modules':ModelCategory.onlySqlite,'pn_pending_pool_nodes':ModelCategory.SqliteAndMysql,'pn_memory_pool_nodes':ModelCategory.SqliteAndMysql,'pn_complete_pool_nodes':ModelCategory.SqliteAndMysql,'pn_rule_pool_nodes':ModelCategory.SqliteAndMysql,'fragments_about_pending_pool_nodes':ModelCategory.SqliteAndMysql,'fragments_about_memory_pool_nodes':ModelCategory.SqliteAndMysql,'fragments_about_complete_pool_nodes':ModelCategory.SqliteAndMysql,'fragments_about_rule_pool_nodes':ModelCategory.SqliteAndMysql, }[tableName];
  }
}

