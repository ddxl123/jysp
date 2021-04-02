enum SqliteType {
  // Sqlite 类型
  TEXT,
  INTEGER,
  UNIQUE,
  PRIMARY_KEY,
  NOT_NULL,
  UNSIGNED,
  AUTOINCREMENT,

  // Sqlite 对应的 dart 类型
  int,
  String,
}

extension SqliteTypeValue on SqliteType {
  String get value {
    switch (this.index) {
      case 0:
        return "TEXT";
      case 1:
        return "INTEGER";
      case 2:
        return "UNIQUE";
      case 3:
        return "PRIMARY_KEY";
      case 4:
        return "NOT_NULL";
      case 5:
        return "UNSIGNED";
      case 6:
        return "AUTO_INCREMENT";
      case 7:
        return "int";
      case 8:
        return "String";
      default:
        throw Exception("Unknown value!");
    }
  }
}
