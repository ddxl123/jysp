// ignore_for_file: non_constant_identifier_names
import 'package:jysp/Database/Models/MVersionInfo.dart';import 'package:jysp/Database/Models/MToken.dart';import 'package:jysp/Database/Models/MUser.dart';import 'package:jysp/Database/Models/MUpload.dart';import 'package:jysp/Database/Models/MDownloadModule.dart';import 'package:jysp/Database/Models/MPnPendingPoolNode.dart';import 'package:jysp/Database/Models/MPnMemoryPoolNode.dart';import 'package:jysp/Database/Models/MPnCompletePoolNode.dart';import 'package:jysp/Database/Models/MPnRulePoolNode.dart';import 'package:jysp/Database/Models/MFragmentsAboutPendingPoolNode.dart';import 'package:jysp/Database/Models/MFragmentsAboutMemoryPoolNode.dart';import 'package:jysp/Database/Models/MFragmentsAboutCompletePoolNode.dart';import 'package:jysp/Database/Models/MRule.dart';

abstract class MBase {
  ///

  /// 值只有 int String bool null 类型，没有枚举类型（而是枚举的 int 值）
  Map<String, Object?> get getRowJson;

  /// 外键对应的表。key: 外键名；value: 对应的表名
  String? getForeignKeyTableNames({required String foreignKeyName});

  /// 当删除当前 row 时，需要同时删除对应 row 的外键名
  ///
  /// 总是 xx_aiid 和 xx_uuid 合并成 xx
  Set<String> get getDeleteChildFollowFatherKeysForTwo;

  /// 当删除当前 row 时，需要同时删除对应 row 的外键名
  ///
  /// 总是 xx_id
  Set<String> get getDeleteChildFollowFatherKeysForSingle;

  /// 当删除外键时，需要同时删除当前 row 的外键名
  List<String> get getDeleteFatherFollowChildKeys;

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
        return await MVersionInfo.queryRowsAsModels(where: where, whereArgs: whereArgs);        case 'tokens':
        return await MToken.queryRowsAsModels(where: where, whereArgs: whereArgs);        case 'users':
        return await MUser.queryRowsAsModels(where: where, whereArgs: whereArgs);        case 'uploads':
        return await MUpload.queryRowsAsModels(where: where, whereArgs: whereArgs);        case 'download_modules':
        return await MDownloadModule.queryRowsAsModels(where: where, whereArgs: whereArgs);        case 'pn_pending_pool_nodes':
        return await MPnPendingPoolNode.queryRowsAsModels(where: where, whereArgs: whereArgs);        case 'pn_memory_pool_nodes':
        return await MPnMemoryPoolNode.queryRowsAsModels(where: where, whereArgs: whereArgs);        case 'pn_complete_pool_nodes':
        return await MPnCompletePoolNode.queryRowsAsModels(where: where, whereArgs: whereArgs);        case 'pn_rule_pool_nodes':
        return await MPnRulePoolNode.queryRowsAsModels(where: where, whereArgs: whereArgs);        case 'fragments_about_pending_pool_nodes':
        return await MFragmentsAboutPendingPoolNode.queryRowsAsModels(where: where, whereArgs: whereArgs);        case 'fragments_about_memory_pool_nodes':
        return await MFragmentsAboutMemoryPoolNode.queryRowsAsModels(where: where, whereArgs: whereArgs);        case 'fragments_about_complete_pool_nodes':
        return await MFragmentsAboutCompletePoolNode.queryRowsAsModels(where: where, whereArgs: whereArgs);        case 'rules':
        return await MRule.queryRowsAsModels(where: where, whereArgs: whereArgs);
      default:
        throw 'tableName is unknown';
    }
  }

  /// 若 [where]/[whereArgs] 为 null，则 query 的是全部 row。
  static Future<List<Map<String, Object?>>> queryByTableNameAsJsons({required String tableName, String? where, List<Object?>? whereArgs}) async {
    switch (tableName) {
              case 'version_infos':
        return await MVersionInfo.queryRowsAsJsons(where: where, whereArgs: whereArgs);        case 'tokens':
        return await MToken.queryRowsAsJsons(where: where, whereArgs: whereArgs);        case 'users':
        return await MUser.queryRowsAsJsons(where: where, whereArgs: whereArgs);        case 'uploads':
        return await MUpload.queryRowsAsJsons(where: where, whereArgs: whereArgs);        case 'download_modules':
        return await MDownloadModule.queryRowsAsJsons(where: where, whereArgs: whereArgs);        case 'pn_pending_pool_nodes':
        return await MPnPendingPoolNode.queryRowsAsJsons(where: where, whereArgs: whereArgs);        case 'pn_memory_pool_nodes':
        return await MPnMemoryPoolNode.queryRowsAsJsons(where: where, whereArgs: whereArgs);        case 'pn_complete_pool_nodes':
        return await MPnCompletePoolNode.queryRowsAsJsons(where: where, whereArgs: whereArgs);        case 'pn_rule_pool_nodes':
        return await MPnRulePoolNode.queryRowsAsJsons(where: where, whereArgs: whereArgs);        case 'fragments_about_pending_pool_nodes':
        return await MFragmentsAboutPendingPoolNode.queryRowsAsJsons(where: where, whereArgs: whereArgs);        case 'fragments_about_memory_pool_nodes':
        return await MFragmentsAboutMemoryPoolNode.queryRowsAsJsons(where: where, whereArgs: whereArgs);        case 'fragments_about_complete_pool_nodes':
        return await MFragmentsAboutCompletePoolNode.queryRowsAsJsons(where: where, whereArgs: whereArgs);        case 'rules':
        return await MRule.queryRowsAsJsons(where: where, whereArgs: whereArgs);
      default:
        throw 'tableName is unknown';
    }
  }

  ///
}

  