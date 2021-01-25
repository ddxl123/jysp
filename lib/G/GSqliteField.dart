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
      /// 第一个角标为 field 名
      fieldsSql += field[0];

      /// 第二个角标为 属性名
      (field[1] as List<SqliteType>).forEach((props) {
        fieldsSql += (" " + props.value);
      });

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
  String get getTableNameInstance;
  List<List<dynamic>> get fields;
}

class TUsers implements Table {
  @override
  String get getTableNameInstance => getTableName;
  static String get getTableName => "users";

  @override
  List<List<dynamic>> get fields => [
        [username, usernameProps],
        [qq_email, qq_emailProps],
        [password, passwordProps],
      ];

  static String get username => "username";
  List<SqliteType> get usernameProps => [SqliteType.TEXT];

  // ignore: non_constant_identifier_names
  static String get qq_email => "qq_email";
  // ignore: non_constant_identifier_names
  List<SqliteType> get qq_emailProps => [SqliteType.TEXT];

  static String get password => "password";
  List<SqliteType> get passwordProps => [SqliteType.TEXT];
}

class TSeparateRules extends Table {
  @override
  String get getTableNameInstance => getTableName;
  static String get getTableName => "separate_rules";

  @override
  List<List> get fields => [];
}

class TMemoryRules extends Table {
  @override
  String get getTableNameInstance => getTableName;
  static String get getTableName => "memory_rules";

  @override
  List<List> get fields => [];
}

class TFragments extends Table {
  @override
  String get getTableNameInstance => getTableName;
  static String get getTableName => "fragments";

  @override
  List<List> get fields => [
        [text, textProps],
      ];

  static String get text => "text";
  List<SqliteType> get textProps => [SqliteType.TEXT];
}

class TFragmentPoolNodes extends Table {
  @override
  String get getTableNameInstance => getTableName;
  static String get getTableName => "fragment_pool_nodes";

  @override
  List<List> get fields => [
        [pool_type, pool_typeProps],
        [node_type, node_typeProps],
        [route, routeProps],
        [name, nameProps],
      ];

  // ignore: non_constant_identifier_names
  static String get pool_type => "pool_type";
  // ignore: non_constant_identifier_names
  List<SqliteType> get pool_typeProps => [SqliteType.INTEGER];

  // ignore: non_constant_identifier_names
  static String get node_type => "node_type";
  // ignore: non_constant_identifier_names
  List<SqliteType> get node_typeProps => [SqliteType.INTEGER];

  static String get route => "route";
  List<SqliteType> get routeProps => [SqliteType.TEXT];

  static String get name => "name";
  List<SqliteType> get nameProps => [SqliteType.TEXT];
}

class TRs extends Table {
  @override
  String get getTableNameInstance => getTableName;
  static String get getTableName => "rs";

  @override
  List<List> get fields => [
        [collector_id_m, collector_id_mProps],
        [collector_id_s, collector_id_sProps],
        [fragment_id_m, fragment_id_mProps],
        [fragment_id_s, fragment_id_sProps],
        [fragment_creator_id_m, fragment_creator_id_mProps],
        [fragment_creator_id_s, fragment_creator_id_sProps],
        [fragment_pool_node_id_m, fragment_pool_node_id_mProps],
        [fragment_pool_node_id_s, fragment_pool_node_id_sProps],
        [fragment_pool_node_creator_id_m, fragment_pool_node_creator_id_mProps],
        [fragment_pool_node_creator_id_s, fragment_pool_node_creator_id_sProps],
        [memory_rule_id_m, memory_rule_id_mProps],
        [memory_rule_id_s, memory_rule_id_sProps],
        [memory_rule_creator_id_m, memory_rule_creator_id_mProps],
        [memory_rule_creator_id_s, memory_rule_creator_id_sProps],
        [separate_rule_id_m, separate_rule_id_mProps],
        [separate_rule_id_s, separate_rule_id_sProps],
        [separate_rule_creator_id_m, separate_rule_creator_id_mProps],
        [separate_rule_creator_id_s, separate_rule_creator_id_sProps],
      ];

  // ignore: non_constant_identifier_names
  static String get collector_id_m => "collector_id_m";
  // ignore: non_constant_identifier_names
  List<SqliteType> get collector_id_mProps => [SqliteType.TEXT, SqliteType.UNIQUE];

  // ignore: non_constant_identifier_names
  static String get collector_id_s => "collector_id_s";
  // ignore: non_constant_identifier_names
  List<SqliteType> get collector_id_sProps => [SqliteType.TEXT, SqliteType.UNIQUE];

