// ignore_for_file: non_constant_identifier_names
import 'package:jysp/G/GSqlite/GSqlite.dart';

class MDownloadQueueModule {

  MDownloadQueueModule();

  MDownloadQueueModule.createModel({required String? module_name_v,required int? download_is_ok_v,required int? created_at_v,required int? updated_at_v,}) {
    _rowModel.addAll({module_name:module_name_v,download_is_ok:download_is_ok_v,created_at:created_at_v,updated_at:updated_at_v,});
  }

  static String get getTableName => "download_queue_modules";

  static String get module_name => "module_name";
  static String get download_is_ok => "download_is_ok";
  static String get created_at => "created_at";
  static String get updated_at => "updated_at";


  static Map<String, Object?> toSqliteMap({required String? module_name_v,required int? download_is_ok_v,required int? created_at_v,required int? updated_at_v,}
  ) {
    return {module_name:module_name_v,download_is_ok:download_is_ok_v,created_at:created_at_v,updated_at:updated_at_v,};
  }

  static Map<String, Object?> toModelMap(Map<String, Object?> sqliteMap) {
    return {module_name:sqliteMap[module_name],download_is_ok:sqliteMap[download_is_ok],created_at:sqliteMap[created_at],updated_at:sqliteMap[updated_at],};
  }

  static Future<List<MDownloadQueueModule>> getAllRowsAsModel() async {
    List<Map<String, Object?>> allRows = await GSqlite.db.query(getTableName);
    List<MDownloadQueueModule> allRowModels = [];
    allRows.forEach(
      (row) {
        MDownloadQueueModule newRowModel = MDownloadQueueModule();
        newRowModel._rowModel = toModelMap(row);
        allRowModels.add(newRowModel);
      },
    );
    return allRowModels;
  }

  Map<String, Object?> _rowModel = {};

static List<String> downloadQueueBaseModules =
      [
        "user_info",
        "pending_pool_nodes",
        "memory_pool_nodes",
        "complete_pool_nodes",
        "rule_pool_nodes",
      ];


  String? get get_module_name => _rowModel[module_name] as String?;
  int? get get_download_is_ok => _rowModel[download_is_ok] as int?;
  int? get get_created_at => _rowModel[created_at] as int?;
  int? get get_updated_at => _rowModel[updated_at] as int?;

}
