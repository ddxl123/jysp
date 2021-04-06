// ignore_for_file: non_constant_identifier_names
import 'package:jysp/G/GSqlite/GSqlite.dart';

class MDownloadQueueRow {

  MDownloadQueueRow();

  MDownloadQueueRow.createModel({required String? table_name_v,required int? row_id_v,required int? download_is_ok_v,required int? created_at_v,required int? updated_at_v,}) {
    _rowModel.addAll({table_name:table_name_v,row_id:row_id_v,download_is_ok:download_is_ok_v,created_at:created_at_v,updated_at:updated_at_v,});
  }

  static String get getTableName => "download_queue_rows";

  static String get table_name => "table_name";
  static String get row_id => "row_id";
  static String get download_is_ok => "download_is_ok";
  static String get created_at => "created_at";
  static String get updated_at => "updated_at";


  static Map<String, Object?> toSqliteMap({required String? table_name_v,required int? row_id_v,required int? download_is_ok_v,required int? created_at_v,required int? updated_at_v,}
  ) {
    return {table_name:table_name_v,row_id:row_id_v,download_is_ok:download_is_ok_v,created_at:created_at_v,updated_at:updated_at_v,};
  }

  static Map<String, Object?> toModelMap(Map<String, Object?> sqliteMap) {
    return {table_name:sqliteMap[table_name],row_id:sqliteMap[row_id],download_is_ok:sqliteMap[download_is_ok],created_at:sqliteMap[created_at],updated_at:sqliteMap[updated_at],};
  }

  static Future<List<MDownloadQueueRow>> getAllRowsAsModel() async {
    List<Map<String, Object?>> allRows = await GSqlite.db.query(getTableName);
    List<MDownloadQueueRow> allRowModels = [];
    allRows.forEach(
      (row) {
        MDownloadQueueRow newRowModel = MDownloadQueueRow();
        newRowModel._rowModel = toModelMap(row);
        allRowModels.add(newRowModel);
      },
    );
    return allRowModels;
  }

  Map<String, Object?> _rowModel = {};



  String? get get_table_name => _rowModel[table_name] as String?;
  int? get get_row_id => _rowModel[row_id] as int?;
  int? get get_download_is_ok => _rowModel[download_is_ok] as int?;
  int? get get_created_at => _rowModel[created_at] as int?;
  int? get get_updated_at => _rowModel[updated_at] as int?;

}
