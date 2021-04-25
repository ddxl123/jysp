// ignore_for_file: non_constant_identifier_names

import 'package:jysp/Database/Run/Create.dart';
import 'package:jysp/Database/Run/main.dart';

// ignore: avoid_classes_with_only_static_members
class TableNames {
  static String version_infos = 'version_infos';
  static String tokens = 'tokens';
  static String users = 'users';
  static String uploads = 'uploads';
  static String download_modules = 'download_modules';
  static String pn_pending_pool_nodes = 'pn_pending_pool_nodes';
  static String pn_memory_pool_nodes = 'pn_memory_pool_nodes';
  static String pn_complete_pool_nodes = 'pn_complete_pool_nodes';
  static String pn_rule_pool_nodes = 'pn_rule_pool_nodes';
  static String fragments_about_pending_pool_nodes = 'fragments_about_pending_pool_nodes';
  static String fragments_about_memory_pool_nodes = 'fragments_about_memory_pool_nodes';
  static String fragments_about_complete_pool_nodes = 'fragments_about_complete_pool_nodes';
  static String rules = 'rules';
}

void runCreateModels() {
  f_version_infos();
  f_tokens();
  f_users();
  f_uploads();
  f_download_modules();
  f_pn_pending_pool_nodes();
  f_pn_memory_pool_nodes();
  f_pn_complete_pool_nodes();
  f_pn_rule_pool_nodes();
  f_fragments_about_pending_pool_nodes();
  f_fragments_about_memory_pool_nodes();
  f_fragments_about_complete_pool_nodes();
  f_rules();
  createGlobalEnums(<List<String>>[
    <String>['CurdStatus', 'C', 'U', 'R', 'D'] // C:增，U:改，R:查(默认，即无)，D:删
  ]);
}

void f_version_infos() {
  CreateModel(
    tableNameWithS: TableNames.version_infos,
    createFields: (
      Map<String, List<Object>> Function(String, List<SqliteType>, String) setFields,
      Map<String, List<Object>> Function(String, String?, {required bool isDeleteChildFollowFather, required bool isDeleteFatherFollowChild}) x_id_integer,
      Map<String, List<Object>> Function(String, String?, {required bool isDeleteChildFollowFather, required bool isDeleteFatherFollowChild}) x_id_text,
    ) {
      return <Map<String, List<Object>>>[
        setFields('saved_version', <SqliteType>[SqliteType.TEXT], 'String'),
      ];
    },
  );
}

void f_tokens() {
  CreateModel(
    tableNameWithS: TableNames.tokens,
    createFields: (
      Map<String, List<Object>> Function(String, List<SqliteType>, String) setFields,
      Map<String, List<Object>> Function(String, String?, {required bool isDeleteChildFollowFather, required bool isDeleteFatherFollowChild}) x_id_integer,
      Map<String, List<Object>> Function(String, String?, {required bool isDeleteChildFollowFather, required bool isDeleteFatherFollowChild}) x_id_text,
    ) {
      return <Map<String, List<Object>>>[
        setFields('access_token', <SqliteType>[SqliteType.TEXT], 'String'),
        setFields('refresh_token', <SqliteType>[SqliteType.TEXT], 'String'),
      ];
    },
  );
}

void f_users() {
  CreateModel(
    tableNameWithS: TableNames.users,
    createFields: (
      Map<String, List<Object>> Function(String, List<SqliteType>, String) setFields,
      Map<String, List<Object>> Function(String, String?, {required bool isDeleteChildFollowFather, required bool isDeleteFatherFollowChild}) x_id_integer,
      Map<String, List<Object>> Function(String, String?, {required bool isDeleteChildFollowFather, required bool isDeleteFatherFollowChild}) x_id_text,
    ) {
      return <Map<String, List<Object>>>[
        setFields('username', <SqliteType>[SqliteType.TEXT], 'String'),
        setFields('email', <SqliteType>[SqliteType.TEXT], 'String'),
      ];
    },
  );
}

