import 'package:jysp/Database/Models/MFragmentsAboutCompletePoolNode.dart';
import 'package:jysp/Database/Models/MFragmentsAboutMemoryPoolNode.dart';
import 'package:jysp/Database/Models/MFragmentsAboutPendingPoolNode.dart';
import 'package:jysp/Database/Models/MPnCompletePoolNode.dart';
import 'package:jysp/Database/Models/MPnMemoryPoolNode.dart';
import 'package:jysp/Database/Models/MPnPendingPoolNode.dart';
import 'package:jysp/Database/Models/MPnRulePoolNode.dart';
import 'package:jysp/Database/Models/MRule.dart';
import 'package:jysp/Database/Models/MUser.dart';
import 'package:jysp/G/GHttp/GHttp.dart';
import 'package:jysp/G/GSqlite/GSqlite.dart';
import 'package:jysp/MVC/Views/InitDownloadPage/Extension.dart';
import 'package:jysp/Tools/TDebug.dart';

class RInitDownload {
  ///

  String getUserInfoRoute = 'api/init_download/get_user_info';
  String getPendingPoolNodesRoute = 'api/init_download/get_pending_pool_nodes';
  String getMemoryPoolNodesRoute = 'api/init_download/get_memory_pool_nodes';
  String getCompletePoolNodesRoute = 'api/init_download/get_complete_pool_nodes';
  String getRulePoolNodesRoute = 'api/init_download/get_rule_pool_nodes';
  String getPendingPoolNodeFragmentRoute = 'api/init_download/get_pending_pool_node_fragments';
  String getMemoryPoolNodeFragmentRoute = 'api/init_download/get_memory_pool_node_fragments';
  String getCompletePoolNodeFragmentRoute = 'api/init_download/get_complete_pool_node_fragments';
  String getRulePoolNodeFragmentRoute = 'api/init_download/get_rule_pool_node_fragments';

  /// 获取用户信息
  Future<GetDataResultType> getUserInfo() async {
    GetDataResultType getDataResultType = GetDataResultType.fail;
    // TODO: api/init_download/get_user_info
    await GHttp.sendRequest<Map<String, dynamic>>(
      method: 'GET',
      route: getUserInfoRoute,
      isAuth: true,
      resultCallback: (int code, Map<String, dynamic> data) async {
        switch (code) {
          case 300:
            await db.delete(MUser.getTableName);
            await db.insert(
              MUser.getTableName,
              MUser.asJsonNoId(
                atid_v: data['id'] as int?,
                uuid_v: null,
                username_v: data[MUser.username] as String?,
                email_v: data[MUser.email] as String?,
                created_at_v: data[MUser.created_at] as int?,
                updated_at_v: data[MUser.updated_at] as int?,
              ),
            );
            dLog(() => 'getUserInfo:', null, () async => await db.query(MUser.getTableName));
            getDataResultType = GetDataResultType.ok;
            break;
          default:
            throw 'code is unknown';
        }
      },
      interruptedCallback: (_) {
        dLog(() => _);
        getDataResultType = GetDataResultType.fail;
      },
      sameNotConcurrent: 'getUserInfo',
    );
    return getDataResultType;
  }

