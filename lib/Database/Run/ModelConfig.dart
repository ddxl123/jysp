// ignore_for_file: non_constant_identifier_names
// ignore_for_file: camel_case_types
// ignore_for_file: avoid_classes_with_only_static_members
// ignore_for_file: unused_element
// ignore_for_file: unused_field

import 'package:jysp/Database/Run/Create.dart';
import 'package:jysp/Database/Run/FieldNameBase.dart';
import 'package:jysp/Database/Run/main.dart';

void runCreateModels() {
  _version_infos().createModel();
  _tokens().createModel();
  _users().createModel();
  _uploads().createModel();
  _download_modules().createModel();
  _pn_pending_pool_nodes().createModel();
  _pn_memory_pool_nodes().createModel();
  _pn_complete_pool_nodes().createModel();
  _pn_rule_pool_nodes().createModel();
  _fragments_about_pending_pool_nodes().createModel();
  _fragments_about_memory_pool_nodes().createModel();
  _fragments_about_complete_pool_nodes().createModel();
  _rules().createModel();
  createGlobalEnums(<List<String>>[
    <String>['CurdStatus', 'C', 'U', 'R', 'D'] // C:增，U:改，R:查(默认，即无)，D:删
  ]);
}

class _version_infos extends FieldBase {
  @override
  ModelCategory get modelCategory => ModelCategory.onlySqlite;

  @override
  String get tableNameWithS => 'version_infos';

  String saved_version = 'saved_version';

  @override
  List<Map<String, List<Object>>> get createFields => <Map<String, List<Object>>>[
        setField_normal(fieldName: saved_version, sqliteFieldTypes: <SqliteType>[SqliteType.TEXT], dartFieldType: 'String'),
      ];
}

class _tokens extends FieldBase {
  @override
  ModelCategory get modelCategory => ModelCategory.onlySqlite;

  @override
  String get tableNameWithS => 'tokens';

  String access_token = 'access_token';
  String refresh_token = 'refresh_token';

  @override
  List<Map<String, List<Object>>> get createFields => <Map<String, List<Object>>>[
        setField_normal(fieldName: access_token, sqliteFieldTypes: <SqliteType>[SqliteType.TEXT], dartFieldType: 'String'),
        setField_normal(fieldName: refresh_token, sqliteFieldTypes: <SqliteType>[SqliteType.TEXT], dartFieldType: 'String'),
      ];
}

class _users extends FieldBase {
  @override
  ModelCategory get modelCategory => ModelCategory.SqliteAndMysql;

  @override
  String get tableNameWithS => 'users';

  String username = 'username';
  String email = 'email';

  @override
  List<Map<String, List<Object>>> get createFields => <Map<String, List<Object>>>[
        setField_normal(fieldName: username, sqliteFieldTypes: <SqliteType>[SqliteType.TEXT], dartFieldType: 'String'),
        setField_normal(fieldName: email, sqliteFieldTypes: <SqliteType>[SqliteType.TEXT], dartFieldType: 'String'),
      ];
}

class _uploads extends FieldBase {
  @override
  ModelCategory get modelCategory => ModelCategory.onlySqlite;

  @override
  String get tableNameWithS => 'uploads';

  String table_name = 'table_name';
  String row_id = 'row_id';
  String row_aiid = 'row_aiid';
  String row_uuid = 'row_uuid';
  String updated_columns = 'updated_columns';
  String curd_status = 'curd_status';
  String upload_status = 'upload_status';

  @override
  bool? get extraGlobalEnum => true;

  @override
  List<String>? get createExtraEnums => <String>[
        setExtraEnumMembers('UploadStatus', <String>['notUploaded', 'uploading', 'uploaded'])
      ];

