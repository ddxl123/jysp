// ignore_for_file: non_constant_identifier_names

import 'package:jysp/Database/base/DBTableBase.dart';
import 'package:jysp/Database/base/SqliteType.dart';

class MDownloadModule implements DBTableBase {
  @override
  String getTableNameInstance = getTableName;

  static String get getTableName => "download_modules";

  static String get module_name => "module_name";

  static String get download_is_ok => "download_is_ok";

  static String get created_at => "created_at";

  static String get updated_at => "updated_at";

  @override
  Map<String, List<SqliteType>> get fields => {module_name: [SqliteType.TEXT], download_is_ok: [SqliteType.INTEGER], created_at: [SqliteType.INTEGER, SqliteType.UNSIGNED, SqliteType.NOT_NULL], updated_at: [SqliteType.INTEGER, SqliteType.UNSIGNED, SqliteType.NOT_NULL]};

  static Map<String, dynamic> toMap({required String module_name_v,required int download_is_ok_v,required int created_at_v,required int updated_at_v,}
  ) {
    return {module_name:module_name_v,download_is_ok:download_is_ok_v,created_at:created_at_v,updated_at:updated_at_v,};
  }
}
