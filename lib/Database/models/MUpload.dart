// ignore_for_file: non_constant_identifier_names
import 'package:jysp/G/GSqlite/GSqlite.dart';


class MUpload {

  MUpload();

  MUpload.createModel({required String? table_name_v,required int? row_id_v,required String? row_uuid_v,required String? upload_is_ok_v,required int? created_at_v,required int? updated_at_v,}) {
    _rowModel.addAll({table_name:table_name_v,row_id:row_id_v,row_uuid:row_uuid_v,upload_is_ok:upload_is_ok_v,created_at:created_at_v,updated_at:updated_at_v,});
  }

  static String get getTableName => "uploads";

  static String get table_name => "table_name";
  static String get row_id => "row_id";
  static String get row_uuid => "row_uuid";
  static String get upload_is_ok => "upload_is_ok";
  static String get created_at => "created_at";
  static String get updated_at => "updated_at";


  static Map<String, Object?> toSqliteMap({required String? table_name_v,required int? row_id_v,required String? row_uuid_v,required String? upload_is_ok_v,required int? created_at_v,required int? updated_at_v,}
  ) {
    return {table_name:table_name_v,row_id:row_id_v,row_uuid:row_uuid_v,upload_is_ok:upload_is_ok_v,created_at:created_at_v,updated_at:updated_at_v,};
  }

  static Map<String, Object?> toModelMap(Map<String, Object?> sqliteMap) {
    return {table_name:sqliteMap[table_name],row_id:sqliteMap[row_id],row_uuid:sqliteMap[row_uuid],upload_is_ok:sqliteMap[upload_is_ok],created_at:sqliteMap[created_at],updated_at:sqliteMap[updated_at],};
  }

  static Future<List<Map<String, Object?>>> getAllRowsAsSqliteMap() async {
    return await GSqlite.db.query(getTableName);
  }

  static Future<List<MUpload>> getAllRowsAsModel() async {
    List<Map<String, Object?>> allRows = await getAllRowsAsSqliteMap();
    List<MUpload> allRowModels = [];
    allRows.forEach(
      (row) {
        MUpload newRowModel = MUpload();
        newRowModel._rowModel.addAll(toModelMap(row));
        allRowModels.add(newRowModel);
      },
    );
    return allRowModels;
  }

  Map<String, Object?> _rowModel = {};



  String? get get_table_name => _rowModel[table_name] as String?;
  int? get get_row_id => _rowModel[row_id] as int?;
  String? get get_row_uuid => _rowModel[row_uuid] as String?;
  String? get get_upload_is_ok => _rowModel[upload_is_ok] as String?;
  int? get get_created_at => _rowModel[created_at] as int?;
  int? get get_updated_at => _rowModel[updated_at] as int?;

}
