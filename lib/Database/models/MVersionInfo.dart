// ignore_for_file: non_constant_identifier_names
import 'package:jysp/G/GSqlite/GSqlite.dart';


class MVersionInfo {

  MVersionInfo();

  MVersionInfo.createModel({required String? saved_version_v,required int? created_at_v,required int? updated_at_v,}) {
    _rowModel.addAll({saved_version:saved_version_v,created_at:created_at_v,updated_at:updated_at_v,});
  }

  static String get getTableName => "version_infos";

  static String get saved_version => "saved_version";
  static String get created_at => "created_at";
  static String get updated_at => "updated_at";


  static Map<String, Object?> toSqliteMap({required String? saved_version_v,required int? created_at_v,required int? updated_at_v,}
  ) {
    return {saved_version:saved_version_v,created_at:created_at_v,updated_at:updated_at_v,};
  }

  static Map<String, Object?> toModelMap(Map<String, Object?> sqliteMap) {
    return {saved_version:sqliteMap[saved_version],created_at:sqliteMap[created_at],updated_at:sqliteMap[updated_at],};
  }

  static Future<List<Map<String, Object?>>> getAllRowsAsSqliteMap() async {
    return await GSqlite.db.query(getTableName);
  }

  static Future<List<MVersionInfo>> getAllRowsAsModel() async {
    List<Map<String, Object?>> allRows = await getAllRowsAsSqliteMap();
    List<MVersionInfo> allRowModels = [];
    allRows.forEach(
      (row) {
        MVersionInfo newRowModel = MVersionInfo();
        newRowModel._rowModel.addAll(toModelMap(row));
        allRowModels.add(newRowModel);
      },
    );
    return allRowModels;
  }

  Map<String, Object?> _rowModel = {};



  String? get get_saved_version => _rowModel[saved_version] as String?;
  int? get get_created_at => _rowModel[created_at] as int?;
  int? get get_updated_at => _rowModel[updated_at] as int?;

}
