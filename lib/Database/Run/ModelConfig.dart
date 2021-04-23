// ignore_for_file: non_constant_identifier_names

import 'package:jysp/Database/Run/main.dart';

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
  createGlobalEnums(<List<String>>[
    <String>['CurdStatus', 'C', 'U', 'R', 'D'] // C:增，U:改，R:查(默认，即无)，D:删
  ]);
}

void version_infos() {
  createModel(
    tableNameWithS: 'version_infos',
    createField: createFields(
      fields: <String, List<Object>>{
        'saved_version': setFieldTypes(<Object>[SqliteType.TEXT], 'String'),
      },
    ),
  );
}

void tokens() {
  createModel(
    tableNameWithS: 'tokens',
    createField: createFields(
      fields: <String, List<Object>>{
        'access_token': setFieldTypes(<Object>[SqliteType.TEXT], 'String'),
        'refresh_token': setFieldTypes(<Object>[SqliteType.TEXT], 'String'),
      },
    ),
  );
}

void users() {
  createModel(
    tableNameWithS: 'users',
    createField: createFields(
      fields: <String, List<Object>>{
        'username': setFieldTypes(<Object>[SqliteType.TEXT], 'String'),
        'email': setFieldTypes(<Object>[SqliteType.TEXT], 'String'),
      },
    ),
  );
}

void uploads() {
  createModel(
    tableNameWithS: 'uploads',
    createField: createFields(
      fields: <String, List<Object>>{
        'table_name': setFieldTypes(<Object>[SqliteType.TEXT], 'String'),
        'row_id': x_id_integer(),
        'row_atid': x_id_integer(),
        'row_uuid': x_id_text(),
        'updated_columns': setFieldTypes(<Object>[SqliteType.TEXT], 'String'),
        'curd_status': setFieldTypes(<Object>[SqliteType.INTEGER], 'CurdStatus'),
        'upload_status': setFieldTypes(<Object>[SqliteType.INTEGER], 'UploadStatus')
      },
    ),
    extraEnum: createExtraEnums(
      <String>[
        setExtraEnumMembers(enumTypeName: 'UploadStatus', members: <String>['notUploaded', 'uploading', 'uploaded']),
      ],
    ),
    extraGlobalEnum: true,
  );
}

void download_modules() {
  createModel(
    tableNameWithS: 'download_modules',
    createField: createFields(
      fields: <String, List<Object>>{
        'module_name': setFieldTypes(<Object>[SqliteType.TEXT], 'String'),
        'download_status': setFieldTypes(<Object>[SqliteType.INTEGER], 'SqliteDownloadStatus'),
      },
    ),
    extraEnum: createExtraEnums(
      <String>[
        setExtraEnumMembers(enumTypeName: 'SqliteDownloadStatus', members: <String>['downloaded', 'notDownload']),
      ],
    ),
  );
}

void pn_pending_pool_nodes() {
  createModel(
    tableNameWithS: 'pn_pending_pool_nodes',
    createField: createFields(
      fields: <String, List<Object>>{
        'recommend_raw_rule_atid': x_id_integer(),
        'recommend_raw_rule_uuid': x_id_text(),
        'type': setFieldTypes(<Object>[SqliteType.INTEGER], 'PendingPoolNodeType'),
        'name': setFieldTypes(<Object>[SqliteType.TEXT], 'String'),
        'position': setFieldTypes(<Object>[SqliteType.TEXT], 'String'),
      },
    ),
    extraEnum: createExtraEnums(
      <String>[
        setExtraEnumMembers(enumTypeName: 'PendingPoolNodeType', members: <String>['ordinary']),
      ],
    ),
  );
}

void pn_memory_pool_nodes() {
  createModel(
    tableNameWithS: 'pn_memory_pool_nodes',
    createField: createFields(
      fields: <String, List<Object>>{
        'using_raw_rule_atid': x_id_integer(),
        'using_raw_rule_uuid': x_id_text(),
        'type': setFieldTypes(<Object>[SqliteType.INTEGER], 'MemoryPoolNodeType'),
        'name': setFieldTypes(<Object>[SqliteType.TEXT], 'String'),
        'position': setFieldTypes(<Object>[SqliteType.TEXT], 'String'),
      },
    ),
    extraEnum: createExtraEnums(
      <String>[
        setExtraEnumMembers(enumTypeName: 'MemoryPoolNodeType', members: <String>['ordinary']),
      ],
    ),
  );
}

