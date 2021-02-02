// ignore_for_file: non_constant_identifier_names

import 'package:jysp/Table/TableBase.dart';

class TUsers implements Table {
  @override
  String getTableNameInstance = getTableName;

  static String get getTableName => "users";

  static String get user_id_m => "user_id_m";

  static String get user_id_s => "user_id_m";

  static String get username => "username";

  static String get qq_email => "qq_email";

  static String get password => "password";

  static String get created_at => Table.created_at;

  static String get updated_at => Table.updated_at;

  @override
  List<List<dynamic>> get fields => [
        Table.x_id_ms_sql(user_id_m),
        Table.x_id_ms_sql(user_id_s),
        [username, SqliteType.TEXT, SqliteType.NOT_NULL], // mysql:CHAR(20) 不为空 默认:随机
        [password, SqliteType.TEXT, SqliteType.NOT_NULL], // mysql:CHAR(20) 不为空 默认:随机
        [qq_email, SqliteType.TEXT], // mysql:CHAR(20) 可为空
        Table.created_at_sql,
        Table.updated_at_sql,
      ];

  static Map<String, dynamic> toMap(
    String user_id_m_v,
    String user_id_s_v,
    String username_v,
    String qq_email_v,
    String password_v,
    int created_at_v,
    int updated_at_v,
  ) {
    return {
      user_id_m: user_id_m_v,
      user_id_s: user_id_s_v,
      username: username_v,
      qq_email: qq_email_v,
      password: password_v,
      created_at: created_at_v,
      updated_at: updated_at_v,
    };
  }
}
