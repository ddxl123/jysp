// ignore_for_file: non_constant_identifier_names

import 'package:jysp/Table/TableBase.dart';

/// 该表是【必须模块（整体式模块）】

/// 初始化：
/// sqlite 中查询该表，若没有字段，则说明未初始化Ⅰ，并将 state 存储一个 node_type 为Ⅰ的节点,  sqlite 无需标记。
/// 为Ⅰ时，若触发初始化，则需先向云端发送请求，云端返回的内容：Ⅱ未创建信息、Ⅲ异常信息、Ⅳ、有信息；
/// 若为Ⅱ时，则 sqlite 存储一个 node_type 为Ⅱ的节点 ，state 刷新即可；
/// 若为Ⅲ时，则 sqlite 存储一个 node_type 为Ⅱ的节点 ，state 刷新即可，Toast 提示Ⅲ；
/// 若为Ⅳ时，则直接获取。

/// 待解决：
/// 1、重复 route 问题
/// 2、缺失 route 问题

class TFragmentPoolNodes implements Table {
  @override
  String getTableNameInstance = getTableName;

  static String get getTableName => "fragment_pool_nodes";

  static String get fragment_pool_node_id_m => "fragment_pool_node_id_m";

  static String get fragment_pool_node_id_s => "fragment_pool_node_id_s";

  static String get pool_type => "pool_type";

  static String get node_type => "node_type";

  static String get route => "route";

  static String get name => "name";

  static String get created_at => Table.created_at;

  static String get updated_at => Table.updated_at;

  @override
  List<List> get fields => [
        Table.x_id_ms_sql(fragment_pool_node_id_m),
        Table.x_id_ms_sql(fragment_pool_node_id_s),
        [pool_type, SqliteType.INTEGER, SqliteType.NOT_NULL, SqliteType.UNSIGNED], // mysql:TINYINT 不为空 无符号
        [node_type, SqliteType.INTEGER, SqliteType.NOT_NULL, SqliteType.UNSIGNED], // mysql:INT 不为空 无符号
        [route, SqliteType.TEXT, SqliteType.NOT_NULL], // mysql:VARCHAR(50) 不为空
        [name, SqliteType.TEXT], // mysql:VARCHAR(20)
        Table.created_at_sql,
        Table.updated_at_sql,
      ];

  static Map<String, dynamic> toMap(
    String fragment_pool_node_id_m_v,
    String fragment_pool_node_id_s_v,
    int pool_type_v,
    int node_type_v,
    String route_v,
    String name_v,
    int created_at_v,
    int updated_at_v,
  ) {
    return {
      fragment_pool_node_id_m: fragment_pool_node_id_m_v,
      fragment_pool_node_id_s: fragment_pool_node_id_s_v,
      pool_type: pool_type_v,
      node_type: node_type_v,
      route: route_v,
      name: name_v,
      created_at: created_at_v,
      updated_at: updated_at_v,
    };
  }
}