void pn_complete_pool_nodes() {
  createModel(
    tableNameWithS: 'pn_complete_pool_nodes',
    createField: createFields(
      fields: <String, List<Object>>{
        'used_raw_rule_atid': x_id_integer(),
        'used_raw_rule_uuid': x_id_text(),
        'type': setFieldTypes(<Object>[SqliteType.INTEGER], 'CompletePoolNodeType'),
        'name': setFieldTypes(<Object>[SqliteType.TEXT], 'String'),
        'position': setFieldTypes(<Object>[SqliteType.TEXT], 'String'),
      },
    ),
    extraEnum: createExtraEnums(
      <String>[
        setExtraEnumMembers(enumTypeName: 'CompletePoolNodeType', members: <String>['ordinary']),
      ],
    ),
  );
}

void pn_rule_pool_nodes() {
  createModel(
    tableNameWithS: 'pn_rule_pool_nodes',
    createField: createFields(
      fields: <String, List<Object>>{
        'type': setFieldTypes(<Object>[SqliteType.INTEGER], 'RulePoolNodeType'),
        'name': setFieldTypes(<Object>[SqliteType.TEXT], 'String'),
        'position': setFieldTypes(<Object>[SqliteType.TEXT], 'String'),
      },
    ),
    extraEnum: createExtraEnums(
      <String>[
        setExtraEnumMembers(enumTypeName: 'RulePoolNodeType', members: <String>['ordinary']),
      ],
    ),
  );
}

void fragments_about_pending_pool_nodes() {
  createModel(
    tableNameWithS: 'fragments_about_pending_pool_nodes',
    createField: createFields(
      fields: <String, List<Object>>{
        'raw_fragment_atid': x_id_integer(),
        'raw_fragment_id_uuid': x_id_text(),
        'pn_pending_pool_node_atid': x_id_integer(),
        'pn_pending_pool_node_uuid': x_id_text(),
        'recommend_raw_rule_atid': x_id_integer(),
        'recommend_raw_rule_uuid': x_id_text(),
        'title': setFieldTypes(<Object>[SqliteType.TEXT], 'String'),
      },
    ),
  );
}

void fragments_about_memory_pool_nodes() {
  createModel(
    tableNameWithS: 'fragments_about_memory_pool_nodes',
    createField: createFields(
      fields: <String, List<Object>>{
        'fragments_about_pending_pool_node_atid': x_id_integer(),
        'fragments_about_pending_pool_node_uuid': x_id_text(),
        'using_raw_rule_atid': x_id_integer(),
        'using_raw_rule_uuid': x_id_text(),
        'pn_memory_pool_node_atid': x_id_integer(),
        'pn_memory_pool_node_uuid': x_id_text(),
      },
    ),
  );
}

void fragments_about_complete_pool_nodes() {
  createModel(
    tableNameWithS: 'fragments_about_complete_pool_nodes',
    createField: createFields(
      fields: <String, List<Object>>{
        'fragments_about_pending_pool_node_atid': x_id_integer(),
        'fragments_about_pending_pool_node_uuid': x_id_text(),
        'used_raw_rule_atid': x_id_integer(),
        'used_raw_rule_uuid': x_id_text(),
        'pn_complete_pool_node_atid': x_id_integer(),
        'pn_complete_pool_node_uuid': x_id_text(),
      },
    ),
  );
}

void rules() {
  createModel(
    tableNameWithS: 'rules',
    createField: createFields(
      fields: <String, List<Object>>{
        'raw_rule_atid': x_id_integer(),
        'raw_rule_uuid': x_id_text(),
        'pn_rule_pool_node_atid': x_id_integer(),
        'pn_rule_pool_node_uuid': x_id_text(),
      },
    ),
  );
}