  @override
  List<Map<String, List<Object>>> get createFields => <Map<String, List<Object>>>[
        setField_normal(fieldName: table_name, sqliteFieldTypes: <SqliteType>[SqliteType.TEXT], dartFieldType: 'String'),
        setField_x_any_integer(fieldName: row_id, foreignKeyColumnNameWithTableName: null, isDeleteForeignKeyFollowCurrent: false, isDeleteCurrentFollowForeignKey: false),
        setField_x_aiid_integer(fieldName: row_aiid, foreignKeyColumnNameWithTableName: null, isDeleteForeignKeyFollowCurrent: false, isDeleteCurrentFollowForeignKey: false),
        setField_x_uuid_text(fieldName: row_uuid, foreignKeyColumnNameWithTableName: null, isDeleteForeignKeyFollowCurrent: false, isDeleteCurrentFollowForeignKey: false),
        setField_normal(fieldName: updated_columns, sqliteFieldTypes: <SqliteType>[SqliteType.TEXT], dartFieldType: 'String'),
        setField_normal(fieldName: curd_status, sqliteFieldTypes: <SqliteType>[SqliteType.INTEGER], dartFieldType: 'CurdStatus'),
        setField_normal(fieldName: upload_status, sqliteFieldTypes: <SqliteType>[SqliteType.INTEGER], dartFieldType: 'UploadStatus'),
      ];
}

class _download_modules extends FieldBase {
  @override
  ModelCategory get modelCategory => ModelCategory.onlySqlite;

  @override
  String get tableNameWithS => 'download_modules';

  String module_name = 'module_name';
  String download_status = 'download_status';

  @override
  List<String>? get createExtraEnums => <String>[
        setExtraEnumMembers('SqliteDownloadStatus', <String>['downloaded', 'notDownload']),
      ];

  @override
  List<Map<String, List<Object>>> get createFields => <Map<String, List<Object>>>[
        setField_normal(fieldName: module_name, sqliteFieldTypes: <SqliteType>[SqliteType.TEXT], dartFieldType: 'String'),
        setField_normal(fieldName: download_status, sqliteFieldTypes: <SqliteType>[SqliteType.INTEGER], dartFieldType: 'SqliteDownloadStatus'),
      ];
}

class _pn_pending_pool_nodes extends FieldBase {
  @override
  ModelCategory get modelCategory => ModelCategory.SqliteAndMysql;

  @override
  String get tableNameWithS => 'pn_pending_pool_nodes';

  String recommend_raw_rule_aiid = 'recommend_raw_rule_aiid';
  String recommend_raw_rule_uuid = 'recommend_raw_rule_uuid';
  String type = 'type';
  String name = 'name';
  String position = 'position';

  @override
  List<String>? get createExtraEnums => <String>[
        setExtraEnumMembers('PendingPoolNodeType', <String>['ordinary']),
      ];

  @override
  List<Map<String, List<Object>>> get createFields => <Map<String, List<Object>>>[
        setField_x_aiid_integer(
          fieldName: recommend_raw_rule_aiid,
          foreignKeyColumnNameWithTableName: toCombine(_rules().tableNameWithS, _rules().aiid),
          isDeleteForeignKeyFollowCurrent: false,
          isDeleteCurrentFollowForeignKey: false,
        ),
        setField_x_uuid_text(
          fieldName: recommend_raw_rule_uuid,
          foreignKeyColumnNameWithTableName: toCombine(_rules().tableNameWithS, _rules().uuid),
          isDeleteForeignKeyFollowCurrent: false,
          isDeleteCurrentFollowForeignKey: false,
        ),
        setField_normal(fieldName: type, sqliteFieldTypes: <SqliteType>[SqliteType.INTEGER], dartFieldType: 'PendingPoolNodeType'),
        setField_normal(fieldName: name, sqliteFieldTypes: <SqliteType>[SqliteType.TEXT], dartFieldType: 'String'),
        setField_normal(fieldName: position, sqliteFieldTypes: <SqliteType>[SqliteType.TEXT], dartFieldType: 'String'),
      ];
}