void f_uploads() {
  CreateModel(
    tableNameWithS: TableNames.uploads,
    createFields: (
      Map<String, List<Object>> Function(String, List<SqliteType>, String) setFields,
      Map<String, List<Object>> Function(String, String?, {required bool isDeleteChildFollowFather, required bool isDeleteFatherFollowChild}) x_id_integer,
      Map<String, List<Object>> Function(String, String?, {required bool isDeleteChildFollowFather, required bool isDeleteFatherFollowChild}) x_id_text,
    ) {
      return <Map<String, List<Object>>>[
        setFields('table_name', <SqliteType>[SqliteType.TEXT], 'String'),
        x_id_integer('row_id', null, isDeleteChildFollowFather: false, isDeleteFatherFollowChild: false),
        x_id_integer('row_atid', null, isDeleteChildFollowFather: false, isDeleteFatherFollowChild: false),
        x_id_text('row_uuid', null, isDeleteChildFollowFather: false, isDeleteFatherFollowChild: false),
        setFields('updated_columns', <SqliteType>[SqliteType.TEXT], 'String'),
        setFields('curd_status', <SqliteType>[SqliteType.INTEGER], 'CurdStatus'),
        setFields('upload_status', <SqliteType>[SqliteType.INTEGER], 'UploadStatus'),
      ];
    },
    createExtraEnums: (String Function(String, List<String>) setExtraEnumMembers) {
      return <String>[
        setExtraEnumMembers('UploadStatus', <String>['notUploaded', 'uploading', 'uploaded'])
      ];
    },
    extraGlobalEnum: true,
  );
}

void f_download_modules() {
  CreateModel(
    tableNameWithS: TableNames.download_modules,
    createFields: (
      Map<String, List<Object>> Function(String, List<SqliteType>, String) setFields,
      Map<String, List<Object>> Function(String, String?, {required bool isDeleteChildFollowFather, required bool isDeleteFatherFollowChild}) x_id_integer,
      Map<String, List<Object>> Function(String, String?, {required bool isDeleteChildFollowFather, required bool isDeleteFatherFollowChild}) x_id_text,
    ) {
      return <Map<String, List<Object>>>[
        setFields('module_name', <SqliteType>[SqliteType.TEXT], 'String'),
        setFields('download_status', <SqliteType>[SqliteType.INTEGER], 'SqliteDownloadStatus'),
      ];
    },
    createExtraEnums: (String Function(String, List<String>) setExtraEnumMembers) {
      return <String>[
        setExtraEnumMembers('SqliteDownloadStatus', <String>['downloaded', 'notDownload']),
      ];
    },
  );
}

void f_pn_pending_pool_nodes() {
  CreateModel(
    tableNameWithS: TableNames.pn_pending_pool_nodes,
    createFields: (
      Map<String, List<Object>> Function(String, List<SqliteType>, String) setFields,
      Map<String, List<Object>> Function(String, String?, {required bool isDeleteChildFollowFather, required bool isDeleteFatherFollowChild}) x_id_integer,
      Map<String, List<Object>> Function(String, String?, {required bool isDeleteChildFollowFather, required bool isDeleteFatherFollowChild}) x_id_text,
    ) {
      return <Map<String, List<Object>>>[
        x_id_integer('recommend_raw_rule_atid', TableNames.rules, isDeleteChildFollowFather: false, isDeleteFatherFollowChild: false),
        x_id_text('recommend_raw_rule_uuid', TableNames.rules, isDeleteChildFollowFather: false, isDeleteFatherFollowChild: false),
        setFields('type', <SqliteType>[SqliteType.INTEGER], 'PendingPoolNodeType'),
        setFields('name', <SqliteType>[SqliteType.TEXT], 'String'),
        setFields('position', <SqliteType>[SqliteType.TEXT], 'String'),
      ];
    },
    createExtraEnums: (String Function(String, List<String>) setExtraEnumMembers) {
      return <String>[
        setExtraEnumMembers('PendingPoolNodeType', <String>['ordinary']),
      ];
    },
  );
}

void f_pn_memory_pool_nodes() {
  CreateModel(
    tableNameWithS: TableNames.pn_memory_pool_nodes,
    createFields: (
      Map<String, List<Object>> Function(String, List<SqliteType>, String) setFields,
      Map<String, List<Object>> Function(String, String?, {required bool isDeleteChildFollowFather, required bool isDeleteFatherFollowChild}) x_id_integer,
      Map<String, List<Object>> Function(String, String?, {required bool isDeleteChildFollowFather, required bool isDeleteFatherFollowChild}) x_id_text,
    ) {
      return <Map<String, List<Object>>>[
        x_id_integer('using_raw_rule_atid', TableNames.rules, isDeleteChildFollowFather: false, isDeleteFatherFollowChild: false),
        x_id_text('using_raw_rule_uuid', TableNames.rules, isDeleteChildFollowFather: false, isDeleteFatherFollowChild: false),
        setFields('type', <SqliteType>[SqliteType.INTEGER], 'MemoryPoolNodeType'),
        setFields('name', <SqliteType>[SqliteType.TEXT], 'String'),
        setFields('position', <SqliteType>[SqliteType.TEXT], 'String'),
      ];
    },
    createExtraEnums: (String Function(String, List<String>) setExtraEnumMembers) {
      return <String>[
        setExtraEnumMembers('MemoryPoolNodeType', <String>['ordinary']),
      ];
    },
  );
}