  /// 获取待定池节点
  Future<GetDataResultType> getPendingPoolNodes() async {
    GetDataResultType getDataResultType = GetDataResultType.fail;
    // TODO: GET api/init_download/get_pending_pool_nodes
    await GHttp.sendRequest<List<Map<String, dynamic>>>(
      method: 'GET',
      route: getPendingPoolNodesRoute,
      isAuth: true,
      resultCallback: (int code, List<Map<String, dynamic>> data) async {
        switch (code) {
          case 302:
            await db.delete(MPnPendingPoolNode.getTableName);

            await Future.forEach<Map<String, dynamic>>(
              data,
              (Map<String, dynamic> element) async {
                await db.insert(
                  MPnPendingPoolNode.getTableName,
                  MPnPendingPoolNode.asJsonNoId(
                    atid_v: element['id'] as int?,
                    uuid_v: null,
                    recommend_raw_rule_atid_v: element[MPnPendingPoolNode.recommend_raw_rule_atid] as int?,
                    recommend_raw_rule_uuid_v: null,
                    type_v: element[MPnPendingPoolNode.type] == null ? null : PendingPoolNodeType.values[element[MPnPendingPoolNode.type] as int],
                    name_v: element[MPnPendingPoolNode.name] as String?,
                    position_v: element[MPnPendingPoolNode.position] as String?,
                    created_at_v: element[MPnPendingPoolNode.created_at] as int?,
                    updated_at_v: element[MPnPendingPoolNode.updated_at] as int?,
                  ),
                );
              },
            );

            dLog(() => 'getPendingPoolNodes:', null, () async => await db.query(MPnPendingPoolNode.getTableName));
            getDataResultType = GetDataResultType.ok;
            break;
          default:
            throw 'unknown code: $code';
        }
      },
      interruptedCallback: (_) {
        dLog(() => _);
        getDataResultType = GetDataResultType.fail;
      },
      sameNotConcurrent: 'getPendingPoolNodes',
    );
    return getDataResultType;
  }

  /// 获取记忆池节点
  Future<GetDataResultType> getMemoryPoolNodes() async {
    GetDataResultType getDataResultType = GetDataResultType.fail;
    // TODO: GET api/init_download/get_memory_pool_nodes
    await GHttp.sendRequest<List<Map<String, dynamic>>>(
      method: 'GET',
      route: getMemoryPoolNodesRoute,
      isAuth: true,
      resultCallback: (int code, List<Map<String, dynamic>> data) async {
        switch (code) {
          case 304:
            await db.delete(MPnMemoryPoolNode.getTableName);

            await Future.forEach<Map<String, dynamic>>(
              data,
              (Map<String, dynamic> element) async {
                await db.insert(
                  MPnMemoryPoolNode.getTableName,
                  MPnMemoryPoolNode.asJsonNoId(
                    atid_v: element['id'] as int?,
                    uuid_v: null,
                    using_raw_rule_atid_v: element[MPnMemoryPoolNode.using_raw_rule_atid] as int?,
                    using_raw_rule_uuid_v: null,
                    type_v: element[MPnMemoryPoolNode.type] == null ? null : MemoryPoolNodeType.values[element[MPnMemoryPoolNode.type] as int],
                    name_v: element[MPnMemoryPoolNode.name] as String?,
                    position_v: element[MPnMemoryPoolNode.position] as String?,
                    created_at_v: element[MPnMemoryPoolNode.created_at] as int?,
                    updated_at_v: element[MPnMemoryPoolNode.updated_at] as int?,
                  ),
                );
              },
            );

            dLog(() => 'getMemoryPoolNodes:', null, () async => await db.query(MPnMemoryPoolNode.getTableName));
            getDataResultType = GetDataResultType.ok;
            break;
          default:
            throw 'unknown code: $code';
        }
      },
      sameNotConcurrent: 'getMemoryPoolNodes',
      interruptedCallback: (_) {
        dLog(() => _);
        getDataResultType = GetDataResultType.fail;
      },
    );
    return getDataResultType;
  }

