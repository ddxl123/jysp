// ignore_for_file: non_constant_identifier_names

import 'package:jysp/Database/DBTableBase.dart';

/// 该表是【必须模块（整体式模块）】

/// 初始化：
/// sqlite 中查询该表，若没有字段，则说明未初始化Ⅰ，并将 state 存储一个 node_type 为Ⅰ的节点,  sqlite 无需标记。
///
/// 为Ⅰ时，若触发初始化，则需先向云端发送请求，云端返回的内容：Ⅱ未创建信息、Ⅲ异常信息、Ⅳ、有信息；
///
/// 若为Ⅱ时，则 sqlite 存储一个 node_type 为Ⅱ的节点 ，state 刷新即可；
///
/// 若为Ⅲ时，则 sqlite 存储一个 node_type 为Ⅱ的节点 ，state 刷新即可，Toast 提示Ⅲ；
///
/// 若为Ⅳ时，则直接获取。

class TFragmentPoolNode implements DBTableBase {
  @override
  String getTableNameInstance = getTableName;

  static String get getTableName => "fragment_pool_nodes";

  static String get fragment_pool_node_id => "fragment_pool_node_id";

  static String get fragment_pool_node_id_s => "fragment_pool_node_id_s";

  static String get pool_type => "pool_type";

  static String get node_type => "node_type";

  static String get name => "name";

  static String get position => "position";

  static String get created_at => DBTableBase.created_at;

  static String get updated_at => DBTableBase.updated_at;

  @override
  List<List> get fields => [
        DBTableBase.x_id_m_no_primary(fragment_pool_node_id),
        DBTableBase.x_id_s_no_primary(fragment_pool_node_id_s),
        [pool_type, SqliteType.INTEGER, SqliteType.NOT_NULL, SqliteType.UNSIGNED], // mysql:TINYINT 不为空 无符号
        [node_type, SqliteType.INTEGER, SqliteType.NOT_NULL, SqliteType.UNSIGNED], // mysql:INT 不为空 无符号
        [name, SqliteType.TEXT], // mysql:VARCHAR(50)
        [position, SqliteType.TEXT], // mysql:VARCHAR(50)
        DBTableBase.created_at_sql,
        DBTableBase.updated_at_sql,
      ];

  static Map<String, dynamic> toMap({
    required int? fragment_pool_node_id_v,
    required String? fragment_pool_node_id_s_v,
    required int? pool_type_v,
    required int? node_type_v,
    required String? name_v,
    required String? position_v,
    required int? created_at_v,
    required int? updated_at_v,
  }) {
    return {
      fragment_pool_node_id: fragment_pool_node_id_v,
      fragment_pool_node_id_s: fragment_pool_node_id_s_v,
      pool_type: pool_type_v,
      node_type: node_type_v,
      name: name_v,
      position: position_v,
      created_at: created_at_v,
      updated_at: updated_at_v,
    };
  }
}

enum NodeType {
  root, // 0

  pendingGroup, // 1
  pendingGroupCol, // 2
  pendingFragment, // 3

  memoryGroup, // 4
  memoryGroupCol, // 5
  memoryFragment, // 6

  completeGroup, // 7
  completeGroupCol, // 8
  completeFragment, // 9

  wikiGroup, // 10
  wikiGroupCol, // 11
  wikiFragment, // 12
}

extension NodeSelectedTypeExt on NodeType {
  String get value {
    switch (this.index) {
      case 0:
        return "root";
      case 1:
        return "待定组";
      case 2:
        return "待定组集";
      case 3:
        return "待定碎片";
      case 4:
        return "记忆组";
      case 5:
        return "记忆组集";
      case 6:
        return "记忆碎片";
      case 7:
        return "完成组";
      case 8:
        return "完成组集";
      case 9:
        return "完成碎片";
      case 10:
        return "百科组";
      case 11:
        return "百科组集";
      case 12:
        return "百科碎片";
      default:
        throw Exception("Index is unknown!");
    }
  }
}

/// 1. 当 [PoolType.index] 时，获取的是 [int]。
/// 2. 当 [PoolType.value] 时，获取的是 [string]。
/// 3. 当 [PoolType.indexs.toList] 时，获取的是角标数组。
enum PoolType {
  pendingPool, // 0
  memoryPool, // 1
  completePool, // 2
  wikiPool, // 3
}

extension PoolSelectedTypeExt on PoolType {
  String get text {
    switch (this.index) {
      case 0:
        return "待定池";
      case 1:
        return "记忆池";
      case 2:
        return "完成池";
      case 3:
        return "百科池";
      case 4:
      default:
        throw Exception("Index is unknown!");
    }
  }
}
