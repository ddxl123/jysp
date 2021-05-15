// ignore_for_file: non_constant_identifier_names
import 'package:jysp/Database/Models/MBase.dart';
import 'package:jysp/G/GSqlite/GSqlite.dart';

import 'package:sqflite/sqflite.dart';

enum SqliteDownloadStatus {downloaded,notDownload,}

class MDownloadModule implements MBase{

  MDownloadModule();

  /// 1. insert 时，无需传入 id ，id 是自增的。
  /// 2. 若只创建 model 而并非 inset，id 的值为 null。
  MDownloadModule.createModel({required int? aiid_v,required String? uuid_v,required String? module_name_v,required SqliteDownloadStatus? download_status_v,required int? created_at_v,required int? updated_at_v,}) {
    _rowJson.addAll(<String, Object?>{aiid:aiid_v,uuid:uuid_v,module_name:module_name_v,download_status:download_status_v?.index,created_at:created_at_v,updated_at:updated_at_v,});
  }

  static String get getTableName => 'download_modules';

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


  /// 若 [where]/[whereArgs] 为 null，则 query 的是全部 row。
  static Future<List<Map<String, Object?>>> queryRowsAsJsons({required String? where,required List<Object?>? whereArgs,required Transaction? connectTransaction}) async {
    if(connectTransaction != null)
    {
      return await connectTransaction.query(getTableName, where: where, whereArgs: whereArgs);
    }
    return await db.query(getTableName, where: where, whereArgs: whereArgs);
  }

  /// 若 [where]/[whereArgs] 为 null，则 query 的是全部 row。
  static Future<List<MDownloadModule>> queryRowsAsModels({required String? where,required List<Object?>? whereArgs,required Transaction? connectTransaction}) async {
    final List<Map<String, Object?>> rows = await queryRowsAsJsons(where: where, whereArgs: whereArgs,connectTransaction: connectTransaction);
    final List<MDownloadModule> rowModels = <MDownloadModule>[];
    for (final Map<String, Object?> row in rows) {
        final MDownloadModule newRowModel = MDownloadModule();
        newRowModel._rowJson.addAll(row);
        rowModels.add(newRowModel);
    }
    return rowModels;
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

  @override
  Map<String, Object?> get getRowJson => _rowJson;

  final Map<String, Object?> _rowJson = <String, Object?>{};

  @override
  String get getCurrentTableName => getTableName;

@override int? get get_id => _rowJson[id] as int?;@override int? get get_aiid => _rowJson[aiid] as int?;@override String? get get_uuid => _rowJson[uuid] as String?; String? get get_module_name => _rowJson[module_name] as String?; SqliteDownloadStatus? get get_download_status => _rowJson[download_status] == null ? null : SqliteDownloadStatus.values[_rowJson[download_status]! as int];@override int? get get_created_at => _rowJson[created_at] as int?;@override int? get get_updated_at => _rowJson[updated_at] as int?;
}