void f_pn_complete_pool_nodes() {
  CreateModel(
    tableNameWithS: TableNames.pn_complete_pool_nodes,
    createFields: (
      Map<String, List<Object>> Function(String, List<SqliteType>, String) setFields,
      Map<String, List<Object>> Function(String, String?, {required bool isDeleteChildFollowFather, required bool isDeleteFatherFollowChild}) x_id_integer,
      Map<String, List<Object>> Function(String, String?, {required bool isDeleteChildFollowFather, required bool isDeleteFatherFollowChild}) x_id_text,
    ) {
      return <Map<String, List<Object>>>[
        x_id_integer('used_raw_rule_atid', TableNames.rules, isDeleteChildFollowFather: false, isDeleteFatherFollowChild: false),
        x_id_text('used_raw_rule_uuid', TableNames.rules, isDeleteChildFollowFather: false, isDeleteFatherFollowChild: false),
        setFields('type', <SqliteType>[SqliteType.INTEGER], 'CompletePoolNodeType'),
        setFields('name', <SqliteType>[SqliteType.TEXT], 'String'),
        setFields('position', <SqliteType>[SqliteType.TEXT], 'String'),
      ];
    },
    createExtraEnums: (String Function(String, List<String>) setExtraEnumMembers) {
      return <String>[
        setExtraEnumMembers('CompletePoolNodeType', <String>['ordinary']),
      ];
    },
  );
}

void f_pn_rule_pool_nodes() {
  CreateModel(
    tableNameWithS: TableNames.pn_rule_pool_nodes,
    createFields: (
      Map<String, List<Object>> Function(String, List<SqliteType>, String) setFields,
      Map<String, List<Object>> Function(String, String?, {required bool isDeleteChildFollowFather, required bool isDeleteFatherFollowChild}) x_id_integer,
      Map<String, List<Object>> Function(String, String?, {required bool isDeleteChildFollowFather, required bool isDeleteFatherFollowChild}) x_id_text,
    ) {
      return <Map<String, List<Object>>>[
        setFields('type', <SqliteType>[SqliteType.INTEGER], 'RulePoolNodeType'),
        setFields('name', <SqliteType>[SqliteType.TEXT], 'String'),
        setFields('position', <SqliteType>[SqliteType.TEXT], 'String'),
      ];
    },
    createExtraEnums: (String Function(String, List<String>) setExtraEnumMembers) {
      return <String>[
        setExtraEnumMembers('RulePoolNodeType', <String>['ordinary']),
      ];
    },
  );
}

void f_fragments_about_pending_pool_nodes() {
  CreateModel(
    tableNameWithS: TableNames.fragments_about_pending_pool_nodes,
    createFields: (
      Map<String, List<Object>> Function(String, List<SqliteType>, String) setFields,
      Map<String, List<Object>> Function(String, String?, {required bool isDeleteChildFollowFather, required bool isDeleteFatherFollowChild}) x_id_integer,
      Map<String, List<Object>> Function(String, String?, {required bool isDeleteChildFollowFather, required bool isDeleteFatherFollowChild}) x_id_text,
    ) {
      return <Map<String, List<Object>>>[
        x_id_integer('raw_fragment_atid', null, isDeleteChildFollowFather: false, isDeleteFatherFollowChild: false),
        x_id_text('raw_fragment_uuid', null, isDeleteChildFollowFather: false, isDeleteFatherFollowChild: false),
        x_id_integer('pn_pending_pool_node_atid', TableNames.pn_pending_pool_nodes, isDeleteChildFollowFather: false, isDeleteFatherFollowChild: true),
        x_id_text('pn_pending_pool_node_uuid', TableNames.pn_pending_pool_nodes, isDeleteChildFollowFather: false, isDeleteFatherFollowChild: true),
        x_id_integer('recommend_raw_rule_atid', TableNames.rules, isDeleteChildFollowFather: false, isDeleteFatherFollowChild: false),
        x_id_text('recommend_raw_rule_uuid', TableNames.rules, isDeleteChildFollowFather: false, isDeleteFatherFollowChild: false),
        setFields('title', <SqliteType>[SqliteType.TEXT], 'String'),
      ];
    },
  );
}