  /// 获取完成池节点
  Future<GetDataResultType> getCompletePoolNodes() async {
    GetDataResultType getDataResultType = GetDataResultType.fail;
    // TODO: GET api/init_download/get_complete_pool_nodes
    await GHttp.sendRequest<List<Map<String, dynamic>>>(
      method: 'GET',
      route: getCompletePoolNodesRoute,
      isAuth: true,
      resultCallback: (int code, List<Map<String, dynamic>> data) async {
        switch (code) {
          case 306:
            await db.delete(MPnCompletePoolNode.getTableName);

            await Future.forEach<Map<String, dynamic>>(
              data,
              (Map<String, dynamic> element) async {
                await db.insert(
                  MPnCompletePoolNode.getTableName,
                  MPnCompletePoolNode.asJsonNoId(
                    atid_v: element['id'] as int?,
                    uuid_v: null,
                    used_raw_rule_atid_v: element[MPnCompletePoolNode.used_raw_rule_atid] as int?,
                    used_raw_rule_uuid_v: null,
                    type_v: element[MPnCompletePoolNode.type] == null ? null : CompletePoolNodeType.values[element[MPnCompletePoolNode.type] as int],
                    name_v: element[MPnCompletePoolNode.name] as String?,
                    position_v: element[MPnCompletePoolNode.position] as String?,
                    created_at_v: element[MPnCompletePoolNode.created_at] as int?,
                    updated_at_v: element[MPnCompletePoolNode.updated_at] as int?,
                  ),
                );
              },
            );

            dLog(() => 'getCompletePoolNodes:', null, () async => await db.query(MPnCompletePoolNode.getTableName));
            getDataResultType = GetDataResultType.ok;
            break;
          default:
            throw 'unknown code: $code';
        }
      },
      sameNotConcurrent: 'getCompletePoolNodes',
      interruptedCallback: (_) {
        dLog(() => _);
        getDataResultType = GetDataResultType.fail;
      },
    );
    return getDataResultType;
  }

  /// 获取规则池节点
  Future<GetDataResultType> getRulePoolNodes() async {
    GetDataResultType getDataResultType = GetDataResultType.fail;
    // TODO: GET api/init_download/get_rule_pool_nodes
    await GHttp.sendRequest<List<Map<String, dynamic>>>(
      method: 'GET',
      route: getRulePoolNodesRoute,
      isAuth: true,
      resultCallback: (int code, List<Map<String, dynamic>> data) async {
        switch (code) {
          case 308:
            await db.delete(MPnRulePoolNode.getTableName);

            await Future.forEach<Map<String, dynamic>>(
              data,
              (Map<String, dynamic> element) async {
                await db.insert(
                  MPnRulePoolNode.getTableName,
                  MPnRulePoolNode.asJsonNoId(
                    atid_v: element['id'] as int?,
                    uuid_v: null,
                    type_v: element[MPnRulePoolNode.type] == null ? null : RulePoolNodeType.values[element[MPnRulePoolNode.type] as int],
                    name_v: element[MPnRulePoolNode.name] as String?,
                    position_v: element[MPnRulePoolNode.position] as String?,
                    created_at_v: element[MPnRulePoolNode.created_at] as int?,
                    updated_at_v: element[MPnRulePoolNode.updated_at] as int?,
                  ),
                );
              },
            );

            dLog(() => 'getRulePoolNodes:', null, () async => await db.query(MPnRulePoolNode.getTableName));
            getDataResultType = GetDataResultType.ok;
            break;
          default:
            throw 'unknown code: $code';
        }
      },
      sameNotConcurrent: 'getRulePoolNodes',
      interruptedCallback: (_) {
        dLog(() => _);
        getDataResultType = GetDataResultType.fail;
      },
    );
    return getDataResultType;
  }

