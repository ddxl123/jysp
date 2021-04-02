// ignore_for_file: non_constant_identifier_names

import 'package:jysp/Database/base/DBTableBase.dart';
import 'package:jysp/Database/base/SqliteType.dart';

class MToken implements DBTableBase {
  @override
  String getTableNameInstance = getTableName;

  static String get getTableName => "tokens";

  static String get access_token => "access_token";

  static String get refresh_token => "refresh_token";

  static String get created_at => "created_at";

  static String get updated_at => "updated_at";

  @override
  Map<String, List<SqliteType>> get fields => {access_token: [SqliteType.INTEGER, SqliteType.UNSIGNED], refresh_token: [SqliteType.TEXT], created_at: [SqliteType.INTEGER, SqliteType.UNSIGNED, SqliteType.NOT_NULL], updated_at: [SqliteType.INTEGER, SqliteType.UNSIGNED, SqliteType.NOT_NULL]};

  static Map<String, dynamic> toMap({required int access_token_v,required String refresh_token_v,required int created_at_v,required int updated_at_v,}
  ) {
    return {access_token:access_token_v,refresh_token:refresh_token_v,created_at:created_at_v,updated_at:updated_at_v,};
  }
}
