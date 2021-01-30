enum SqliteType { TEXT, UNIQUE, INTEGER }

extension SqliteTypeValue on SqliteType {
  String get value {
    switch (this.index) {
      case 0:
        return "TEXT";
      case 1:
        return "UNIQUE";
      case 2:
        return "INTEGER";
      default:
        throw Exception("Unknown value!");
    }
  }
}

/// 罗列全部被需要的表的 sql 语句
mixin TablesNeededSql {
  ///

  /// 针对 sqlite 的 sql create table 语句
  /// [key]：表名，[value]：create sql
  Map<String, String> createTableNeededSqls = {};

  /// 罗列针对 sqlite 的 sql create table 语句
  void toSetCreateTablesNeededSql() {
    createTableNeededSqls.clear();
    _setCreateTablesNeededSql(TUsers());
    _setCreateTablesNeededSql(TSeparateRules());
    _setCreateTablesNeededSql(TMemoryRules());
    _setCreateTablesNeededSql(TFragments());
    _setCreateTablesNeededSql(TFragmentPoolNodes());
    _setCreateTablesNeededSql(TRs());
  }

  /// 设置针对 sqlite 的 sql create table 语句
  /// [tableName] 要加 [s]
  void _setCreateTablesNeededSql(Table table) {
    /// 解析 table
    String tableName = table.getTableNameInstance;
    List<List<dynamic>> fields = table.fields;

    /// 去掉后缀的 s
    String tableNameNoS = tableName.substring(0, tableName.length - 1);

    /// 解析 fields
    String fieldsSql = "";
    fields.forEach((field) {
      for (int i = 0; i < field.length; i++) {
        if (i == 0) {
          /// 第一个角标为 field 名
          fieldsSql += field[0];
        } else {
          fieldsSql += (" " + (field[i] as SqliteType).value);
        }
      }

      /// 给每个字段添加结尾逗号
      fieldsSql += ",";
    });

    /// 存入
    createTableNeededSqls[tableName] = """
      CREATE TABLE $tableName (
      ${tableNameNoS}_id_m ${SqliteType.TEXT.value} ${SqliteType.UNIQUE.value},
      ${tableNameNoS}_id_s ${SqliteType.TEXT.value} ${SqliteType.UNIQUE.value},
      $fieldsSql
      created_at ${SqliteType.INTEGER.value},
      updated_at ${SqliteType.INTEGER.value}
      )
    """;
  }

  ///
}

abstract class Table {
  List<List<dynamic>> get fields;
  String getTableNameInstance;
}

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

class TSeparateRules implements Table {
  @override
  String getTableNameInstance = getTableName;

  @override
  List<List> get fields => [];

  static String get getTableName => "separate_rules";

  static Map<String, dynamic> toMap() {
    return {};
  }
}

class TMemoryRules implements Table {
  @override
  String getTableNameInstance = getTableName;

  @override
  List<List> get fields => [];

  static String get getTableName => "memory_rules";

  static Map<String, dynamic> toMap() {
    return {};
  }
}

class TFragments implements Table {
  @override
  String getTableNameInstance = getTableName;

  @override
  List<List> get fields => [
        [text, SqliteType.TEXT],
      ];

  static String get getTableName => "fragments";

  static String get text => "text";

  // ignore: non_constant_identifier_names
  static Map<String, dynamic> toMap(String text_v) {
    return {
      text: text_v,
    };
  }
}

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

class TRs implements Table {
  @override
  String getTableNameInstance = getTableName;

  @override
  List<List> get fields => [
        [collector_id_m, SqliteType.TEXT, SqliteType.UNIQUE],
        [collector_id_s, SqliteType.TEXT, SqliteType.UNIQUE],
        [fragment_id_m, SqliteType.TEXT, SqliteType.UNIQUE],
        [fragment_id_s, SqliteType.TEXT, SqliteType.UNIQUE],
        [fragment_creator_id_m, SqliteType.TEXT, SqliteType.UNIQUE],
        [fragment_creator_id_s, SqliteType.TEXT, SqliteType.UNIQUE],
        [fragment_pool_node_id_m, SqliteType.TEXT, SqliteType.UNIQUE],
        [fragment_pool_node_id_s, SqliteType.TEXT, SqliteType.UNIQUE],
        [fragment_pool_node_creator_id_m, SqliteType.TEXT, SqliteType.UNIQUE],
        [fragment_pool_node_creator_id_s, SqliteType.TEXT, SqliteType.UNIQUE],
        [memory_rule_id_m, SqliteType.TEXT, SqliteType.UNIQUE],
        [memory_rule_id_s, SqliteType.TEXT, SqliteType.UNIQUE],
        [memory_rule_creator_id_m, SqliteType.TEXT, SqliteType.UNIQUE],
        [memory_rule_creator_id_s, SqliteType.TEXT, SqliteType.UNIQUE],
        [separate_rule_id_m, SqliteType.TEXT, SqliteType.UNIQUE],
        [separate_rule_id_s, SqliteType.TEXT, SqliteType.UNIQUE],
        [separate_rule_creator_id_m, SqliteType.TEXT, SqliteType.UNIQUE],
        [separate_rule_creator_id_s, SqliteType.TEXT, SqliteType.UNIQUE],
      ];

