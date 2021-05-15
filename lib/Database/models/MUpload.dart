// ignore_for_file: non_constant_identifier_names
import 'package:jysp/Database/Models/MBase.dart';
import 'package:jysp/G/GSqlite/GSqlite.dart';
import 'package:jysp/Database/Models/MGlobalEnum.dart';
import 'package:sqflite/sqflite.dart';

enum UploadStatus {notUploaded,uploading,uploaded,}

class MUpload implements MBase{

  MUpload();

  /// 1. insert 时，无需传入 id ，id 是自增的。
  /// 2. 若只创建 model 而并非 inset，id 的值为 null。
  MUpload.createModel({required int? aiid_v,required String? uuid_v,required String? table_name_v,required int? row_id_v,required int? row_aiid_v,required String? row_uuid_v,required String? updated_columns_v,required CurdStatus? curd_status_v,required UploadStatus? upload_status_v,required int? created_at_v,required int? updated_at_v,}) {
    _rowJson.addAll(<String, Object?>{aiid:aiid_v,uuid:uuid_v,table_name:table_name_v,row_id:row_id_v,row_aiid:row_aiid_v,row_uuid:row_uuid_v,updated_columns:updated_columns_v,curd_status:curd_status_v?.index,upload_status:upload_status_v?.index,created_at:created_at_v,updated_at:updated_at_v,});
  }

  static String get getTableName => 'uploads';

  static String get id => 'id';
  static String get aiid => 'aiid';
  static String get uuid => 'uuid';
  static String get table_name => 'table_name';
  static String get row_id => 'row_id';
  static String get row_aiid => 'row_aiid';
  static String get row_uuid => 'row_uuid';
  static String get updated_columns => 'updated_columns';
  static String get curd_status => 'curd_status';
  static String get upload_status => 'upload_status';
  static String get created_at => 'created_at';
  static String get updated_at => 'updated_at';


  static Map<String, Object?> asJsonNoId({required int? aiid_v,required String? uuid_v,required String? table_name_v,required int? row_id_v,required int? row_aiid_v,required String? row_uuid_v,required String? updated_columns_v,required CurdStatus? curd_status_v,required UploadStatus? upload_status_v,required int? created_at_v,required int? updated_at_v,}
  ) {
    return <String, Object?>{aiid:aiid_v,uuid:uuid_v,table_name:table_name_v,row_id:row_id_v,row_aiid:row_aiid_v,row_uuid:row_uuid_v,updated_columns:updated_columns_v,curd_status:curd_status_v?.index,upload_status:upload_status_v?.index,created_at:created_at_v,updated_at:updated_at_v,};
  }

  static Map<String, Object?> asModelNoId(Map<String, Object?> json) {
    return <String, Object?>{aiid:json[aiid],uuid:json[uuid],table_name:json[table_name],row_id:json[row_id],row_aiid:json[row_aiid],row_uuid:json[row_uuid],updated_columns:json[updated_columns],curd_status:json[curd_status] == null ? null : CurdStatus.values[json[curd_status]! as int],upload_status:json[upload_status] == null ? null : UploadStatus.values[json[upload_status]! as int],created_at:json[created_at],updated_at:json[updated_at],};
  }


  /// 若 [where]/[whereArgs] 为 null，则 query 的是全部 row。
  static Future<List<Map<String, Object?>>> queryRowsAsJsons({required String? where,required List<Object?>? whereArgs,required Transaction? connectTransaction}) async {
    if(connectTransaction != null)
    {
      return await connectTransaction.query(getTableName, where: where, whereArgs: whereArgs);
    }
    return await db.query(getTableName, where: where, whereArgs: whereArgs);
  }

  /// 若 [where]/[whereArgs] 为 null，则 query 的是全部 row。
  static Future<List<MUpload>> queryRowsAsModels({required String? where,required List<Object?>? whereArgs,required Transaction? connectTransaction}) async {
    final List<Map<String, Object?>> rows = await queryRowsAsJsons(where: where, whereArgs: whereArgs,connectTransaction: connectTransaction);
    final List<MUpload> rowModels = <MUpload>[];
    for (final Map<String, Object?> row in rows) {
        final MUpload newRowModel = MUpload();
        newRowModel._rowJson.addAll(row);
        rowModels.add(newRowModel);
    }
    return rowModels;
  }

  // ====================================================================
  // ====================================================================

  @override
  String? getForeignKeyBelongsTos({required String foreignKeyName}) => <String,String?>{row_id: null,row_aiid: null,row_uuid: null,}[foreignKeyName];

  @override
  Set<String> get getDeleteForeignKeyFollowCurrentForTwo => <String>{};

  @override
  Set<String> get getDeleteForeignKeyFollowCurrentForSingle => <String>{};

  // ====================================================================

  @override
  List<String> get getDeleteManyForeignKeyForTwo => <String>[];

  @override
  List<String> get getDeleteManyForeignKeyForSingle => <String>[];

  // ====================================================================
  // ====================================================================

  @override
  Map<String, Object?> get getRowJson => _rowJson;

  final Map<String, Object?> _rowJson = <String, Object?>{};

  @override
  String get getCurrentTableName => getTableName;

@override int? get get_id => _rowJson[id] as int?;@override int? get get_aiid => _rowJson[aiid] as int?;@override String? get get_uuid => _rowJson[uuid] as String?; String? get get_table_name => _rowJson[table_name] as String?; int? get get_row_id => _rowJson[row_id] as int?; int? get get_row_aiid => _rowJson[row_aiid] as int?; String? get get_row_uuid => _rowJson[row_uuid] as String?; String? get get_updated_columns => _rowJson[updated_columns] as String?; CurdStatus? get get_curd_status => _rowJson[curd_status] == null ? null : CurdStatus.values[_rowJson[curd_status]! as int]; UploadStatus? get get_upload_status => _rowJson[upload_status] == null ? null : UploadStatus.values[_rowJson[upload_status]! as int];@override int? get get_created_at => _rowJson[created_at] as int?;@override int? get get_updated_at => _rowJson[updated_at] as int?;
}
