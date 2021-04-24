// ignore_for_file: non_constant_identifier_names
import 'package:jysp/Database/Base/MBase.dart';
import 'package:jysp/G/GSqlite/GSqlite.dart';
import 'package:jysp/Database/Models/GlobalEnum.dart';
enum UploadStatus {notUploaded,uploading,uploaded,}
class MUpload implements MBase{

  MUpload();

  /// 1. insert 时，无需传入 id ，id 是自增的。
  /// 2. 若只创建 model 而并非 inset，id 的值为 null。
  MUpload.createModel({required int? atid_v,required String? uuid_v,required String? table_name_v,required int? row_id_v,required int? row_atid_v,required String? row_uuid_v,required String? updated_columns_v,required CurdStatus? curd_status_v,required UploadStatus? upload_status_v,required int? created_at_v,required int? updated_at_v,}) {
    _rowJson.addAll(<String, Object?>{atid:atid_v,uuid:uuid_v,table_name:table_name_v,row_id:row_id_v,row_atid:row_atid_v,row_uuid:row_uuid_v,updated_columns:updated_columns_v,curd_status:curd_status_v?.index,upload_status:upload_status_v?.index,created_at:created_at_v,updated_at:updated_at_v,});
  }

  static String get getTableName => 'uploads';

  static String get id => 'id';
  static String get atid => 'atid';
  static String get uuid => 'uuid';
  static String get table_name => 'table_name';
  static String get row_id => 'row_id';
  static String get row_atid => 'row_atid';
  static String get row_uuid => 'row_uuid';
  static String get updated_columns => 'updated_columns';
  static String get curd_status => 'curd_status';
  static String get upload_status => 'upload_status';
  static String get created_at => 'created_at';
  static String get updated_at => 'updated_at';


  static Map<String, Object?> asJsonNoId({required int? atid_v,required String? uuid_v,required String? table_name_v,required int? row_id_v,required int? row_atid_v,required String? row_uuid_v,required String? updated_columns_v,required CurdStatus? curd_status_v,required UploadStatus? upload_status_v,required int? created_at_v,required int? updated_at_v,}
  ) {
    return <String, Object?>{atid:atid_v,uuid:uuid_v,table_name:table_name_v,row_id:row_id_v,row_atid:row_atid_v,row_uuid:row_uuid_v,updated_columns:updated_columns_v,curd_status:curd_status_v?.index,upload_status:upload_status_v?.index,created_at:created_at_v,updated_at:updated_at_v,};
  }

  static Map<String, Object?> asModelNoId(Map<String, Object?> json) {
    return <String, Object?>{atid:json[atid],uuid:json[uuid],table_name:json[table_name],row_id:json[row_id],row_atid:json[row_atid],row_uuid:json[row_uuid],updated_columns:json[updated_columns],curd_status:json[curd_status] == null ? null : CurdStatus.values[json[curd_status]! as int],upload_status:json[upload_status] == null ? null : UploadStatus.values[json[upload_status]! as int],created_at:json[created_at],updated_at:json[updated_at],};
  }

  static Future<List<Map<String, Object?>>> getAllRowsAsJson() async {
    return await db.query(getTableName);
  }

  static Future<List<MUpload>> getAllRowsAsModel() async {
    final List<Map<String, Object?>> allRows = await getAllRowsAsJson();
    final List<MUpload> allRowModels = <MUpload>[];
    for (final Map<String, Object?> row in allRows) {
        final MUpload newRowModel = MUpload();
        newRowModel._rowJson.addAll(row);
        allRowModels.add(newRowModel);
    }
    return allRowModels;
  }

  @override
  Map<String, Object?> get getRowJson => _rowJson;

  @override
  Map<String, String?> get getForeignKeyTables => _foreignKeyTables;

  @override
  List<String> get getDeleteChildFollowFathers => _deleteChildFollowFathers;

  @override
  List<String> get getDeleteFatherFollowChilds => _deleteFatherFollowChilds;

  final Map<String, Object?> _rowJson = <String, Object?>{};

  final Map<String, String?> _foreignKeyTables = <String, String?>{
  'row_id': null,
  'row_atid': null,
  'row_uuid': null
};

  final List<String> _deleteChildFollowFathers = <String>[];

  final List<String> _deleteFatherFollowChilds =<String>[];

  @override
  String get getCurrentTableName => getTableName;

@override int? get get_id => _rowJson[id] as int?;@override int? get get_atid => _rowJson[atid] as int?;@override String? get get_uuid => _rowJson[uuid] as String?; String? get get_table_name => _rowJson[table_name] as String?; int? get get_row_id => _rowJson[row_id] as int?; int? get get_row_atid => _rowJson[row_atid] as int?; String? get get_row_uuid => _rowJson[row_uuid] as String?; String? get get_updated_columns => _rowJson[updated_columns] as String?; CurdStatus? get get_curd_status => _rowJson[curd_status] == null ? null : CurdStatus.values[_rowJson[curd_status]! as int]; UploadStatus? get get_upload_status => _rowJson[upload_status] == null ? null : UploadStatus.values[_rowJson[upload_status]! as int];@override int? get get_created_at => _rowJson[created_at] as int?;@override int? get get_updated_at => _rowJson[updated_at] as int?;
}
