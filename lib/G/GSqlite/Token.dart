import 'package:jysp/Database/models/MToken.dart';
import 'package:jysp/G/GSqlite/GSqlite.dart';
import 'package:jysp/Tools/TDebug.dart';

class Token {
  ///

  /// 从 sqlite 中获取 access_token 或 refresh_token。
  ///
  /// 无论是否失败，或是否为 null，都要将请求发送出去，以便能拿到可使用的 tokens。
  ///
  /// 该请求不会抛出任何 err。
  ///
  /// - [tokenType]:
  ///   - [0]: access_token
  ///   - [1]: refresh_token
  /// - [return]: string ,不能返回 null, 因为 ""+null 会报错
  ///
  Future<String> getSqliteToken({required int tokenTypeCode}) async {
    String? tokenType = tokenTypeCode == 0 ? "access_token" : (tokenTypeCode == 1 ? "refresh_token" : null);
    String? token;
    try {
      token = (await GSqlite.db.query(MToken.getTableName))[0][tokenType].toString();
    } catch (e) {
      // 获取失败。可能是 query 失败，也可能是 [0] 值为 null
      token = null;
    }
    dLog(() => "从 sqlite 中获取 $tokenType 的结果：", () => token.toString());
    // 不能返回 null, 因为 ""+null 会报错
    return token ?? "";
  }

  /// 在 sqlite 存储 access_token 和 refresh_token
  ///
  /// - [tokens]: 需要存储的 access_token 和 refresh_token。
  /// - [success]: 存储成功的回调。**注意:返回的结果可以是 Future, 函数内部已嵌套 await**
  /// - [fail]: 存储失败的回调。**注意:返回的结果可以是 Future, 函数内部已嵌套 await**
  ///   - [failCode]: [1]: tokens 值为 null。 [2]: tokens sqlite 存储失败。
  ///
  Future<void> setSqliteToken({
    required Map tokens,
    required Function() success,
    required Function(int failCode) fail,
  }) async {
    if (tokens[MToken.access_token] == null || tokens[MToken.refresh_token] == null) {
      await fail(1);
      dLog(() => "响应的 tokens 数据异常!");
    } else {
      dLog(() => "响应的 tokens 数据正常!");
      // 先清空表，再插入
      await GSqlite.db.transaction(
        (txn) async {
          await txn.delete(MToken.getTableName);
          await txn.insert(
            MToken.getTableName,
            MToken.toSqliteMap(
              access_token_v: tokens[MToken.access_token],
              refresh_token_v: tokens[MToken.refresh_token],
              created_at_v: 0,
              updated_at_v: 0,
            ),
          );
        },
      )
          //
          .then((onValue) async {
        await success();
        List<Map> queryResult = await GSqlite.db.query(MToken.getTableName);
        dLog(() => "sqlite 查询 tokens 成功：", () => queryResult);
      })
          //
          .catchError((onError) async {
        await fail(2);
        dLog(() => "token sqlite 存储失败", () => onError);
      });
    }
  }

  ///
}
