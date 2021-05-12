// ignore_for_file: non_constant_identifier_names
import 'package:jysp/Database/Models/MVersionInfo.dart';
import 'package:jysp/Database/Models/MToken.dart';
import 'package:jysp/Database/Models/MUser.dart';
import 'package:jysp/Database/Models/MUpload.dart';
import 'package:jysp/Database/Models/MDownloadModule.dart';
import 'package:jysp/Database/Models/MPnPendingPoolNode.dart';
import 'package:jysp/Database/Models/MPnMemoryPoolNode.dart';
import 'package:jysp/Database/Models/MPnCompletePoolNode.dart';
import 'package:jysp/Database/Models/MPnRulePoolNode.dart';
import 'package:jysp/Database/Models/MFragmentsAboutPendingPoolNode.dart';
import 'package:jysp/Database/Models/MFragmentsAboutMemoryPoolNode.dart';
import 'package:jysp/Database/Models/MFragmentsAboutCompletePoolNode.dart';
import 'package:jysp/Database/Models/MRule.dart';

enum ModelCategory {
  onlySqlite,
  SqliteAndMysql,
}

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

  String get getCurrentTableName;
  int? get get_id;
  int? get get_aiid;
  String? get get_uuid;
  int? get get_updated_at;
  int? get get_created_at;

  /// 若 [where]/[whereArgs] 为 null，则 query 的是全部 row。
  static Future<List<MBase>> queryByTableNameAsModels({required String tableName, String? where, List<Object?>? whereArgs}) async {
    switch (tableName) {
      case 'version_infos':
        return await MVersionInfo.queryRowsAsModels(where: where, whereArgs: whereArgs);
      case 'tokens':
        return await MToken.queryRowsAsModels(where: where, whereArgs: whereArgs);
      case 'users':
        return await MUser.queryRowsAsModels(where: where, whereArgs: whereArgs);
      case 'uploads':
        return await MUpload.queryRowsAsModels(where: where, whereArgs: whereArgs);
      case 'download_modules':
        return await MDownloadModule.queryRowsAsModels(where: where, whereArgs: whereArgs);
      case 'pn_pending_pool_nodes':
        return await MPnPendingPoolNode.queryRowsAsModels(where: where, whereArgs: whereArgs);
      case 'pn_memory_pool_nodes':
        return await MPnMemoryPoolNode.queryRowsAsModels(where: where, whereArgs: whereArgs);
      case 'pn_complete_pool_nodes':
        return await MPnCompletePoolNode.queryRowsAsModels(where: where, whereArgs: whereArgs);
      case 'pn_rule_pool_nodes':
        return await MPnRulePoolNode.queryRowsAsModels(where: where, whereArgs: whereArgs);
      case 'fragments_about_pending_pool_nodes':
        return await MFragmentsAboutPendingPoolNode.queryRowsAsModels(where: where, whereArgs: whereArgs);
      case 'fragments_about_memory_pool_nodes':
        return await MFragmentsAboutMemoryPoolNode.queryRowsAsModels(where: where, whereArgs: whereArgs);
      case 'fragments_about_complete_pool_nodes':
        return await MFragmentsAboutCompletePoolNode.queryRowsAsModels(where: where, whereArgs: whereArgs);
      case 'rules':
        return await MRule.queryRowsAsModels(where: where, whereArgs: whereArgs);
      default:
        throw 'tableName is unknown';
    }
  }

  /// 若 [where]/[whereArgs] 为 null，则 query 的是全部 row。
  static Future<List<Map<String, Object?>>> queryByTableNameAsJsons({required String tableName, String? where, List<Object?>? whereArgs}) async {
    switch (tableName) {
      case 'version_infos':
        return await MVersionInfo.queryRowsAsJsons(where: where, whereArgs: whereArgs);
      case 'tokens':
        return await MToken.queryRowsAsJsons(where: where, whereArgs: whereArgs);
      case 'users':
        return await MUser.queryRowsAsJsons(where: where, whereArgs: whereArgs);
      case 'uploads':
        return await MUpload.queryRowsAsJsons(where: where, whereArgs: whereArgs);
      case 'download_modules':
        return await MDownloadModule.queryRowsAsJsons(where: where, whereArgs: whereArgs);
      case 'pn_pending_pool_nodes':
        return await MPnPendingPoolNode.queryRowsAsJsons(where: where, whereArgs: whereArgs);
      case 'pn_memory_pool_nodes':
        return await MPnMemoryPoolNode.queryRowsAsJsons(where: where, whereArgs: whereArgs);
      case 'pn_complete_pool_nodes':
        return await MPnCompletePoolNode.queryRowsAsJsons(where: where, whereArgs: whereArgs);
      case 'pn_rule_pool_nodes':
        return await MPnRulePoolNode.queryRowsAsJsons(where: where, whereArgs: whereArgs);
      case 'fragments_about_pending_pool_nodes':
        return await MFragmentsAboutPendingPoolNode.queryRowsAsJsons(where: where, whereArgs: whereArgs);
      case 'fragments_about_memory_pool_nodes':
        return await MFragmentsAboutMemoryPoolNode.queryRowsAsJsons(where: where, whereArgs: whereArgs);
      case 'fragments_about_complete_pool_nodes':
        return await MFragmentsAboutCompletePoolNode.queryRowsAsJsons(where: where, whereArgs: whereArgs);
      case 'rules':
        return await MRule.queryRowsAsJsons(where: where, whereArgs: whereArgs);
      default:
        throw 'tableName is unknown';
    }
  }

  /// 当前 Model 的类型
  static ModelCategory? modelCategory({required String tableName}) {
    return <String, ModelCategory>{
      'version_infos': ModelCategory.onlySqlite,
      'tokens': ModelCategory.onlySqlite,
      'users': ModelCategory.SqliteAndMysql,
      'uploads': ModelCategory.onlySqlite,
      'download_modules': ModelCategory.onlySqlite,
      'pn_pending_pool_nodes': ModelCategory.SqliteAndMysql,
      'pn_memory_pool_nodes': ModelCategory.SqliteAndMysql,
      'pn_complete_pool_nodes': ModelCategory.SqliteAndMysql,
      'pn_rule_pool_nodes': ModelCategory.SqliteAndMysql,
      'fragments_about_pending_pool_nodes': ModelCategory.SqliteAndMysql,
      'fragments_about_memory_pool_nodes': ModelCategory.SqliteAndMysql,
      'fragments_about_complete_pool_nodes': ModelCategory.SqliteAndMysql,
      'rules': ModelCategory.SqliteAndMysql,
    }[tableName];
  }
}