void f_fragments_about_memory_pool_nodes() {
  CreateModel(
    tableNameWithS: TableNames.fragments_about_memory_pool_nodes,
    createFields: (
      Map<String, List<Object>> Function(String, List<SqliteType>, String) setFields,
      Map<String, List<Object>> Function(String, String?, {required bool isDeleteChildFollowFather, required bool isDeleteFatherFollowChild}) x_id_integer,
      Map<String, List<Object>> Function(String, String?, {required bool isDeleteChildFollowFather, required bool isDeleteFatherFollowChild}) x_id_text,
    ) {
      return <Map<String, List<Object>>>[
        x_id_integer('fragments_about_pending_pool_node_atid', TableNames.fragments_about_pending_pool_nodes, isDeleteChildFollowFather: false, isDeleteFatherFollowChild: true),
        x_id_text('fragments_about_pending_pool_node_uuid', TableNames.fragments_about_pending_pool_nodes, isDeleteChildFollowFather: false, isDeleteFatherFollowChild: true),
        x_id_integer('using_raw_rule_atid', TableNames.rules, isDeleteChildFollowFather: false, isDeleteFatherFollowChild: false),
        x_id_text('using_raw_rule_uuid', TableNames.rules, isDeleteChildFollowFather: false, isDeleteFatherFollowChild: false),
        x_id_integer('pn_memory_pool_node_atid', TableNames.pn_memory_pool_nodes, isDeleteChildFollowFather: false, isDeleteFatherFollowChild: true),
        x_id_text('pn_memory_pool_node_uuid', TableNames.pn_memory_pool_nodes, isDeleteChildFollowFather: false, isDeleteFatherFollowChild: true),
      ];
    },
  );
}

void f_fragments_about_complete_pool_nodes() {
  CreateModel(
    tableNameWithS: TableNames.fragments_about_complete_pool_nodes,
    createFields: (
      Map<String, List<Object>> Function(String, List<SqliteType>, String) setFields,
      Map<String, List<Object>> Function(String, String?, {required bool isDeleteChildFollowFather, required bool isDeleteFatherFollowChild}) x_id_integer,
      Map<String, List<Object>> Function(String, String?, {required bool isDeleteChildFollowFather, required bool isDeleteFatherFollowChild}) x_id_text,
    ) {
      return <Map<String, List<Object>>>[
        x_id_integer('fragments_about_pending_pool_node_atid', TableNames.fragments_about_pending_pool_nodes, isDeleteChildFollowFather: false, isDeleteFatherFollowChild: true),
        x_id_text('fragments_about_pending_pool_node_uuid', TableNames.fragments_about_pending_pool_nodes, isDeleteChildFollowFather: false, isDeleteFatherFollowChild: true),
        x_id_integer('used_raw_rule_atid', TableNames.rules, isDeleteChildFollowFather: false, isDeleteFatherFollowChild: false),
        x_id_text('used_raw_rule_uuid', TableNames.rules, isDeleteChildFollowFather: false, isDeleteFatherFollowChild: false),
        x_id_integer('pn_complete_pool_node_atid', TableNames.pn_complete_pool_nodes, isDeleteChildFollowFather: false, isDeleteFatherFollowChild: true),
        x_id_text('pn_complete_pool_node_uuid', TableNames.pn_complete_pool_nodes, isDeleteChildFollowFather: false, isDeleteFatherFollowChild: true),
      ];
    },
  );
}

void f_rules() {
  CreateModel(
    tableNameWithS: TableNames.rules,
    createFields: (
      Map<String, List<Object>> Function(String, List<SqliteType>, String) setFields,
      Map<String, List<Object>> Function(String, String?, {required bool isDeleteChildFollowFather, required bool isDeleteFatherFollowChild}) x_id_integer,
      Map<String, List<Object>> Function(String, String?, {required bool isDeleteChildFollowFather, required bool isDeleteFatherFollowChild}) x_id_text,
    ) {
      return <Map<String, List<Object>>>[
        x_id_integer('raw_rule_atid', null, isDeleteChildFollowFather: false, isDeleteFatherFollowChild: false),
        x_id_text('raw_rule_uuid', null, isDeleteChildFollowFather: false, isDeleteFatherFollowChild: false),
        x_id_integer('pn_rule_pool_node_atid', TableNames.pn_rule_pool_nodes, isDeleteChildFollowFather: false, isDeleteFatherFollowChild: true),
        x_id_text('pn_rule_pool_node_uuid', TableNames.pn_rule_pool_nodes, isDeleteChildFollowFather: false, isDeleteFatherFollowChild: true),
      ];
    },
  );
}