class _pn_memory_pool_nodes extends FieldBase {
  @override
  ModelCategory get modelCategory => ModelCategory.SqliteAndMysql;

  @override
  String get tableNameWithS => 'pn_memory_pool_nodes';

  String using_raw_rule_aiid = 'using_raw_rule_aiid';
  String using_raw_rule_uuid = 'using_raw_rule_uuid';
  String type = 'type';
  String name = 'name';
  String position = 'position';

  @override
  List<String>? get createExtraEnums => <String>[
        setExtraEnumMembers('MemoryPoolNodeType', <String>['ordinary']),
      ];

  @override
  List<Map<String, List<Object>>> get createFields => <Map<String, List<Object>>>[
        setField_x_aiid_integer(
          fieldName: using_raw_rule_aiid,
          foreignKeyColumnNameWithTableName: toCombine(_rules().tableNameWithS, _rules().aiid),
          isDeleteForeignKeyFollowCurrent: false,
          isDeleteCurrentFollowForeignKey: false,
        ),
        setField_x_uuid_text(
          fieldName: using_raw_rule_uuid,
          foreignKeyColumnNameWithTableName: toCombine(_rules().tableNameWithS, _rules().uuid),
          isDeleteForeignKeyFollowCurrent: false,
          isDeleteCurrentFollowForeignKey: false,
        ),
        setField_normal(fieldName: type, sqliteFieldTypes: <SqliteType>[SqliteType.INTEGER], dartFieldType: 'MemoryPoolNodeType'),
        setField_normal(fieldName: name, sqliteFieldTypes: <SqliteType>[SqliteType.TEXT], dartFieldType: 'String'),
        setField_normal(fieldName: position, sqliteFieldTypes: <SqliteType>[SqliteType.TEXT], dartFieldType: 'String'),
      ];
}

class _pn_complete_pool_nodes extends FieldBase {
  @override
  ModelCategory get modelCategory => ModelCategory.SqliteAndMysql;

  @override
  String get tableNameWithS => 'pn_complete_pool_nodes';

  String used_raw_rule_aiid = 'used_raw_rule_aiid';
  String used_raw_rule_uuid = 'used_raw_rule_uuid';
  String type = 'type';
  String name = 'name';
  String position = 'position';

  @override
  List<String>? get createExtraEnums => <String>[
        setExtraEnumMembers('CompletePoolNodeType', <String>['ordinary']),
      ];

  @override
  List<Map<String, List<Object>>> get createFields => <Map<String, List<Object>>>[
        setField_x_aiid_integer(
          fieldName: used_raw_rule_aiid,
          foreignKeyColumnNameWithTableName: toCombine(_rules().tableNameWithS, _rules().aiid),
          isDeleteForeignKeyFollowCurrent: false,
          isDeleteCurrentFollowForeignKey: false,
        ),
        setField_x_uuid_text(
          fieldName: used_raw_rule_uuid,
          foreignKeyColumnNameWithTableName: toCombine(_rules().tableNameWithS, _rules().uuid),
          isDeleteForeignKeyFollowCurrent: false,
          isDeleteCurrentFollowForeignKey: false,
        ),
        setField_normal(fieldName: type, sqliteFieldTypes: <SqliteType>[SqliteType.INTEGER], dartFieldType: 'CompletePoolNodeType'),
        setField_normal(fieldName: name, sqliteFieldTypes: <SqliteType>[SqliteType.TEXT], dartFieldType: 'String'),
        setField_normal(fieldName: position, sqliteFieldTypes: <SqliteType>[SqliteType.TEXT], dartFieldType: 'String'),
      ];
}

class _pn_rule_pool_nodes extends FieldBase {
  @override
  ModelCategory get modelCategory => ModelCategory.SqliteAndMysql;

  @override
  String get tableNameWithS => 'pn_rule_pool_nodes';

  String type = 'type';
  String name = 'name';
  String position = 'position';

