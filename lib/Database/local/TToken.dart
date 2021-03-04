// ignore_for_file: non_constant_identifier_names

// 之所以 token 独立放在一个表，是因为让 token 有自己的创建、更新时间
// 在上传队列中检查 token

import 'package:jysp/Database/DBTableBase.dart';

class TToken implements DBTableBase {
  @override
  String getTableNameInstance = getTableName;

  static String get getTableName => "tokens";

  static String get access_token => "access_token";

  static String get refresh_token => "refresh_token";

  @override
  List<List> get fields => [
        [access_token, SqliteType.TEXT],
        [refresh_token, SqliteType.TEXT],
      ];

  static Map<String, dynamic> toMap(
    String access_token_v,
    String refresh_token_v,
  ) {
    return {
      access_token: access_token_v,
      refresh_token: refresh_token_v,
    };
  }
}
