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
      case 'version_infos':
        return await MVersionInfo.queryRowsAsModels(byId);
      case 'tokens':
        return await MToken.queryRowsAsModels(byId);
      case 'users':
        return await MUser.queryRowsAsModels(byId);
      case 'uploads':
        return await MUpload.queryRowsAsModels(byId);
      case 'download_modules':
        return await MDownloadModule.queryRowsAsModels(byId);
      case 'pn_pending_pool_nodes':
        return await MPnPendingPoolNode.queryRowsAsModels(byId);
      case 'pn_memory_pool_nodes':
        return await MPnMemoryPoolNode.queryRowsAsModels(byId);
      case 'pn_complete_pool_nodes':
        return await MPnCompletePoolNode.queryRowsAsModels(byId);
      case 'pn_rule_pool_nodes':
        return await MPnRulePoolNode.queryRowsAsModels(byId);
      case 'fragments_about_pending_pool_nodes':
        return await MFragmentsAboutPendingPoolNode.queryRowsAsModels(byId);
      case 'fragments_about_memory_pool_nodes':
        return await MFragmentsAboutMemoryPoolNode.queryRowsAsModels(byId);
      case 'fragments_about_complete_pool_nodes':
        return await MFragmentsAboutCompletePoolNode.queryRowsAsModels(byId);
      case 'rules':
        return await MRule.queryRowsAsModels(byId);
      default:
        throw 'tableName is unknown';
    }
  }

  /// 若 [byId] 为 null，则 query 的是全部 row。
  static Future<List<Map<String, Object?>>> queryByTableNameAsJsons(String tableName, [int? byId]) async {
    switch (tableName) {
      case 'version_infos':
        return await MVersionInfo.queryRowsAsJsons(byId);
      case 'tokens':
        return await MToken.queryRowsAsJsons(byId);
      case 'users':
        return await MUser.queryRowsAsJsons(byId);
      case 'uploads':
        return await MUpload.queryRowsAsJsons(byId);
      case 'download_modules':
        return await MDownloadModule.queryRowsAsJsons(byId);
      case 'pn_pending_pool_nodes':
        return await MPnPendingPoolNode.queryRowsAsJsons(byId);
      case 'pn_memory_pool_nodes':
        return await MPnMemoryPoolNode.queryRowsAsJsons(byId);
      case 'pn_complete_pool_nodes':
        return await MPnCompletePoolNode.queryRowsAsJsons(byId);
      case 'pn_rule_pool_nodes':
        return await MPnRulePoolNode.queryRowsAsJsons(byId);
      case 'fragments_about_pending_pool_nodes':
        return await MFragmentsAboutPendingPoolNode.queryRowsAsJsons(byId);
      case 'fragments_about_memory_pool_nodes':
        return await MFragmentsAboutMemoryPoolNode.queryRowsAsJsons(byId);
      case 'fragments_about_complete_pool_nodes':
        return await MFragmentsAboutCompletePoolNode.queryRowsAsJsons(byId);
      case 'rules':
        return await MRule.queryRowsAsJsons(byId);
      default:
        throw 'tableName is unknown';
    }
  }

  ///
}
