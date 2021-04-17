// ignore_for_file: non_constant_identifier_names
import 'package:jysp/G/GSqlite/GSqlite.dart';


class MToken {

  MToken();

  MToken.createModel({required String? access_token_v,required String? refresh_token_v,required int? created_at_v,required int? updated_at_v,}) {
    _rowModel.addAll({access_token:access_token_v,refresh_token:refresh_token_v,created_at:created_at_v,updated_at:updated_at_v,});
  }

  static String get getTableName => "tokens";

  static String get access_token => "access_token";
  static String get refresh_token => "refresh_token";
  static String get created_at => "created_at";
  static String get updated_at => "updated_at";


  static Map<String, Object?> toSqliteMap({required String? access_token_v,required String? refresh_token_v,required int? created_at_v,required int? updated_at_v,}
  ) {
    return {access_token:access_token_v,refresh_token:refresh_token_v,created_at:created_at_v,updated_at:updated_at_v,};
  }

  static Map<String, Object?> toModelMap(Map<String, Object?> sqliteMap) {
    return {access_token:sqliteMap[access_token],refresh_token:sqliteMap[refresh_token],created_at:sqliteMap[created_at],updated_at:sqliteMap[updated_at],};
  }

  static Future<List<Map<String, Object?>>> getAllRowsAsSqliteMap() async {
    return await GSqlite.db.query(getTableName);
  }

  static Future<List<MToken>> getAllRowsAsModel() async {
    List<Map<String, Object?>> allRows = await getAllRowsAsSqliteMap();
    List<MToken> allRowModels = [];
    allRows.forEach(
      (row) {
        MToken newRowModel = MToken();
        newRowModel._rowModel.addAll(toModelMap(row));
        allRowModels.add(newRowModel);
      },
    );
    return allRowModels;
  }

  Map<String, Object?> _rowModel = {};



  String? get get_access_token => _rowModel[access_token] as String?;
  String? get get_refresh_token => _rowModel[refresh_token] as String?;
  int? get get_created_at => _rowModel[created_at] as int?;
  int? get get_updated_at => _rowModel[updated_at] as int?;

}
