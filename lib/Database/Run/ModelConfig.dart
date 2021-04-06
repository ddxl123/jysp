// ignore_for_file: non_constant_identifier_names

import 'package:jysp/Database/Run/main.dart';
import 'package:jysp/Database/base/SqliteType.dart';

///
///
///
/// 输入字段模块
///

bool isCoverFile = true;

void runCreateModels() {
  version_infos();
  tokens();
  users();
  uploads();
  download_queue_modules();
  download_queue_rows();
  pn_pending_pool_nodes();
  pn_memory_pool_nodes();
  pn_complete_pool_nodes();
  pn_rule_pool_nodes();
  fragments_about_pending_pool_nodes();
  fragments_about_memory_pool_nodes();
  fragments_about_complete_pool_nodes();
  rules();
  runDownloadModuleField();
}

void version_infos() {
  createModel(
    tableNameWithS: "version_infos",
    createField: createFields(
      fields: {
        "saved_version": setFieldTypes([SqliteType.TEXT], "String"),
      },
      timestamp: true,
      curd_status: false,
    ),
  );
}

void tokens() {
  createModel(
    tableNameWithS: "tokens",
    createField: createFields(
      fields: {
        "access_token": setFieldTypes([SqliteType.TEXT], "String"),
        "refresh_token": setFieldTypes([SqliteType.TEXT], "String"),
      },
      timestamp: true,
      curd_status: false,
    ),
  );
}

void users() {
  createModel(
    tableNameWithS: "users",
    createField: createFields(
      fields: {
        "user_id": x_id_integer(),
        "username": setFieldTypes([SqliteType.TEXT], "int"),
        "password": setFieldTypes([SqliteType.TEXT], "String"),
        "email": setFieldTypes([SqliteType.TEXT], "String"),
      },
      timestamp: true,
      curd_status: true,
    ),
  );
}

void uploads() {
  createModel(
    tableNameWithS: "uploads",
    createField: createFields(
      fields: {
        "table_name": setFieldTypes([SqliteType.TEXT], "String"),
        "row_id": x_id_integer(),
        "row_uuid": x_id_text(),
        "upload_is_ok": setFieldTypes([SqliteType.INTEGER], "String"),
      },
      timestamp: true,
      curd_status: false,
    ),
  );
}

void download_queue_modules() {
  createModel(
      tableNameWithS: "download_queue_modules",
      createField: createFields(
        fields: {
          "module_name": setFieldTypes([SqliteType.TEXT], "String"),
          "download_is_ok": setFieldTypes([SqliteType.INTEGER], "int"), // 0 未下载，1 下载完成
        },
        timestamp: true,
        curd_status: false,
      ),
      extra: """static List<String> downloadQueueBaseModules =
      [
        "user_info",
        "pending_pool_nodes",
        "memory_pool_nodes",
        "complete_pool_nodes",
        "rule_pool_nodes",
      ];
""");
}

void download_queue_rows() {
  createModel(
    tableNameWithS: "download_queue_rows",
    createField: createFields(
      fields: {
        "table_name": setFieldTypes([SqliteType.TEXT], "String"),
        "row_id": x_id_integer(),
        "download_is_ok": setFieldTypes([SqliteType.INTEGER], "int"),
      },
      timestamp: true,
      curd_status: false,
    ),
  );
}

void pn_pending_pool_nodes() {
  createModel(
    tableNameWithS: "pn_pending_pool_nodes",
    createField: createFields(
      fields: {
        "pn_pending_pool_node_id": x_id_integer(),
        "pn_pending_pool_node_uuid": x_id_text(),
        "recommend_raw_rule_id": x_id_integer(),
        "recommend_raw_rule_uuid": x_id_text(),
        "type": setFieldTypes([SqliteType.INTEGER], "PendingPoolNodeType"),
        "name": setFieldTypes([SqliteType.TEXT], "String"),
        "position": setFieldTypes([SqliteType.TEXT], "String"),
      },
      timestamp: true,
      curd_status: true,
    ),
    extraEnum: createExtraEnums(
      [
        setExtraEnumMembers(
          enumTypeName: "PendingPoolNodeType",
          members: ["notDownloaded", "nodeIsZero", "ordinary"],
        ),
      ],
    ),
  );
}

