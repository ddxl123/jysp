// ignore_for_file: non_constant_identifier_names

import 'package:jysp/Database/DBTableBase.dart';

class TUser implements DBTableBase {
  @override
  String getTableNameInstance = getTableName;

  static String get getTableName => "users";

  static String get user_id => "user_id";

  static String get username => "username";

  static String get email => "email";

  static String get password => "password";

  static String get created_at => DBTableBase.created_at;

  static String get updated_at => DBTableBase.updated_at;

  @override
  List<List<dynamic>> get fields => [
        DBTableBase.x_id_m_no_primary(user_id),
        [username, SqliteType.TEXT, SqliteType.NOT_NULL], // mysql:CHAR(100) 不为空 默认:null
        [password, SqliteType.TEXT, SqliteType.NOT_NULL], // mysql:CHAR(100) 不为空 默认:uuid4
        [email, SqliteType.TEXT], // mysql:CHAR(100) 可为空 唯一 默认:null
        DBTableBase.created_at_sql,
        DBTableBase.updated_at_sql,
      ];

  static Map<String, dynamic> toMap(
    String user_id_v,
    String username_v,
    String email_v,
    String password_v,
    int created_at_v,
    int updated_at_v,
  ) {
    return {
      user_id: user_id_v,
      username: username_v,
      email: email_v,
      password: password_v,
      created_at: created_at_v,
      updated_at: updated_at_v,
    };
  }
}
