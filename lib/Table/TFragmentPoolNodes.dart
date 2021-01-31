import 'package:jysp/Table/TableBase.dart';

class TFragmentPoolNodes implements Table {
  @override
  String getTableNameInstance = getTableName;

  @override
  List<List> get fields => [
        [pool_type, SqliteType.INTEGER],
        [node_type, SqliteType.INTEGER],
        [route, SqliteType.TEXT],
        [name, SqliteType.TEXT]
      ];

  static String get getTableName => "fragment_pool_nodes";

  // ignore: non_constant_identifier_names
  static String get pool_type => "pool_type";

  // ignore: non_constant_identifier_names
  static String get node_type => "node_type";

  static String get route => "route";

  static String get name => "name";

  // ignore: non_constant_identifier_names
  static Map<String, dynamic> toMap(int pool_type_v, int node_type_v, String route_v, String name_v) {
    return {
      pool_type: pool_type_v,
      node_type: node_type_v,
      route: route_v,
      name: name_v,
    };
  }
}
