import 'package:jysp/Database/models/GlobalEnum.dart';
import 'package:jysp/Database/models/MFragmentsAboutCompletePoolNode.dart';
import 'package:jysp/Database/models/MFragmentsAboutMemoryPoolNode.dart';
import 'package:jysp/Database/models/MFragmentsAboutPendingPoolNode.dart';
import 'package:jysp/Database/models/MPnCompletePoolNode.dart';
import 'package:jysp/Database/models/MPnMemoryPoolNode.dart';
import 'package:jysp/Database/models/MPnPendingPoolNode.dart';
import 'package:jysp/Database/models/MPnRulePoolNode.dart';
import 'package:jysp/Database/models/MRule.dart';
import 'package:jysp/Database/models/MUser.dart';
import 'package:jysp/G/GHttp/GHttp.dart';
import 'package:jysp/G/GSqlite/GSqlite.dart';
import 'package:jysp/MVC/Views/InitDownloadPage/Extension.dart';
import 'package:jysp/Tools/TDebug.dart';

class RInitDownload {
  ///

  String getUserInfoRoute = "api/init_download/get_user_info";
  String getPendingPoolNodesRoute = "api/init_download/get_pending_pool_nodes";
  String getMemoryPoolNodesRoute = "api/init_download/get_memory_pool_nodes";
  String getCompletePoolNodesRoute = "api/init_download/get_complete_pool_nodes";
  String getRulePoolNodesRoute = "api/init_download/get_rule_pool_nodes";
  String getPendingPoolNodeFragmentRoute = "api/init_download/get_pending_pool_node_fragments";
  String getMemoryPoolNodeFragmentRoute = "api/init_download/get_memory_pool_node_fragments";
  String getCompletePoolNodeFragmentRoute = "api/init_download/get_complete_pool_node_fragments";
  String getRulePoolNodeFragmentRoute = "api/init_download/get_rule_pool_node_fragments";

  /// 获取用户信息
  Future<GetDataResultType> getUserInfo() async {
    GetDataResultType getDataResultType = GetDataResultType.fail;
    // TODO: GET api/init_download/get_user_info
    await GHttp.sendRequest<Map<String, dynamic>>(
      method: "GET",
      route: getUserInfoRoute,
      isAuth: true,
      resultCallback: (code, data) async {
        switch (code) {
          case 300:
            await GSqlite.db.delete(MUser.getTableName);
            await GSqlite.db.insert(
              MUser.getTableName,
              MUser.toSqliteMap(
                user_id_v: data["id"],
                username_v: data[MUser.username],
                email_v: data[MUser.email],
                created_at_v: data[MUser.created_at],
                updated_at_v: data[MUser.updated_at],
                curd_status_v: Curd.R,
              ),
            );
            dLog(() => "getUserInfo:", null, () async => await GSqlite.db.query(MUser.getTableName));
            getDataResultType = GetDataResultType.ok;
            break;
          default:
            throw "code is unknown";
        }
      },
      interruptedCallback: (_) {
        dLog(() => _);
        getDataResultType = GetDataResultType.fail;
      },
      sameNotConcurrent: "getUserInfo",
    );
    return getDataResultType;
  }

  /// 获取待定池节点
  Future<GetDataResultType> getPendingPoolNodes() async {
    GetDataResultType getDataResultType = GetDataResultType.fail;
    // TODO: GET api/init_download/get_pending_pool_nodes
    await GHttp.sendRequest<List<Map<String, dynamic>>>(
      method: "GET",
      route: getPendingPoolNodesRoute,
      isAuth: true,
      resultCallback: (code, data) async {
        switch (code) {
          case 302:
            await GSqlite.db.delete(MPnPendingPoolNode.getTableName);

            await Future.forEach<Map<String, dynamic>>(
              data,
              (element) async {
                await GSqlite.db.insert(
                  MPnPendingPoolNode.getTableName,
                  MPnPendingPoolNode.toSqliteMap(
                    pn_pending_pool_node_id_v: element["id"],
                    pn_pending_pool_node_uuid_v: null,
                    recommend_raw_rule_id_v: element[MPnPendingPoolNode.recommend_raw_rule_id],
                    recommend_raw_rule_uuid_v: null,
                    type_v: PendingPoolNodeType.values[element[MPnPendingPoolNode.type]],
                    name_v: element[MPnPendingPoolNode.name],
                    position_v: element[MPnPendingPoolNode.position],
                    created_at_v: element[MPnPendingPoolNode.created_at],
                    updated_at_v: element[MPnPendingPoolNode.updated_at],
                    curd_status_v: Curd.R,
                  ),
                );
              },
            );

            dLog(() => "getPendingPoolNodes:", null, () async => await GSqlite.db.query(MPnPendingPoolNode.getTableName));
            getDataResultType = GetDataResultType.ok;
            break;
          default:
            throw "unknown code: $code";
        }
      },
      interruptedCallback: (_) {
        dLog(() => _);
        getDataResultType = GetDataResultType.fail;
      },
      sameNotConcurrent: "getPendingPoolNodes",
    );
    return getDataResultType;
  }

