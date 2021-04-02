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
  users();
  curds();
  tokens();
  pn_pending_pool_nodes();
  pn_memory_pool_nodes();
  pn_complete_pool_nodes();
  pn_rule_pool_nodes();
  fragments_about_pending_pool_nodes();
  fragments_about_memory_pool_nodes();
  fragments_about_complete_pool_nodes();
  rules();
}

void users() {
  createModel(
    tableNameWithS: "users",
    createField: createFields(
      fields: {
        "user_id": x_id_integer(),
        "username": setFieldTypes([SqliteType.TEXT], SqliteType.int),
        "password": setFieldTypes([SqliteType.TEXT], SqliteType.String),
        "email": setFieldTypes([SqliteType.TEXT], SqliteType.String),
      },
      timestamp: true,
      curd_status: true,
    ),
  );
}

void curds() {
  createModel(
    tableNameWithS: "curds",
    createField: createFields(
      fields: {
        "table": setFieldTypes([SqliteType.TEXT], SqliteType.String),
        "row_id": x_id_integer(),
        "row_uuid": x_id_text(),
        "curd_is_ok": setFieldTypes([SqliteType.INTEGER], SqliteType.int),
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
        "access_token": x_id_integer(),
        "refresh_token": x_id_text(),
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
        "type": setFieldTypes([SqliteType.INTEGER], SqliteType.int),
        "name": setFieldTypes([SqliteType.TEXT], SqliteType.String),
        "position": setFieldTypes([SqliteType.TEXT], SqliteType.String),
      },
      timestamp: true,
      curd_status: true,
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
        "type": setFieldTypes([SqliteType.INTEGER], SqliteType.int),
        "name": setFieldTypes([SqliteType.TEXT], SqliteType.String),
        "position": setFieldTypes([SqliteType.TEXT], SqliteType.String),
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
        "type": setFieldTypes([SqliteType.INTEGER], SqliteType.int),
        "name": setFieldTypes([SqliteType.TEXT], SqliteType.String),
        "position": setFieldTypes([SqliteType.TEXT], SqliteType.String),
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
        "type": setFieldTypes([SqliteType.INTEGER], SqliteType.int),
        "name": setFieldTypes([SqliteType.TEXT], SqliteType.String),
        "position": setFieldTypes([SqliteType.TEXT], SqliteType.String),
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
        "title": setFieldTypes([SqliteType.INTEGER], SqliteType.int),
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