  /// 获取待定池节点的全部碎片
  Future<GetDataResultType> getPendingPoolNodeFragments() async {
    GetDataResultType getDataResultType = GetDataResultType.fail;
    // TODO: GET api/init_download/get_pending_pool_node_fragments
    await GHttp.sendRequest<List<Map<String, dynamic>>>(
      method: 'GET',
      route: getPendingPoolNodeFragmentRoute,
      isAuth: true,
      resultCallback: (int code, List<Map<String, dynamic>> data) async {
        switch (code) {
          case 310:
            await db.delete(MFragmentsAboutPendingPoolNode.getTableName);

            await Future.forEach<Map<String, dynamic>>(
              data,
              (Map<String, dynamic> element) async {
                await db.insert(
                  MFragmentsAboutPendingPoolNode.getTableName,
                  MFragmentsAboutPendingPoolNode.asJsonNoId(
                    atid_v: element['id'] as int?,
                    uuid_v: null,
                    raw_fragment_atid_v: element['belongs_to_raw_fragment'] == null ? null : element['belongs_to_raw_fragment']['id'] as int?,
                    raw_fragment_uuid_v: null,
                    pn_pending_pool_node_atid_v: element[MFragmentsAboutPendingPoolNode.pn_pending_pool_node_atid] as int?,
                    pn_pending_pool_node_uuid_v: null,
                    recommend_raw_rule_atid_v: element[MFragmentsAboutPendingPoolNode.recommend_raw_rule_atid] as int?,
                    recommend_raw_rule_uuid_v: null,
                    title_v: element['belongs_to_raw_fragment'] == null ? null : element['belongs_to_raw_fragment']['title'] as String?,
                    created_at_v: element[MFragmentsAboutPendingPoolNode.created_at] as int?,
                    updated_at_v: element[MFragmentsAboutPendingPoolNode.updated_at] as int?,
                  ),
                );
              },
            );
            dLog(() => 'getPendingPoolNodeFragments:', null, () async => await db.query(MFragmentsAboutPendingPoolNode.getTableName));
            getDataResultType = GetDataResultType.ok;
            break;
          default:
            throw 'unknown code: $code';
        }
      },
      sameNotConcurrent: 'getPendingPoolNodeFragments',
      interruptedCallback: (_) {
        dLog(() => _);
        getDataResultType = GetDataResultType.fail;
      },
    );
    return getDataResultType;
  }

  /// 获取记忆池节点的全部碎片
  Future<GetDataResultType> getMemoryPoolNodeFragments() async {
    GetDataResultType getDataResultType = GetDataResultType.fail;
    // TODO: GET api/init_download/get_memory_pool_node_fragments
    await GHttp.sendRequest<List<Map<String, dynamic>>>(
      method: 'GET',
      route: getMemoryPoolNodeFragmentRoute,
      isAuth: true,
      resultCallback: (int code, List<Map<String, dynamic>> data) async {
        switch (code) {
          case 312:
            await db.delete(MFragmentsAboutMemoryPoolNode.getTableName);

            await Future.forEach<Map<String, dynamic>>(
              data,
              (Map<String, dynamic> element) async {
                await db.insert(
                  MFragmentsAboutMemoryPoolNode.getTableName,
                  MFragmentsAboutMemoryPoolNode.asJsonNoId(
                    atid_v: element['id'] as int?,
                    uuid_v: null,
                    fragments_about_pending_pool_node_atid_v: element['fragment_owner_about_pending_pool_node_id'] as int?,
                    fragments_about_pending_pool_node_uuid_v: null,
                    using_raw_rule_atid_v: element[MFragmentsAboutMemoryPoolNode.using_raw_rule_atid] as int?,
                    using_raw_rule_uuid_v: null,
                    pn_memory_pool_node_atid_v: element[MFragmentsAboutMemoryPoolNode.pn_memory_pool_node_atid] as int?,
                    pn_memory_pool_node_uuid_v: null,
                    created_at_v: element[MFragmentsAboutMemoryPoolNode.created_at] as int?,
                    updated_at_v: element[MFragmentsAboutMemoryPoolNode.updated_at] as int?,
                  ),
                );
              },
            );
            dLog(() => 'getMemoryPoolNodeFragments:', null, () async => await db.query(MFragmentsAboutMemoryPoolNode.getTableName));
            getDataResultType = GetDataResultType.ok;
            break;
          default:
            throw 'unknown code: $code';
        }
        getDataResultType = GetDataResultType.ok;
      },
      sameNotConcurrent: 'getMemoryPoolNodeFragments',
      interruptedCallback: (_) {
        dLog(() => _);
        getDataResultType = GetDataResultType.fail;
      },
    );
    return getDataResultType;
  }

