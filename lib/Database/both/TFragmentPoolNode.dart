// ignore_for_file: non_constant_identifier_names

import 'package:flutter/material.dart';
import 'package:jysp/Database/DBTableBase.dart';

/// 该表是【必须模块（整体式模块）】

/// 初始化：
/// sqlite 中查询该表，若没有字段，则说明未初始化Ⅰ，并将 state 存储一个 node_type 为Ⅰ的节点,  sqlite 无需标记。
/// 为Ⅰ时，若触发初始化，则需先向云端发送请求，云端返回的内容：Ⅱ未创建信息、Ⅲ异常信息、Ⅳ、有信息；
/// 若为Ⅱ时，则 sqlite 存储一个 node_type 为Ⅱ的节点 ，state 刷新即可；
/// 若为Ⅲ时，则 sqlite 存储一个 node_type 为Ⅱ的节点 ，state 刷新即可，Toast 提示Ⅲ；
/// 若为Ⅳ时，则直接获取。

class TFragmentPoolNode implements DBTableBase {
  @override
  String getTableNameInstance = getTableName;

  static String get getTableName => "fragment_pool_nodes";

  static String get fragment_pool_node_id => "fragment_pool_node_id";

  static String get fragment_pool_node_id_s => "fragment_pool_node_id_s";

  static String get pool_type => "pool_type";

  static String get node_type => "node_type";

  static String get father_id => "father_id";

  static String get father_id_s => "father_id_s";

  static String get branch => "branch";

  static String get name => "name";

  static String get created_at => DBTableBase.created_at;

  static String get updated_at => DBTableBase.updated_at;

  @override
  List<List> get fields => [
        DBTableBase.x_id_m_no_primary(fragment_pool_node_id),
        DBTableBase.x_id_s_no_primary(fragment_pool_node_id_s),
        [pool_type, SqliteType.INTEGER, SqliteType.NOT_NULL, SqliteType.UNSIGNED], // mysql:TINYINT 不为空 无符号
        [node_type, SqliteType.INTEGER, SqliteType.NOT_NULL, SqliteType.UNSIGNED], // mysql:INT 不为空 无符号
        DBTableBase.x_id_m_no_primary(father_id),
        DBTableBase.x_id_s_no_primary(father_id_s),
        [branch, SqliteType.TEXT],
        [name, SqliteType.TEXT], // mysql:VARCHAR(20)
        DBTableBase.created_at_sql,
        DBTableBase.updated_at_sql,
      ];

  static Map<String, dynamic> toMap({
    @required int fragment_pool_node_id_v,
    @required String fragment_pool_node_id_s_v,
    @required int pool_type_v,
    @required int node_type_v,
    @required String father_id_v,
    @required String father_id_s_v,
    @required String branch_v,
    @required String name_v,
    @required int created_at_v,
    @required int updated_at_v,
  }) {
    return {
      fragment_pool_node_id: fragment_pool_node_id_v,
      fragment_pool_node_id_s: fragment_pool_node_id_s_v,
      pool_type: pool_type_v,
      node_type: node_type_v,
      father_id: father_id_v,
      father_id_s: father_id_s_v,
      branch: branch_v,
      name: name_v,
      created_at: created_at_v,
      updated_at: updated_at_v,
    };
  }
}
