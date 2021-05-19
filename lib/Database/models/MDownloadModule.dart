// ignore_for_file: non_constant_identifier_names
import 'package:jysp/Database/Models/MBase.dart';


enum SqliteDownloadStatus {downloaded,notDownload,}

class MDownloadModule implements MBase{

  MDownloadModule();

  /// 1. insert 时，无需传入 id ，id 是自增的。
  /// 2. 若只创建 model 而并非 inset，id 的值为 null。
  MDownloadModule.createModel({required int? aiid_v,required String? uuid_v,required String? module_name_v,required SqliteDownloadStatus? download_status_v,required int? created_at_v,required int? updated_at_v,}) {
    getRowJson.addAll(<String, Object?>{aiid:aiid_v,uuid:uuid_v,module_name:module_name_v,download_status:download_status_v?.index,created_at:created_at_v,updated_at:updated_at_v,});
  }

  static String get tableName => 'download_modules';

  static String get id => 'id';
  static String get aiid => 'aiid';
  static String get uuid => 'uuid';
  static String get module_name => 'module_name';
  static String get download_status => 'download_status';
  static String get created_at => 'created_at';
  static String get updated_at => 'updated_at';


  static Map<String, Object?> asJsonNoId({required int? aiid_v,required String? uuid_v,required String? module_name_v,required SqliteDownloadStatus? download_status_v,required int? created_at_v,required int? updated_at_v,}
  ) {
    return <String, Object?>{aiid:aiid_v,uuid:uuid_v,module_name:module_name_v,download_status:download_status_v?.index,created_at:created_at_v,updated_at:updated_at_v,};
  }

  static Map<String, Object?> asModelNoId(Map<String, Object?> json) {
    return <String, Object?>{aiid:json[aiid],uuid:json[uuid],module_name:json[module_name],download_status:json[download_status] == null ? null : SqliteDownloadStatus.values[json[download_status]! as int],created_at:json[created_at],updated_at:json[updated_at],};
  }

  // ====================================================================
  // ====================================================================

  @override
  String? getForeignKeyBelongsTos({required String foreignKeyName}) => <String,String?>{}[foreignKeyName];

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

@override int? get get_id => getRowJson[id] as int?;@override int? get get_aiid => getRowJson[aiid] as int?;@override String? get get_uuid => getRowJson[uuid] as String?; String? get get_module_name => getRowJson[module_name] as String?; SqliteDownloadStatus? get get_download_status => getRowJson[download_status] == null ? null : SqliteDownloadStatus.values[getRowJson[download_status]! as int];@override int? get get_created_at => getRowJson[created_at] as int?;@override int? get get_updated_at => getRowJson[updated_at] as int?;
}
