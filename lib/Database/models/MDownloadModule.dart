// ignore_for_file: non_constant_identifier_names
import 'package:jysp/Database/Base/MBase.dart';
import 'package:jysp/G/GSqlite/GSqlite.dart';

enum SqliteDownloadStatus {downloaded,notDownload,}
class MDownloadModule implements MBase{

  MDownloadModule();

  /// 1. insert 时，无需传入 id ，id 是自增的。
  /// 2. 若只创建 model 而并非 inset，id 的值为 null。
  MDownloadModule.createModel({required int? atid_v,required String? uuid_v,required String? module_name_v,required SqliteDownloadStatus? download_status_v,required int? created_at_v,required int? updated_at_v,}) {
    _rowJson.addAll(<String, Object?>{atid:atid_v,uuid:uuid_v,module_name:module_name_v,download_status:download_status_v?.index,created_at:created_at_v,updated_at:updated_at_v,});
  }

  static String get getTableName => 'download_modules';

  static String get id => 'id';
  static String get atid => 'atid';
  static String get uuid => 'uuid';
  static String get module_name => 'module_name';
  static String get download_status => 'download_status';
  static String get created_at => 'created_at';
  static String get updated_at => 'updated_at';


  static Map<String, Object?> asJsonNoId({required int? atid_v,required String? uuid_v,required String? module_name_v,required SqliteDownloadStatus? download_status_v,required int? created_at_v,required int? updated_at_v,}
  ) {
    return <String, Object?>{atid:atid_v,uuid:uuid_v,module_name:module_name_v,download_status:download_status_v?.index,created_at:created_at_v,updated_at:updated_at_v,};
  }

  static Map<String, Object?> asModelNoId(Map<String, Object?> json) {
    return <String, Object?>{atid:json[atid],uuid:json[uuid],module_name:json[module_name],download_status:json[download_status] == null ? null : SqliteDownloadStatus.values[json[download_status]! as int],created_at:json[created_at],updated_at:json[updated_at],};
  }

  static Future<List<Map<String, Object?>>> getAllRowsAsJson() async {
    return await db.query(getTableName);
  }

  static Future<List<MDownloadModule>> getAllRowsAsModel() async {
    final List<Map<String, Object?>> allRows = await getAllRowsAsJson();
    final List<MDownloadModule> allRowModels = <MDownloadModule>[];
    for (final Map<String, Object?> row in allRows) {
        final MDownloadModule newRowModel = MDownloadModule();
        newRowModel._rowJson.addAll(row);
        allRowModels.add(newRowModel);
    }
    return allRowModels;
  }

  /// 值只有 int String bool null 类型，没有枚举类型，而是枚举的 int 值
  final Map<String, Object?> _rowJson = <String, Object?>{};

  @override
  Map<String, Object?> get getRowJson=> _rowJson;

  @override
  String get getCurrentTableName => getTableName;



@override int? get get_id => _rowJson[id] as int?;@override int? get get_atid => _rowJson[atid] as int?;@override String? get get_uuid => _rowJson[uuid] as String?; String? get get_module_name => _rowJson[module_name] as String?; SqliteDownloadStatus? get get_download_status => _rowJson[download_status] == null ? null : SqliteDownloadStatus.values[_rowJson[download_status]! as int];@override int? get get_created_at => _rowJson[created_at] as int?;@override int? get get_updated_at => _rowJson[updated_at] as int?;
}
