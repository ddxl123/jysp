// ignore_for_file: non_constant_identifier_names
import 'package:jysp/G/GSqlite/GSqlite.dart';

enum SqliteDownloadStatus {downloaded,notDownload,}
class MDownloadModule {

  MDownloadModule();

  MDownloadModule.createModel({required String? module_name_v,required SqliteDownloadStatus? download_status_v,required int? created_at_v,required int? updated_at_v,}) {
    _rowModel.addAll({module_name:module_name_v,download_status:download_status_v?.index,created_at:created_at_v,updated_at:updated_at_v,});
  }

  static String get getTableName => "download_modules";

  static String get module_name => "module_name";
  static String get download_status => "download_status";
  static String get created_at => "created_at";
  static String get updated_at => "updated_at";


  static Map<String, Object?> toSqliteMap({required String? module_name_v,required SqliteDownloadStatus? download_status_v,required int? created_at_v,required int? updated_at_v,}
  ) {
    return {module_name:module_name_v,download_status:download_status_v?.index,created_at:created_at_v,updated_at:updated_at_v,};
  }

  static Map<String, Object?> toModelMap(Map<String, Object?> sqliteMap) {
    return {module_name:sqliteMap[module_name],download_status:sqliteMap[download_status] == null ? null : SqliteDownloadStatus.values[sqliteMap[download_status] as int],created_at:sqliteMap[created_at],updated_at:sqliteMap[updated_at],};
  }

  static Future<List<Map<String, Object?>>> getAllRowsAsSqliteMap() async {
    return await GSqlite.db.query(getTableName);
  }

  static Future<List<MDownloadModule>> getAllRowsAsModel() async {
    List<Map<String, Object?>> allRows = await getAllRowsAsSqliteMap();
    List<MDownloadModule> allRowModels = [];
    allRows.forEach(
      (row) {
        MDownloadModule newRowModel = MDownloadModule();
        newRowModel._rowModel.addAll(toModelMap(row));
        allRowModels.add(newRowModel);
      },
    );
    return allRowModels;
  }

  Map<String, Object?> _rowModel = {};



  String? get get_module_name => _rowModel[module_name] as String?;
  SqliteDownloadStatus? get get_download_status => _rowModel[download_status] as SqliteDownloadStatus?;
  int? get get_created_at => _rowModel[created_at] as int?;
  int? get get_updated_at => _rowModel[updated_at] as int?;

}