  @override
  List<String>? get createExtraEnums => <String>[
        setExtraEnumMembers('RulePoolNodeType', <String>['ordinary']),
      ];

  @override
  List<Map<String, List<Object>>> get createFields => <Map<String, List<Object>>>[
        setField_normal(fieldName: type, sqliteFieldTypes: <SqliteType>[SqliteType.INTEGER], dartFieldType: 'RulePoolNodeType'),
        setField_normal(fieldName: name, sqliteFieldTypes: <SqliteType>[SqliteType.TEXT], dartFieldType: 'String'),
        setField_normal(fieldName: position, sqliteFieldTypes: <SqliteType>[SqliteType.TEXT], dartFieldType: 'String'),
      ];
}

class _fragments_about_pending_pool_nodes extends FieldBase {
  @override
  ModelCategory get modelCategory => ModelCategory.SqliteAndMysql;

  @override
  String get tableNameWithS => 'fragments_about_pending_pool_nodes';

  String raw_fragment_aiid = 'raw_fragment_aiid';
  String raw_fragment_uuid = 'raw_fragment_uuid';
  String pn_pending_pool_node_aiid = 'pn_pending_pool_node_aiid';
  String pn_pending_pool_node_uuid = 'pn_pending_pool_node_uuid';
  String recommend_raw_rule_aiid = 'recommend_raw_rule_aiid';
  String recommend_raw_rule_uuid = 'recommend_raw_rule_uuid';
  String title = 'title';

  @override
  List<Map<String, List<Object>>> get createFields => <Map<String, List<Object>>>[
        setField_x_aiid_integer(
          fieldName: raw_fragment_aiid,
          foreignKeyColumnNameWithTableName: null,
          isDeleteForeignKeyFollowCurrent: false,
          isDeleteCurrentFollowForeignKey: false,
        ),
        setField_x_uuid_text(
          fieldName: raw_fragment_uuid,
          foreignKeyColumnNameWithTableName: null,
          isDeleteForeignKeyFollowCurrent: false,
          isDeleteCurrentFollowForeignKey: false,
        ),
        setField_x_aiid_integer(
          fieldName: pn_pending_pool_node_aiid,
          foreignKeyColumnNameWithTableName: toCombine(_pn_pending_pool_nodes().tableNameWithS, _pn_pending_pool_nodes().aiid),
          isDeleteForeignKeyFollowCurrent: false,
          isDeleteCurrentFollowForeignKey: true,
        ),
        setField_x_uuid_text(
          fieldName: pn_pending_pool_node_uuid,
          foreignKeyColumnNameWithTableName: toCombine(_pn_pending_pool_nodes().tableNameWithS, _pn_pending_pool_nodes().uuid),
          isDeleteForeignKeyFollowCurrent: false,
          isDeleteCurrentFollowForeignKey: true,
        ),
        setField_x_aiid_integer(
          fieldName: recommend_raw_rule_aiid,
          foreignKeyColumnNameWithTableName: toCombine(_rules().tableNameWithS, _rules().aiid),
          isDeleteForeignKeyFollowCurrent: false,
          isDeleteCurrentFollowForeignKey: false,
        ),
        setField_x_uuid_text(
          fieldName: recommend_raw_rule_uuid,
          foreignKeyColumnNameWithTableName: toCombine(_rules().tableNameWithS, _rules().uuid),
          isDeleteForeignKeyFollowCurrent: false,
          isDeleteCurrentFollowForeignKey: false,
        ),
        setField_normal(fieldName: title, sqliteFieldTypes: <SqliteType>[SqliteType.TEXT], dartFieldType: 'String'),
      ];
}

class _fragments_about_memory_pool_nodes extends FieldBase {
  @override
  ModelCategory get modelCategory => ModelCategory.SqliteAndMysql;

  @override
  String get tableNameWithS => 'fragments_about_memory_pool_nodes';

