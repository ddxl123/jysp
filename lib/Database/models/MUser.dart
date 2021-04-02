// ignore_for_file: non_constant_identifier_names

import 'package:jysp/Database/base/DBTableBase.dart';
import 'package:jysp/Database/base/SqliteType.dart';

class MUser implements DBTableBase {
  @override
  String getTableNameInstance = getTableName;

  static String get getTableName => "users";

  static String get user_id => "user_id";

  static String get username => "username";

  static String get password => "password";

  static String get email => "email";

  static String get created_at => "created_at";

  static String get updated_at => "updated_at";

  static String get curd_status => "curd_status";

  @override
  Map<String, List<SqliteType>> get fields => {user_id: [SqliteType.INTEGER, SqliteType.UNSIGNED], username: [SqliteType.TEXT], password: [SqliteType.TEXT], email: [SqliteType.TEXT], created_at: [SqliteType.INTEGER, SqliteType.UNSIGNED, SqliteType.NOT_NULL], updated_at: [SqliteType.INTEGER, SqliteType.UNSIGNED, SqliteType.NOT_NULL], curd_status: [SqliteType.INTEGER]};

  static Map<String, dynamic> toMap({required int user_id_v,required int username_v,required String password_v,required String email_v,required int created_at_v,required int updated_at_v,required int curd_status_v,}
  ) {
    return {user_id:user_id_v,username:username_v,password:password_v,email:email_v,created_at:created_at_v,updated_at:updated_at_v,curd_status:curd_status_v,};
  }
}