  /// 获取记忆池节点
  Future<GetDataResultType> getMemoryPoolNodes() async {
    GetDataResultType getDataResultType = GetDataResultType.fail;
    // TODO: GET api/init_download/get_memory_pool_nodes
    await GHttp.sendRequest<List<Map<String, dynamic>>>(
      method: "GET",
      route: getMemoryPoolNodesRoute,
      isAuth: true,
      resultCallback: (code, data) async {
        switch (code) {
          case 304:
            await GSqlite.db.delete(MPnMemoryPoolNode.getTableName);

            await Future.forEach<Map<String, dynamic>>(
              data,
              (element) async {
                await GSqlite.db.insert(
                  MPnMemoryPoolNode.getTableName,
                  MPnMemoryPoolNode.toSqliteMap(
                    pn_memory_pool_node_id_v: element["id"],
                    pn_memory_pool_node_uuid_v: null,
                    using_raw_rule_id_v: element[MPnMemoryPoolNode.using_raw_rule_id],
                    using_raw_rule_uuid_v: null,
                    type_v: element[MPnMemoryPoolNode.type],
                    name_v: element[MPnMemoryPoolNode.name],
                    position_v: element[MPnMemoryPoolNode.position],
                    created_at_v: element[MPnMemoryPoolNode.created_at],
                    updated_at_v: element[MPnMemoryPoolNode.updated_at],
                    curd_status_v: Curd.R,
                  ),
                );
              },
            );

            dLog(() => "getMemoryPoolNodes:", null, () async => await GSqlite.db.query(MPnMemoryPoolNode.getTableName));
            getDataResultType = GetDataResultType.ok;
            break;
          default:
            throw "unknown code: $code";
        }
      },
      sameNotConcurrent: "getMemoryPoolNodes",
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
      method: "GET",
      route: getCompletePoolNodesRoute,
      isAuth: true,
      resultCallback: (code, data) async {
        switch (code) {
          case 306:
            await GSqlite.db.delete(MPnCompletePoolNode.getTableName);

            await Future.forEach<Map<String, dynamic>>(
              data,
              (element) async {
                await GSqlite.db.insert(
                  MPnCompletePoolNode.getTableName,
                  MPnCompletePoolNode.toSqliteMap(
                    pn_complete_pool_node_id_v: element["id"],
                    pn_complete_pool_node_uuid_v: null,
                    used_raw_rule_id_v: element[MPnCompletePoolNode.used_raw_rule_id],
                    used_raw_rule_uuid_v: null,
                    type_v: element[MPnCompletePoolNode.type],
                    name_v: element[MPnCompletePoolNode.name],
                    position_v: element[MPnCompletePoolNode.position],
                    created_at_v: element[MPnCompletePoolNode.created_at],
                    updated_at_v: element[MPnCompletePoolNode.updated_at],
                    curd_status_v: Curd.R,
                  ),
                );
              },
            );

            dLog(() => "getCompletePoolNodes:", null, () async => await GSqlite.db.query(MPnCompletePoolNode.getTableName));
            getDataResultType = GetDataResultType.ok;
            break;
          default:
            throw "unknown code: $code";
        }
      },
      sameNotConcurrent: "getCompletePoolNodes",
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
      method: "GET",
      route: getRulePoolNodesRoute,
      isAuth: true,
      resultCallback: (code, data) async {
        switch (code) {
          case 308:
            await GSqlite.db.delete(MPnRulePoolNode.getTableName);

            await Future.forEach<Map<String, dynamic>>(
              data,
              (element) async {
                await GSqlite.db.insert(
                  MPnRulePoolNode.getTableName,
                  MPnRulePoolNode.toSqliteMap(
                    pn_rule_pool_node_id_v: element["id"],
                    pn_rule_pool_node_uuid_v: null,
                    type_v: element[MPnRulePoolNode.type],
                    name_v: element[MPnRulePoolNode.name],
                    position_v: element[MPnRulePoolNode.position],
                    created_at_v: element[MPnRulePoolNode.created_at],
                    updated_at_v: element[MPnRulePoolNode.updated_at],
                    curd_status_v: Curd.R,
                  ),
                );
              },
            );

            dLog(() => "getRulePoolNodes:", null, () async => await GSqlite.db.query(MPnRulePoolNode.getTableName));
            getDataResultType = GetDataResultType.ok;
            break;
          default:
            throw "unknown code: $code";
        }
      },
      sameNotConcurrent: "getRulePoolNodes",
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
      method: "GET",
      route: getPendingPoolNodeFragmentRoute,
      isAuth: true,
      resultCallback: (code, data) async {
        switch (code) {
          case 310:
            await GSqlite.db.delete(MFragmentsAboutPendingPoolNode.getTableName);

            await Future.forEach<Map<String, dynamic>>(
              data,
              (element) async {
                await GSqlite.db.insert(
                  MFragmentsAboutPendingPoolNode.getTableName,
                  MFragmentsAboutPendingPoolNode.toSqliteMap(
                    fragments_about_pending_pool_node_id_v: element["id"],
                    fragments_about_pending_pool_node_uuid_v: null,
                    raw_fragment_id_v: element["belongs_to_raw_fragment"] == null ? null : element["belongs_to_raw_fragment"]["id"],
                    raw_fragment_id_uuid_v: null,
                    pn_pending_pool_node_id_v: element[MFragmentsAboutPendingPoolNode.pn_pending_pool_node_id],
                    pn_pending_pool_node_uuid_v: null,
                    recommend_raw_rule_id_v: element[MFragmentsAboutPendingPoolNode.recommend_raw_rule_id],
                    recommend_raw_rule_uuid_v: null,
                    title_v: element["belongs_to_raw_fragment"] == null ? null : element["belongs_to_raw_fragment"]["title"],
                    created_at_v: element[MFragmentsAboutPendingPoolNode.created_at],
                    updated_at_v: element[MFragmentsAboutPendingPoolNode.updated_at],
                    curd_status_v: Curd.R,
                  ),
                );
              },
            );
            dLog(() => "getPendingPoolNodeFragments:", null, () async => await GSqlite.db.query(MFragmentsAboutPendingPoolNode.getTableName));
            getDataResultType = GetDataResultType.ok;
            break;
          default:
            throw "unknown code: $code";
        }
      },
      sameNotConcurrent: "getPendingPoolNodeFragments",
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
      method: "GET",
      route: getMemoryPoolNodeFragmentRoute,
      isAuth: true,
      resultCallback: (code, data) async {
        switch (code) {
          case 312:
            await GSqlite.db.delete(MFragmentsAboutMemoryPoolNode.getTableName);

            await Future.forEach<Map<String, dynamic>>(
              data,
              (element) async {
                await GSqlite.db.insert(
                  MFragmentsAboutMemoryPoolNode.getTableName,
                  MFragmentsAboutMemoryPoolNode.toSqliteMap(
                    fragments_about_memory_pool_node_id_v: element["id"],
                    fragments_about_memory_pool_node_uuid_v: null,
                    fragments_about_pending_pool_node_id_v: element["fragment_owner_about_pending_pool_node_id"],
                    fragments_about_pending_pool_node_uuid_v: null,
                    using_raw_rule_id_v: element[MFragmentsAboutMemoryPoolNode.using_raw_rule_id],
                    using_raw_rule_uuid_v: null,
                    pn_memory_pool_node_id_v: element[MFragmentsAboutMemoryPoolNode.pn_memory_pool_node_id],
                    pn_memory_pool_node_uuid_v: null,
                    created_at_v: element[MFragmentsAboutMemoryPoolNode.created_at],
                    updated_at_v: element[MFragmentsAboutMemoryPoolNode.updated_at],
                    curd_status_v: Curd.R,
                  ),
                );
              },
            );
            dLog(() => "getMemoryPoolNodeFragments:", null, () async => await GSqlite.db.query(MFragmentsAboutMemoryPoolNode.getTableName));
            getDataResultType = GetDataResultType.ok;
            break;
          default:
            throw "unknown code: $code";
        }
        getDataResultType = GetDataResultType.ok;
      },
      sameNotConcurrent: "getMemoryPoolNodeFragments",
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
      method: "GET",
      route: getCompletePoolNodeFragmentRoute,
      isAuth: true,
      resultCallback: (code, data) async {
        switch (code) {
          case 313:
            await GSqlite.db.delete(MFragmentsAboutCompletePoolNode.getTableName);

            await Future.forEach<Map<String, dynamic>>(
              data,
              (element) async {
                await GSqlite.db.insert(
                  MFragmentsAboutCompletePoolNode.getTableName,
                  MFragmentsAboutCompletePoolNode.toSqliteMap(
                    fragments_about_complete_pool_node_id_v: element["id"],
                    fragments_about_complete_pool_node_uuid_v: null,
                    fragments_about_pending_pool_node_id_v: element["fragment_owner_about_pending_pool_node_id"],
                    fragments_about_pending_pool_node_uuid_v: null,
                    used_raw_rule_id_v: element[MFragmentsAboutCompletePoolNode.used_raw_rule_id],
                    used_raw_rule_uuid_v: null,
                    pn_complete_pool_node_id_v: element[MFragmentsAboutCompletePoolNode.pn_complete_pool_node_id],
                    pn_complete_pool_node_uuid_v: null,
                    created_at_v: element[MPnCompletePoolNode.created_at],
                    updated_at_v: element[MPnCompletePoolNode.updated_at],
                    curd_status_v: Curd.R,
                  ),
                );
              },
            );
            dLog(() => "getCompletePoolNodeFragments:", null, () async => await GSqlite.db.query(MFragmentsAboutCompletePoolNode.getTableName));
            getDataResultType = GetDataResultType.ok;
            break;
          default:
            throw "unknown code: $code";
        }
        getDataResultType = GetDataResultType.ok;
      },
      sameNotConcurrent: "getCompletePoolNodeFragments",
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
      method: "GET",
      route: getRulePoolNodeFragmentRoute,
      isAuth: true,
      resultCallback: (code, data) async {
        switch (code) {
          case 315:
            await GSqlite.db.delete(MRule.getTableName);

            await Future.forEach<Map<String, dynamic>>(
              data,
              (element) async {
                await GSqlite.db.insert(
                  MRule.getTableName,
                  MRule.toSqliteMap(
                    rule_id_v: element["id"],
                    rule_uuid_v: null,
                    raw_rule_id_v: element["belongs_to_raw_rule"] == null ? null : element["belongs_to_raw_rule"]["id"],
                    raw_rule_uuid_v: null,
                    pn_rule_pool_node_id_v: element[MRule.pn_rule_pool_node_id],
                    pn_rule_pool_node_uuid_v: null,
                    created_at_v: element[MRule.created_at],
                    updated_at_v: element[MRule.updated_at],
                    curd_status_v: Curd.R,
                  ),
                );
              },
            );
            dLog(() => "getRulePoolNodeFragments:", null, () async => await GSqlite.db.query(MRule.getTableName));
            getDataResultType = GetDataResultType.ok;
            break;
          default:
            throw "unknown code: $code";
        }
        getDataResultType = GetDataResultType.ok;
      },
      sameNotConcurrent: "getRulePoolNodeFragments",
      interruptedCallback: (_) {
        dLog(() => _);
        getDataResultType = GetDataResultType.fail;
      },
    );
    return getDataResultType;
  }
}