  /// 获取完成池节点的全部碎片
  Future<GetDataResultType> getCompletePoolNodeFragments() async {
    GetDataResultType getDataResultType = GetDataResultType.fail;
    // TODO: GET api/init_download/get_complete_pool_node_fragments
    await GHttp.sendRequest<List<Map<String, dynamic>>>(
      method: 'GET',
      route: getCompletePoolNodeFragmentRoute,
      isAuth: true,
      resultCallback: (int code, List<Map<String, dynamic>> data) async {
        switch (code) {
          case 313:
            await db.delete(MFragmentsAboutCompletePoolNode.getTableName);

            await Future.forEach<Map<String, dynamic>>(
              data,
              (Map<String, dynamic> element) async {
                await db.insert(
                  MFragmentsAboutCompletePoolNode.getTableName,
                  MFragmentsAboutCompletePoolNode.asJsonNoId(
                    atid_v: element['id'] as int?,
                    uuid_v: null,
                    fragments_about_pending_pool_node_atid_v: element['fragment_owner_about_pending_pool_node_id'] as int?,
                    fragments_about_pending_pool_node_uuid_v: null,
                    used_raw_rule_atid_v: element[MFragmentsAboutCompletePoolNode.used_raw_rule_atid] as int?,
                    used_raw_rule_uuid_v: null,
                    pn_complete_pool_node_atid_v: element[MFragmentsAboutCompletePoolNode.pn_complete_pool_node_atid] as int?,
                    pn_complete_pool_node_uuid_v: null,
                    created_at_v: element[MPnCompletePoolNode.created_at] as int?,
                    updated_at_v: element[MPnCompletePoolNode.updated_at] as int?,
                  ),
                );
              },
            );
            dLog(() => 'getCompletePoolNodeFragments:', null, () async => await db.query(MFragmentsAboutCompletePoolNode.getTableName));
            getDataResultType = GetDataResultType.ok;
            break;
          default:
            throw 'unknown code: $code';
        }
        getDataResultType = GetDataResultType.ok;
      },
      sameNotConcurrent: 'getCompletePoolNodeFragments',
      interruptedCallback: (_) {
        dLog(() => _);
        getDataResultType = GetDataResultType.fail;
      },
    );
    return getDataResultType;
  }

  /// 获取规则池节点的全部碎片
  Future<GetDataResultType> getRulePoolNodeFragments() async {
    GetDataResultType getDataResultType = GetDataResultType.fail;
    // TODO: GET api/init_download/get_rule_pool_node_fragments
    await GHttp.sendRequest<List<Map<String, dynamic>>>(
      method: 'GET',
      route: getRulePoolNodeFragmentRoute,
      isAuth: true,
      resultCallback: (int code, List<Map<String, dynamic>> data) async {
        switch (code) {
          case 315:
            await db.delete(MRule.getTableName);

            await Future.forEach<Map<String, dynamic>>(
              data,
              (Map<String, dynamic> element) async {
                await db.insert(
                  MRule.getTableName,
                  MRule.asJsonNoId(
                    atid_v: element['id'] as int?,
                    uuid_v: null,
                    raw_rule_atid_v: element['belongs_to_raw_rule'] == null ? null : element['belongs_to_raw_rule']['id'] as int?,
                    raw_rule_uuid_v: null,
                    pn_rule_pool_node_atid_v: element[MRule.pn_rule_pool_node_atid] as int?,
                    pn_rule_pool_node_uuid_v: null,
                    created_at_v: element[MRule.created_at] as int?,
                    updated_at_v: element[MRule.updated_at] as int?,
                  ),
                );
              },
            );
            dLog(() => 'getRulePoolNodeFragments:', null, () async => await db.query(MRule.getTableName));
            getDataResultType = GetDataResultType.ok;
            break;
          default:
            throw 'unknown code: $code';
        }
        getDataResultType = GetDataResultType.ok;
      },
      sameNotConcurrent: 'getRulePoolNodeFragments',
      interruptedCallback: (_) {
        dLog(() => _);
        getDataResultType = GetDataResultType.fail;
      },
    );
    return getDataResultType;
  }
}