  String fragments_about_pending_pool_node_aiid = 'fragments_about_pending_pool_node_aiid';
  String fragments_about_pending_pool_node_uuid = 'fragments_about_pending_pool_node_uuid';
  String using_raw_rule_aiid = 'using_raw_rule_aiid';
  String using_raw_rule_uuid = 'using_raw_rule_uuid';
  String pn_memory_pool_node_aiid = 'pn_memory_pool_node_aiid';
  String pn_memory_pool_node_uuid = 'pn_memory_pool_node_uuid';

  @override
  List<Map<String, List<Object>>> get createFields => <Map<String, List<Object>>>[
        setField_x_aiid_integer(
          fieldName: fragments_about_pending_pool_node_aiid,
          foreignKeyColumnNameWithTableName: toCombine(_fragments_about_pending_pool_nodes().tableNameWithS, _fragments_about_pending_pool_nodes().aiid),
          isDeleteForeignKeyFollowCurrent: false,
          isDeleteCurrentFollowForeignKey: true,
        ),
        setField_x_uuid_text(
          fieldName: fragments_about_pending_pool_node_uuid,
          foreignKeyColumnNameWithTableName: toCombine(_fragments_about_pending_pool_nodes().tableNameWithS, _fragments_about_pending_pool_nodes().uuid),
          isDeleteForeignKeyFollowCurrent: false,
          isDeleteCurrentFollowForeignKey: true,
        ),
        setField_x_aiid_integer(
          fieldName: using_raw_rule_aiid,
          foreignKeyColumnNameWithTableName: toCombine(_rules().tableNameWithS, _rules().aiid),
          isDeleteForeignKeyFollowCurrent: false,
          isDeleteCurrentFollowForeignKey: false,
        ),
        setField_x_uuid_text(
          fieldName: using_raw_rule_uuid,
          foreignKeyColumnNameWithTableName: toCombine(_rules().tableNameWithS, _rules().uuid),
          isDeleteForeignKeyFollowCurrent: false,
          isDeleteCurrentFollowForeignKey: false,
        ),
        setField_x_aiid_integer(
          fieldName: pn_memory_pool_node_aiid,
          foreignKeyColumnNameWithTableName: toCombine(_pn_memory_pool_nodes().tableNameWithS, _pn_memory_pool_nodes().aiid),
          isDeleteForeignKeyFollowCurrent: false,
          isDeleteCurrentFollowForeignKey: true,
        ),
        setField_x_uuid_text(
          fieldName: pn_memory_pool_node_uuid,
          foreignKeyColumnNameWithTableName: toCombine(_pn_memory_pool_nodes().tableNameWithS, _pn_memory_pool_nodes().uuid),
          isDeleteForeignKeyFollowCurrent: false,
          isDeleteCurrentFollowForeignKey: true,
        ),
      ];
}

class _fragments_about_complete_pool_nodes extends FieldBase {
  @override
  ModelCategory get modelCategory => ModelCategory.SqliteAndMysql;

  @override
  String get tableNameWithS => 'fragments_about_complete_pool_nodes';

  String fragments_about_pending_pool_node_aiid = 'fragments_about_pending_pool_node_aiid';
  String fragments_about_pending_pool_node_uuid = 'fragments_about_pending_pool_node_uuid';
  String used_raw_rule_aiid = 'used_raw_rule_aiid';
  String used_raw_rule_uuid = 'used_raw_rule_uuid';
  String pn_complete_pool_node_aiid = 'pn_complete_pool_node_aiid';
  String pn_complete_pool_node_uuid = 'pn_complete_pool_node_uuid';

