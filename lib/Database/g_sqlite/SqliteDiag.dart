import 'package:jysp/database/g_sqlite/GSqlite.dart';
import 'package:sqflite/utils/utils.dart';

/// 诊断工具
class SqliteDiag {
  ///

  /// 检查表是否完整
  Future<bool> isTableComplete(Map<String, String> sqls) async {
    final List<String> neededSqls = sqls.keys.toList();
    for (int i = 0; i < neededSqls.length; i++) {
      if (!await isTableExist(neededSqls[i])) {
        return false;
      }
    }
    return true;
  }

  /// 检查指定表是否存在
  Future<bool> isTableExist(String table) async {
    final int? count = firstIntValue(
      await db.query(
        'sqlite_master',
        columns: <String>['COUNT(*)'],
        where: 'type = ? AND name = ?',
      ),
    );
    if (count == null) {
      return false;
    }
    if (count > 0) {
      return true;
    } else {
      return false;
    }
  }

  ///
}
