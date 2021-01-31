import 'package:jysp/Table/TableBase.dart';

class TUsers implements Table {
  @override
  String getTableNameInstance = getTableName;

  @override
  List<List<dynamic>> get fields => [
        [username, SqliteType.TEXT],
        [qq_email, SqliteType.TEXT],
        [password, SqliteType.TEXT],
      ];

  static String get getTableName => "users";

  static String get username => "username";

  // ignore: non_constant_identifier_names
  static String get qq_email => "qq_email";

  static String get password => "password";

  // ignore: non_constant_identifier_names
  static Map<String, dynamic> toMap(String username_v, String qq_email_v, String password_v) {
    return {
      username: username_v,
      qq_email: qq_email_v,
      password: password_v,
    };
  }
}