  static String get getTableName => "rs";

  // ignore: non_constant_identifier_names
  static String get collector_id_m => "collector_id_m";

  // ignore: non_constant_identifier_names
  static String get collector_id_s => "collector_id_s";

  // ignore: non_constant_identifier_names
  static String get fragment_id_m => "fragment_id_m";

  // ignore: non_constant_identifier_names
  static String get fragment_id_s => "fragment_id_s";

  // ignore: non_constant_identifier_names
  static String get fragment_creator_id_m => "fragment_creator_id_m";

  // ignore: non_constant_identifier_names
  static String get fragment_creator_id_s => "fragment_creator_id_s";

  // ignore: non_constant_identifier_names
  static String get fragment_pool_node_id_m => "fragment_pool_node_id_m";

  // ignore: non_constant_identifier_names
  static String get fragment_pool_node_id_s => "fragment_pool_node_id_s";

  // ignore: non_constant_identifier_names
  static String get fragment_pool_node_creator_id_m => "fragment_pool_node_creator_id_m";

  // ignore: non_constant_identifier_names
  static String get fragment_pool_node_creator_id_s => "fragment_pool_node_creator_id_s";

  // ignore: non_constant_identifier_names
  static String get memory_rule_id_m => "memory_rule_id_m";

  // ignore: non_constant_identifier_names
  static String get memory_rule_id_s => "memory_rule_id_s";

  // ignore: non_constant_identifier_names
  static String get memory_rule_creator_id_m => "memory_rule_creator_id_m";

  // ignore: non_constant_identifier_names
  static String get memory_rule_creator_id_s => "memory_rule_creator_id_s";

  // ignore: non_constant_identifier_names
  static String get separate_rule_id_m => "separate_rule_id_m";

  // ignore: non_constant_identifier_names
  static String get separate_rule_id_s => "separate_rule_id_s";

  // ignore: non_constant_identifier_names
  static String get separate_rule_creator_id_m => "separate_rule_creator_id_m";

  // ignore: non_constant_identifier_names
  static String get separate_rule_creator_id_s => "separate_rule_creator_id_s";

  static Map<String, dynamic> toMap(
    String collector_id_m_v,
    String collector_id_s_v,
    String fragment_id_m_v,
    String fragment_id_s_v,
    String fragment_creator_id_m_v,
    String fragment_creator_id_s_v,
    String fragment_pool_node_id_m_v,
    String fragment_pool_node_id_s_v,
    String fragment_pool_node_creator_id_m_v,
    String fragment_pool_node_creator_id_s_v,
    String memory_rule_id_m_v,
    String memory_rule_id_s_v,
    String memory_rule_creator_id_m_v,
    String memory_rule_creator_id_s_v,
    String separate_rule_id_m_v,
    String separate_rule_id_s_v,
    String separate_rule_creator_id_m_v,
    String separate_rule_creator_id_s_v,
  ) {
    return {
      collector_id_m: collector_id_m_v,
      collector_id_s: collector_id_s_v,
      fragment_id_m: fragment_id_m_v,
      fragment_id_s: fragment_id_s_v,
      fragment_creator_id_m: fragment_creator_id_m_v,
      fragment_creator_id_s: fragment_creator_id_s_v,
      fragment_pool_node_id_m: fragment_pool_node_id_m_v,
      fragment_pool_node_id_s: fragment_pool_node_id_s_v,
      fragment_pool_node_creator_id_m: fragment_pool_node_creator_id_m_v,
      fragment_pool_node_creator_id_s: fragment_pool_node_creator_id_s_v,
      memory_rule_id_m: memory_rule_id_m_v,
      memory_rule_id_s: memory_rule_id_s_v,
      memory_rule_creator_id_m: memory_rule_creator_id_m_v,
      memory_rule_creator_id_s: memory_rule_creator_id_s_v,
      separate_rule_id_m: separate_rule_id_m_v,
      separate_rule_id_s: separate_rule_id_s_v,
      separate_rule_creator_id_m: separate_rule_creator_id_m_v,
      separate_rule_creator_id_s: separate_rule_creator_id_s_v
    };
  }
}
