// ignore_for_file: non_constant_identifier_names

import 'package:jysp/Database/base/DBTableBase.dart';
import 'package:jysp/Database/base/SqliteType.dart';

class MVersionInfo implements DBTableBase {
  @override
  String getTableNameInstance = getTableName;

  static String get getTableName => "version_infos";

  static String get saved_version => "saved_version";

  static String get created_at => "created_at";

  static String get updated_at => "updated_at";

  @override
  Map<String, List<SqliteType>> get fields => {saved_version: [SqliteType.TEXT], created_at: [SqliteType.INTEGER, SqliteType.UNSIGNED, SqliteType.NOT_NULL], updated_at: [SqliteType.INTEGER, SqliteType.UNSIGNED, SqliteType.NOT_NULL]};

  static Map<String, dynamic> toMap({required String saved_version_v,required int created_at_v,required int updated_at_v,}
  ) {
    return {saved_version:saved_version_v,created_at:created_at_v,updated_at:updated_at_v,};
  }
}
