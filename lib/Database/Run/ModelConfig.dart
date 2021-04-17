// ignore_for_file: non_constant_identifier_names

import 'package:jysp/Database/Run/main.dart';

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
  download_modules();
  pn_pending_pool_nodes();
  pn_memory_pool_nodes();
  pn_complete_pool_nodes();
  pn_rule_pool_nodes();
  fragments_about_pending_pool_nodes();
  fragments_about_memory_pool_nodes();
  fragments_about_complete_pool_nodes();
  rules();
  createGlobalEnums([
    ["Curd", "C", "U", "R", "D"] // C:增，U:改，R:查(默认，即无)，D:删
  ]);
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
    isNeedGlobalEnum: false,
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
    isNeedGlobalEnum: false,
  );
}

void users() {
  createModel(
    tableNameWithS: "users",
    createField: createFields(
      fields: {
        "user_id": x_id_integer(),
        "username": setFieldTypes([SqliteType.TEXT], "String"),
        "email": setFieldTypes([SqliteType.TEXT], "String"),
      },
      timestamp: true,
      curd_status: true,
    ),
    isNeedGlobalEnum: true,
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
    isNeedGlobalEnum: false,
  );
}

void download_modules() {
  createModel(
    tableNameWithS: "download_modules",
    createField: createFields(
      fields: {
        "module_name": setFieldTypes([SqliteType.TEXT], "String"),
        "download_status": setFieldTypes([SqliteType.INTEGER], "SqliteDownloadStatus"),
      },
      timestamp: true,
      curd_status: false,
    ),
    extraEnum: createExtraEnums(
      [
        setExtraEnumMembers(enumTypeName: "SqliteDownloadStatus", members: ["downloaded", "notDownload"]),
      ],
    ),
    isNeedGlobalEnum: false,
  );
}

// void download_queue_modules() {
//   createModel(
//     tableNameWithS: "download_queue_modules",
//     createField: createFields(
//       fields: {
//         "module_name": setFieldTypes([SqliteType.TEXT], "String"),
//         "download_is_ok": setFieldTypes([SqliteType.INTEGER], "DownloadIsOk"),
//         "isRequired": setFieldTypes([SqliteType.INTEGER], "IsRequired"),
//       },
//       timestamp: true,
//       curd_status: false,
//     ),
//     extraEnum: createExtraEnums(
//       [
//         setExtraEnumMembers(enumTypeName: "DownloadIsOk", members: ["no", "yes"]),
//         setExtraEnumMembers(enumTypeName: "IsRequired", members: ["no", "yes"]),
//       ],
//     ),
//   );
// }

// void download_queue_rows() {
//   createModel(
//     tableNameWithS: "download_queue_rows",
//     createField: createFields(
//       fields: {
//         "table_name": setFieldTypes([SqliteType.TEXT], "String"),
//         "row_id": x_id_integer(),
//         "download_is_ok": setFieldTypes([SqliteType.INTEGER], "int"),
//       },
//       timestamp: true,
//       curd_status: false,
//     ),
//   );
// }

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
    isNeedGlobalEnum: true,
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
    isNeedGlobalEnum: true,
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
    isNeedGlobalEnum: true,
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
    isNeedGlobalEnum: true,
  );
}

void fragments_about_pending_pool_nodes() {
  createModel(
    tableNameWithS: "fragments_about_pending_pool_nodes",
    createField: createFields(
      fields: {
        "fragments_about_pending_pool_node_id": x_id_integer(),
        "fragments_about_pending_pool_node_uuid": x_id_text(),
        "raw_fragment_id": x_id_integer(),
        "raw_fragment_id_uuid": x_id_text(),
        "pn_pending_pool_node_id": x_id_integer(),
        "pn_pending_pool_node_uuid": x_id_text(),
        "recommend_raw_rule_id": x_id_integer(),
        "recommend_raw_rule_uuid": x_id_text(),
        "title": setFieldTypes([SqliteType.TEXT], "String"),
      },
      timestamp: true,
      curd_status: true,
    ),
    isNeedGlobalEnum: true,
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
    isNeedGlobalEnum: true,
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
    isNeedGlobalEnum: true,
  );
}

void rules() {
  createModel(
    tableNameWithS: "rules",
    createField: createFields(
      fields: {
        "rule_id": x_id_integer(),
        "rule_uuid": x_id_text(),
        "raw_rule_id": x_id_integer(),
        "raw_rule_uuid": x_id_text(),
        "pn_rule_pool_node_id": x_id_integer(),
        "pn_rule_pool_node_uuid": x_id_text(),
      },
      timestamp: true,
      curd_status: true,
    ),
    isNeedGlobalEnum: true,
  );
}
