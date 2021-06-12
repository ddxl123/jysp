// ignore_for_file: non_constant_identifier_names
import 'package:jysp/database/models/MBase.dart';
import 'package:jysp/database/models/MGlobalEnum.dart';

enum UploadStatus {notUploaded,uploading,uploaded,}

class MUpload implements MBase{

  MUpload();

  /// 1. insert 时，无需传入 id ，id 是自增的。
  /// 2. 若只创建 model 而并非 inset，id 的值为 null。
  MUpload.createModel({required int? aiid_v,required String? uuid_v,required String? table_name_v,required int? row_id_v,required String? updated_columns_v,required CurdStatus? curd_status_v,required UploadStatus? upload_status_v,required int? mark_v,required int? created_at_v,required int? updated_at_v,}) {
    getRowJson.addAll(<String, Object?>{aiid:aiid_v,uuid:uuid_v,table_name:table_name_v,row_id:row_id_v,updated_columns:updated_columns_v,curd_status:curd_status_v?.index,upload_status:upload_status_v?.index,mark:mark_v,created_at:created_at_v,updated_at:updated_at_v,});
  }

  static String get tableName => 'uploads';

  static String get id => 'id';
  static String get aiid => 'aiid';
  static String get uuid => 'uuid';
  static String get table_name => 'table_name';
  static String get row_id => 'row_id';
  static String get updated_columns => 'updated_columns';
  static String get curd_status => 'curd_status';
  static String get upload_status => 'upload_status';
  static String get mark => 'mark';
  static String get created_at => 'created_at';
  static String get updated_at => 'updated_at';


  static Map<String, Object?> asJsonNoId({required int? aiid_v,required String? uuid_v,required String? table_name_v,required int? row_id_v,required String? updated_columns_v,required CurdStatus? curd_status_v,required UploadStatus? upload_status_v,required int? mark_v,required int? created_at_v,required int? updated_at_v,}
  ) {
    return <String, Object?>{aiid:aiid_v,uuid:uuid_v,table_name:table_name_v,row_id:row_id_v,updated_columns:updated_columns_v,curd_status:curd_status_v?.index,upload_status:upload_status_v?.index,mark:mark_v,created_at:created_at_v,updated_at:updated_at_v,};
  }

  static Map<String, Object?> asModelNoId(Map<String, Object?> json) {
    return <String, Object?>{aiid:json[aiid],uuid:json[uuid],table_name:json[table_name],row_id:json[row_id],updated_columns:json[updated_columns],curd_status:json[curd_status] == null ? null : CurdStatus.values[json[curd_status]! as int],upload_status:json[upload_status] == null ? null : UploadStatus.values[json[upload_status]! as int],mark:json[mark],created_at:json[created_at],updated_at:json[updated_at],};
  }

  // ====================================================================
  // ====================================================================

  @override
  String? getForeignKeyBelongsTos({required String foreignKeyName}) => <String,String?>{row_id: null,}[foreignKeyName];

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

  final Map<String, Object?> _rowJson = <String, Object?>{};

  @override
  Map<String, Object?> get getRowJson => _rowJson;


  @override
  String get getTableName => tableName;

@override int? get get_id => getRowJson[id] as int?;@override int? get get_aiid => getRowJson[aiid] as int?;@override String? get get_uuid => getRowJson[uuid] as String?; String? get get_table_name => getRowJson[table_name] as String?; int? get get_row_id => getRowJson[row_id] as int?; String? get get_updated_columns => getRowJson[updated_columns] as String?; CurdStatus? get get_curd_status => getRowJson[curd_status] == null ? null : CurdStatus.values[getRowJson[curd_status]! as int]; UploadStatus? get get_upload_status => getRowJson[upload_status] == null ? null : UploadStatus.values[getRowJson[upload_status]! as int]; int? get get_mark => getRowJson[mark] as int?;@override int? get get_created_at => getRowJson[created_at] as int?;@override int? get get_updated_at => getRowJson[updated_at] as int?;
}