  @override
  List<Map<String, List<Object>>> get createFields => <Map<String, List<Object>>>[
        setField_x_aiid_integer(
          fieldName: fragments_about_pending_pool_node_aiid,
          foreignKeyColumnNameWithTableName: toCombine(_fragments_about_pending_pool_nodes().tableNameWithS, _fragments_about_pending_pool_nodes().aiid),
          isDeleteForeignKeyFollowCurrent: false,
          isDeleteCurrentFollowForeignKey: true,
        ),
        setField_x_uuid_text(
          fieldName: fragments_about_pending_pool_node_uuid,
          foreignKeyColumnNameWithTableName: toCombine(_fragments_about_pending_pool_nodes().tableNameWithS, _fragments_about_pending_pool_nodes().uuid),
          isDeleteForeignKeyFollowCurrent: false,
          isDeleteCurrentFollowForeignKey: true,
        ),
        setField_x_aiid_integer(
          fieldName: used_raw_rule_aiid,
          foreignKeyColumnNameWithTableName: toCombine(_rules().tableNameWithS, _rules().aiid),
          isDeleteForeignKeyFollowCurrent: false,
          isDeleteCurrentFollowForeignKey: false,
        ),
        setField_x_uuid_text(
          fieldName: used_raw_rule_uuid,
          foreignKeyColumnNameWithTableName: toCombine(_rules().tableNameWithS, _rules().uuid),
          isDeleteForeignKeyFollowCurrent: false,
          isDeleteCurrentFollowForeignKey: false,
        ),
        setField_x_aiid_integer(
          fieldName: pn_complete_pool_node_aiid,
          foreignKeyColumnNameWithTableName: toCombine(_pn_complete_pool_nodes().tableNameWithS, _pn_complete_pool_nodes().aiid),
          isDeleteForeignKeyFollowCurrent: false,
          isDeleteCurrentFollowForeignKey: true,
        ),
        setField_x_uuid_text(
          fieldName: pn_complete_pool_node_uuid,
          foreignKeyColumnNameWithTableName: toCombine(_pn_complete_pool_nodes().tableNameWithS, _pn_complete_pool_nodes().uuid),
          isDeleteForeignKeyFollowCurrent: false,
          isDeleteCurrentFollowForeignKey: true,
        ),
      ];
}

class _rules extends FieldBase {
  @override
  ModelCategory get modelCategory => ModelCategory.SqliteAndMysql;

  @override
  String get tableNameWithS => 'rules';

  String raw_rule_aiid = 'raw_rule_aiid';
  String raw_rule_uuid = 'raw_rule_uuid';
  String pn_rule_pool_node_aiid = 'pn_rule_pool_node_aiid';
  String pn_rule_pool_node_uuid = 'pn_rule_pool_node_uuid';

  @override
  List<Map<String, List<Object>>> get createFields => <Map<String, List<Object>>>[
        setField_x_aiid_integer(
          fieldName: raw_rule_aiid,
          foreignKeyColumnNameWithTableName: null,
          isDeleteForeignKeyFollowCurrent: false,
          isDeleteCurrentFollowForeignKey: false,
        ),
        setField_x_uuid_text(
          fieldName: raw_rule_uuid,
          foreignKeyColumnNameWithTableName: null,
          isDeleteForeignKeyFollowCurrent: false,
          isDeleteCurrentFollowForeignKey: false,
        ),
        setField_x_aiid_integer(
          fieldName: pn_rule_pool_node_aiid,
          foreignKeyColumnNameWithTableName: toCombine(_pn_rule_pool_nodes().tableNameWithS, _pn_rule_pool_nodes().aiid),
          isDeleteForeignKeyFollowCurrent: false,
          isDeleteCurrentFollowForeignKey: true,
        ),
        setField_x_uuid_text(
          fieldName: pn_rule_pool_node_uuid,
          foreignKeyColumnNameWithTableName: toCombine(_pn_rule_pool_nodes().tableNameWithS, _pn_rule_pool_nodes().uuid),
          isDeleteForeignKeyFollowCurrent: false,
          isDeleteCurrentFollowForeignKey: true,
        ),
      ];
}