void pn_memory_pool_nodes() {
  createModel(
    tableNameWithS: "pn_memory_pool_nodes",
    createField: createFields(
      fields: {
        "pn_memory_pool_node_id": x_id_integer(),
        "pn_memory_pool_node_uuid": x_id_text(),
        "using_raw_rule_id": x_id_integer(),
        "using_raw_rule_uuid": x_id_text(),
        "type": setFieldTypes([SqliteType.INTEGER], "int"),
        "name": setFieldTypes([SqliteType.TEXT], "String"),
        "position": setFieldTypes([SqliteType.TEXT], "String"),
      },
      timestamp: true,
      curd_status: true,
    ),
  );
}

void pn_complete_pool_nodes() {
  createModel(
    tableNameWithS: "pn_complete_pool_nodes",
    createField: createFields(
      fields: {
        "pn_complete_pool_node_id": x_id_integer(),
        "pn_complete_pool_node_uuid": x_id_text(),
        "used_raw_rule_id": x_id_integer(),
        "used_raw_rule_uuid": x_id_text(),
        "type": setFieldTypes([SqliteType.INTEGER], "int"),
        "name": setFieldTypes([SqliteType.TEXT], "String"),
        "position": setFieldTypes([SqliteType.TEXT], "String"),
      },
      timestamp: true,
      curd_status: true,
    ),
  );
}

void pn_rule_pool_nodes() {
  createModel(
    tableNameWithS: "pn_rule_pool_nodes",
    createField: createFields(
      fields: {
        "pn_rule_pool_node_id": x_id_integer(),
        "pn_rule_pool_node_uuid": x_id_text(),
        "type": setFieldTypes([SqliteType.INTEGER], "int"),
        "name": setFieldTypes([SqliteType.TEXT], "String"),
        "position": setFieldTypes([SqliteType.TEXT], "String"),
      },
      timestamp: true,
      curd_status: true,
    ),
  );
}

void fragments_about_pending_pool_nodes() {
  createModel(
    tableNameWithS: "fragments_about_pending_pool_nodes",
    createField: createFields(
      fields: {
        "fragments_about_pending_pool_node_id": x_id_integer(),
        "fragments_about_pending_pool_node_uuid": x_id_text(),
        "pn_pending_pool_node_id": x_id_integer(),
        "pn_pending_pool_node_uuid": x_id_text(),
        "recommend_raw_rule_id": x_id_integer(),
        "recommend_raw_rule_uuid": x_id_text(),
        "title": setFieldTypes([SqliteType.INTEGER], "int"),
      },
      timestamp: true,
      curd_status: true,
    ),
  );
}

void fragments_about_memory_pool_nodes() {
  createModel(
    tableNameWithS: "fragments_about_memory_pool_nodes",
    createField: createFields(
      fields: {
        "fragments_about_memory_pool_node_id": x_id_integer(),
        "fragments_about_memory_pool_node_uuid": x_id_text(),
        "fragments_about_pending_pool_node_id": x_id_integer(),
        "fragments_about_pending_pool_node_uuid": x_id_text(),
        "using_raw_rule_id": x_id_integer(),
        "using_raw_rule_uuid": x_id_text(),
        "pn_memory_pool_node_id": x_id_integer(),
        "pn_memory_pool_node_uuid": x_id_text(),
      },
      timestamp: true,
      curd_status: true,
    ),
  );
}

void fragments_about_complete_pool_nodes() {
  createModel(
    tableNameWithS: "fragments_about_complete_pool_nodes",
    createField: createFields(
      fields: {
        "fragments_about_complete_pool_node_id": x_id_integer(),
        "fragments_about_complete_pool_node_uuid": x_id_text(),
        "fragments_about_pending_pool_node_id": x_id_integer(),
        "fragments_about_pending_pool_node_uuid": x_id_text(),
        "used_raw_rule_id": x_id_integer(),
        "used_raw_rule_uuid": x_id_text(),
        "pn_complete_pool_node_id": x_id_integer(),
        "pn_complete_pool_node_uuid": x_id_text(),
      },
      timestamp: true,
      curd_status: true,
    ),
  );
}

void rules() {
  createModel(
    tableNameWithS: "rules",
    createField: createFields(
      fields: {
        "raw_rule_id": x_id_integer(),
        "raw_rule_uuid": x_id_text(),
        "pn_rule_pool_node_id": x_id_integer(),
        "pn_rule_pool_node_uuid": x_id_text(),
      },
      timestamp: true,
      curd_status: true,
    ),
  );
}

void runDownloadModuleField() {
  downloadBaseModules.addAll(
    [
      ["user_info", "个人信息"],
      ["pending_pool_nodes", "待定池节点"],
      ["memory_pool_nodes", "记忆池节点"],
      ["complete_pool_nodes", "完成池节点"],
      ["rule_pool_nodes", "规则池节点"],
    ],
  );
}
