import 'package:jysp/database/g_sqlite/GSqlite.dart';
import 'package:jysp/database/models/MFragmentsAboutCompletePoolNode.dart';
import 'package:jysp/database/models/MFragmentsAboutMemoryPoolNode.dart';
import 'package:jysp/database/models/MFragmentsAboutPendingPoolNode.dart';
import 'package:jysp/database/models/MFragmentsAboutRulePoolNode.dart';
import 'package:jysp/database/models/MPnCompletePoolNode.dart';
import 'package:jysp/database/models/MPnMemoryPoolNode.dart';
import 'package:jysp/database/models/MPnPendingPoolNode.dart';
import 'package:jysp/database/models/MPnRulePoolNode.dart';
import 'package:jysp/database/models/MUser.dart';
import 'package:jysp/g/g_http/GHttp.dart';
import 'package:jysp/mvc/views/init_download_page/Extension.dart';
import 'package:jysp/tools/TDebug.dart';

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
            await db.delete(MUser.tableName);
            await db.insert(
              MUser.tableName,
              MUser.asJsonNoId(
                aiid_v: data['id'] as int?,
                uuid_v: null,
                username_v: data[MUser.username] as String?,
                email_v: data[MUser.email] as String?,
                created_at_v: data[MUser.created_at] as int?,
                updated_at_v: data[MUser.updated_at] as int?,
              ),
            );
            dLog(() => 'getUserInfo:', null, () async => await db.query(MUser.tableName));
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
            await db.delete(MPnPendingPoolNode.tableName);

            await Future.forEach<Map<String, dynamic>>(
              data,
              (Map<String, dynamic> element) async {
                await db.insert(
                  MPnPendingPoolNode.tableName,
                  MPnPendingPoolNode.asJsonNoId(
                    aiid_v: element['id'] as int?,
                    uuid_v: null,
                    recommend_rule_aiid_v: element[MPnPendingPoolNode.recommend_rule_aiid] as int?,
                    recommend_rule_uuid_v: null,
                    type_v: element[MPnPendingPoolNode.type] == null ? null : PendingPoolNodeType.values[element[MPnPendingPoolNode.type] as int],
                    name_v: element[MPnPendingPoolNode.name] as String?,
                    box_position_v: element[MPnPendingPoolNode.box_position] as String?,
                    created_at_v: element[MPnPendingPoolNode.created_at] as int?,
                    updated_at_v: element[MPnPendingPoolNode.updated_at] as int?,
                  ),
                );
              },
            );

            dLog(() => 'getPendingPoolNodes:', null, () async => await db.query(MPnPendingPoolNode.tableName));
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
            await db.delete(MPnMemoryPoolNode.tableName);

            await Future.forEach<Map<String, dynamic>>(
              data,
              (Map<String, dynamic> element) async {
                await db.insert(
                  MPnMemoryPoolNode.tableName,
                  MPnMemoryPoolNode.asJsonNoId(
                    aiid_v: element['id'] as int?,
                    uuid_v: null,
                    using_rule_aiid_v: element[MPnMemoryPoolNode.using_rule_aiid] as int?,
                    using_rule_uuid_v: null,
                    type_v: element[MPnMemoryPoolNode.type] == null ? null : MemoryPoolNodeType.values[element[MPnMemoryPoolNode.type] as int],
                    name_v: element[MPnMemoryPoolNode.name] as String?,
                    box_position_v: element[MPnMemoryPoolNode.box_position] as String?,
                    created_at_v: element[MPnMemoryPoolNode.created_at] as int?,
                    updated_at_v: element[MPnMemoryPoolNode.updated_at] as int?,
                  ),
                );
              },
            );

            dLog(() => 'getMemoryPoolNodes:', null, () async => await db.query(MPnMemoryPoolNode.tableName));
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
            await db.delete(MPnCompletePoolNode.tableName);

            await Future.forEach<Map<String, dynamic>>(
              data,
              (Map<String, dynamic> element) async {
                await db.insert(
                  MPnCompletePoolNode.tableName,
                  MPnCompletePoolNode.asJsonNoId(
                    aiid_v: element['id'] as int?,
                    uuid_v: null,
                    used_rule_aiid_v: element[MPnCompletePoolNode.used_rule_aiid] as int?,
                    used_rule_uuid_v: null,
                    type_v: element[MPnCompletePoolNode.type] == null ? null : CompletePoolNodeType.values[element[MPnCompletePoolNode.type] as int],
                    name_v: element[MPnCompletePoolNode.name] as String?,
                    box_position_v: element[MPnCompletePoolNode.box_position] as String?,
                    created_at_v: element[MPnCompletePoolNode.created_at] as int?,
                    updated_at_v: element[MPnCompletePoolNode.updated_at] as int?,
                  ),
                );
              },
            );

            dLog(() => 'getCompletePoolNodes:', null, () async => await db.query(MPnCompletePoolNode.tableName));
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
            await db.delete(MPnRulePoolNode.tableName);

            await Future.forEach<Map<String, dynamic>>(
              data,
              (Map<String, dynamic> element) async {
                await db.insert(
                  MPnRulePoolNode.tableName,
                  MPnRulePoolNode.asJsonNoId(
                    aiid_v: element['id'] as int?,
                    uuid_v: null,
                    type_v: element[MPnRulePoolNode.type] == null ? null : RulePoolNodeType.values[element[MPnRulePoolNode.type] as int],
                    name_v: element[MPnRulePoolNode.name] as String?,
                    box_position_v: element[MPnRulePoolNode.box_position] as String?,
                    created_at_v: element[MPnRulePoolNode.created_at] as int?,
                    updated_at_v: element[MPnRulePoolNode.updated_at] as int?,
                  ),
                );
              },
            );

            dLog(() => 'getRulePoolNodes:', null, () async => await db.query(MPnRulePoolNode.tableName));
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
            await db.delete(MFragmentsAboutPendingPoolNode.tableName);

            await Future.forEach<Map<String, dynamic>>(
              data,
              (Map<String, dynamic> element) async {
                await db.insert(
                  MFragmentsAboutPendingPoolNode.tableName,
                  MFragmentsAboutPendingPoolNode.asJsonNoId(
                    aiid_v: element['id'] as int?,
                    uuid_v: null,
                    raw_fragment_aiid_v: element['belongs_to_raw_fragment'] == null ? null : element['belongs_to_raw_fragment']['id'] as int?,
                    raw_fragment_uuid_v: null,
                    pn_pending_pool_node_aiid_v: element[MFragmentsAboutPendingPoolNode.pn_pending_pool_node_aiid] as int?,
                    pn_pending_pool_node_uuid_v: null,
                    recommend_rule_aiid_v: element[MFragmentsAboutPendingPoolNode.recommend_rule_aiid] as int?,
                    recommend_rule_uuid_v: null,
                    title_v: element['belongs_to_raw_fragment'] == null ? null : element['belongs_to_raw_fragment']['title'] as String?,
                    created_at_v: element[MFragmentsAboutPendingPoolNode.created_at] as int?,
                    updated_at_v: element[MFragmentsAboutPendingPoolNode.updated_at] as int?,
                  ),
                );
              },
            );
            dLog(() => 'getPendingPoolNodeFragments:', null, () async => await db.query(MFragmentsAboutPendingPoolNode.tableName));
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
            await db.delete(MFragmentsAboutMemoryPoolNode.tableName);

            await Future.forEach<Map<String, dynamic>>(
              data,
              (Map<String, dynamic> element) async {
                await db.insert(
                  MFragmentsAboutMemoryPoolNode.tableName,
                  MFragmentsAboutMemoryPoolNode.asJsonNoId(
                    aiid_v: element['id'] as int?,
                    uuid_v: null,
                    fragments_about_pending_pool_node_aiid_v: element['fragment_owner_about_pending_pool_node_id'] as int?,
                    fragments_about_pending_pool_node_uuid_v: null,
                    using_rule_aiid_v: element[MFragmentsAboutMemoryPoolNode.using_rule_aiid] as int?,
                    using_rule_uuid_v: null,
                    pn_memory_pool_node_aiid_v: element[MFragmentsAboutMemoryPoolNode.pn_memory_pool_node_aiid] as int?,
                    pn_memory_pool_node_uuid_v: null,
                    title_v: element['belongs_to_raw_fragment'] == null ? null : element['belongs_to_raw_fragment']['title'] as String?,
                    created_at_v: element[MFragmentsAboutMemoryPoolNode.created_at] as int?,
                    updated_at_v: element[MFragmentsAboutMemoryPoolNode.updated_at] as int?,
                  ),
                );
              },
            );
            dLog(() => 'getMemoryPoolNodeFragments:', null, () async => await db.query(MFragmentsAboutMemoryPoolNode.tableName));
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
            await db.delete(MFragmentsAboutCompletePoolNode.tableName);

            await Future.forEach<Map<String, dynamic>>(
              data,
              (Map<String, dynamic> element) async {
                await db.insert(
                  MFragmentsAboutCompletePoolNode.tableName,
                  MFragmentsAboutCompletePoolNode.asJsonNoId(
                    aiid_v: element['id'] as int?,
                    uuid_v: null,
                    fragments_about_pending_pool_node_aiid_v: element['fragment_owner_about_pending_pool_node_id'] as int?,
                    fragments_about_pending_pool_node_uuid_v: null,
                    used_rule_aiid_v: element[MFragmentsAboutCompletePoolNode.used_rule_aiid] as int?,
                    used_rule_uuid_v: null,
                    pn_complete_pool_node_aiid_v: element[MFragmentsAboutCompletePoolNode.pn_complete_pool_node_aiid] as int?,
                    pn_complete_pool_node_uuid_v: null,
                    title_v: element['belongs_to_raw_fragment'] == null ? null : element['belongs_to_raw_fragment']['title'] as String?,
                    created_at_v: element[MPnCompletePoolNode.created_at] as int?,
                    updated_at_v: element[MPnCompletePoolNode.updated_at] as int?,
                  ),
                );
              },
            );
            dLog(() => 'getCompletePoolNodeFragments:', null, () async => await db.query(MFragmentsAboutCompletePoolNode.tableName));
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
            await db.delete(MFragmentsAboutRulePoolNode.tableName);

            await Future.forEach<Map<String, dynamic>>(
              data,
              (Map<String, dynamic> element) async {
                await db.insert(
                  MFragmentsAboutRulePoolNode.tableName,
                  MFragmentsAboutRulePoolNode.asJsonNoId(
                    aiid_v: element['id'] as int?,
                    uuid_v: null,
                    raw_rule_aiid_v: element['belongs_to_raw_rule'] == null ? null : element['belongs_to_raw_rule']['id'] as int?,
                    raw_rule_uuid_v: null,
                    pn_rule_pool_node_aiid_v: element[MFragmentsAboutRulePoolNode.pn_rule_pool_node_aiid] as int?,
                    pn_rule_pool_node_uuid_v: null,
                    title_v: element['belongs_to_raw_fragment'] == null ? null : element['belongs_to_raw_fragment']['title'] as String?,
                    created_at_v: element[MFragmentsAboutRulePoolNode.created_at] as int?,
                    updated_at_v: element[MFragmentsAboutRulePoolNode.updated_at] as int?,
                  ),
                );
              },
            );
            dLog(() => 'getRulePoolNodeFragments:', null, () async => await db.query(MFragmentsAboutRulePoolNode.tableName));
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