  // ignore: non_constant_identifier_names
  static String get fragment_id_m => "fragment_id_m";
  // ignore: non_constant_identifier_names
  List<SqliteType> get fragment_id_mProps => [SqliteType.TEXT, SqliteType.UNIQUE];

  // ignore: non_constant_identifier_names
  static String get fragment_id_s => "fragment_id_s";
  // ignore: non_constant_identifier_names
  List<SqliteType> get fragment_id_sProps => [SqliteType.TEXT, SqliteType.UNIQUE];

  // ignore: non_constant_identifier_names
  static String get fragment_creator_id_m => "fragment_creator_id_m";
  // ignore: non_constant_identifier_names
  List<SqliteType> get fragment_creator_id_mProps => [SqliteType.TEXT, SqliteType.UNIQUE];

  // ignore: non_constant_identifier_names
  static String get fragment_creator_id_s => "fragment_creator_id_s";
  // ignore: non_constant_identifier_names
  List<SqliteType> get fragment_creator_id_sProps => [SqliteType.TEXT, SqliteType.UNIQUE];

  // ignore: non_constant_identifier_names
  static String get fragment_pool_node_id_m => "fragment_pool_node_id_m";
  // ignore: non_constant_identifier_names
  List<SqliteType> get fragment_pool_node_id_mProps => [SqliteType.TEXT, SqliteType.UNIQUE];

  // ignore: non_constant_identifier_names
  static String get fragment_pool_node_id_s => "fragment_pool_node_id_s";
  // ignore: non_constant_identifier_names
  List<SqliteType> get fragment_pool_node_id_sProps => [SqliteType.TEXT, SqliteType.UNIQUE];

  // ignore: non_constant_identifier_names
  static String get fragment_pool_node_creator_id_m => "fragment_pool_node_creator_id_m";
  // ignore: non_constant_identifier_names
  List<SqliteType> get fragment_pool_node_creator_id_mProps => [SqliteType.TEXT, SqliteType.UNIQUE];

  // ignore: non_constant_identifier_names
  static String get fragment_pool_node_creator_id_s => "fragment_pool_node_creator_id_s";
  // ignore: non_constant_identifier_names
  List<SqliteType> get fragment_pool_node_creator_id_sProps => [SqliteType.TEXT, SqliteType.UNIQUE];

  // ignore: non_constant_identifier_names
  static String get memory_rule_id_m => "memory_rule_id_m";
  // ignore: non_constant_identifier_names
  List<SqliteType> get memory_rule_id_mProps => [SqliteType.TEXT, SqliteType.UNIQUE];

  // ignore: non_constant_identifier_names
  static String get memory_rule_id_s => "memory_rule_id_s";
  // ignore: non_constant_identifier_names
  List<SqliteType> get memory_rule_id_sProps => [SqliteType.TEXT, SqliteType.UNIQUE];

  // ignore: non_constant_identifier_names
  static String get memory_rule_creator_id_m => "memory_rule_creator_id_m";
  // ignore: non_constant_identifier_names
  List<SqliteType> get memory_rule_creator_id_mProps => [SqliteType.TEXT, SqliteType.UNIQUE];

  // ignore: non_constant_identifier_names
  static String get memory_rule_creator_id_s => "memory_rule_creator_id_s";
  // ignore: non_constant_identifier_names
  List<SqliteType> get memory_rule_creator_id_sProps => [SqliteType.TEXT, SqliteType.UNIQUE];

  // ignore: non_constant_identifier_names
  static String get separate_rule_id_m => "separate_rule_id_m";
  // ignore: non_constant_identifier_names
  List<SqliteType> get separate_rule_id_mProps => [SqliteType.TEXT, SqliteType.UNIQUE];

  // ignore: non_constant_identifier_names
  static String get separate_rule_id_s => "separate_rule_id_s";
  // ignore: non_constant_identifier_names
  List<SqliteType> get separate_rule_id_sProps => [SqliteType.TEXT, SqliteType.UNIQUE];

  // ignore: non_constant_identifier_names
  static String get separate_rule_creator_id_m => "separate_rule_creator_id_m";
  // ignore: non_constant_identifier_names
  List<SqliteType> get separate_rule_creator_id_mProps => [SqliteType.TEXT, SqliteType.UNIQUE];

  // ignore: non_constant_identifier_names
  static String get separate_rule_creator_id_s => "separate_rule_creator_id_s";
  // ignore: non_constant_identifier_names
  List<SqliteType> get separate_rule_creator_id_sProps => [SqliteType.TEXT, SqliteType.UNIQUE];
}
