// ignore_for_file: non_constant_identifier_names

import 'package:jysp/Table/TableBase.dart';

// 之所以 token 独立放在一个表，是因为让 token 有自己的创建、更新时间
// 在上传队列中检查 token

class TTokens implements Table {
  @override
  String getTableNameInstance = getTableName;

  static String get getTableName => "tokens";

  static String get token => "token";

  static String get created_at => Table.created_at;

  static String get updated_at => Table.updated_at;

  @override
  List<List> get fields => [
        [token, SqliteType.TEXT],
        Table.created_at_sql,
        Table.updated_at_sql,
      ];

  static Map<String, dynamic> toMap(
    String token_v,
    int created_at_v,
    int updated_at_v,
  ) {
    return {
      token: token_v,
      created_at: created_at_v,
      updated_at: updated_at_v,
    };
  }
}
