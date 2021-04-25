// ignore_for_file: non_constant_identifier_names
import 'package:jysp/Database/Base/MBase.dart';
import 'package:jysp/G/GSqlite/GSqlite.dart';


class MToken implements MBase{

  MToken();

  /// 1. insert 时，无需传入 id ，id 是自增的。
  /// 2. 若只创建 model 而并非 inset，id 的值为 null。
  MToken.createModel({required int? atid_v,required String? uuid_v,required String? access_token_v,required String? refresh_token_v,required int? created_at_v,required int? updated_at_v,}) {
    _rowJson.addAll(<String, Object?>{atid:atid_v,uuid:uuid_v,access_token:access_token_v,refresh_token:refresh_token_v,created_at:created_at_v,updated_at:updated_at_v,});
  }

  static String get getTableName => 'tokens';

  static String get id => 'id';
  static String get atid => 'atid';
  static String get uuid => 'uuid';
  static String get access_token => 'access_token';
  static String get refresh_token => 'refresh_token';
  static String get created_at => 'created_at';
  static String get updated_at => 'updated_at';


  static Map<String, Object?> asJsonNoId({required int? atid_v,required String? uuid_v,required String? access_token_v,required String? refresh_token_v,required int? created_at_v,required int? updated_at_v,}
  ) {
    return <String, Object?>{atid:atid_v,uuid:uuid_v,access_token:access_token_v,refresh_token:refresh_token_v,created_at:created_at_v,updated_at:updated_at_v,};
  }

  static Map<String, Object?> asModelNoId(Map<String, Object?> json) {
    return <String, Object?>{atid:json[atid],uuid:json[uuid],access_token:json[access_token],refresh_token:json[refresh_token],created_at:json[created_at],updated_at:json[updated_at],};
  }

  /// 若 [byId] 为 null，则 query 的是全部 row。
  static Future<List<Map<String, Object?>>> queryRowsAsJsons([int? byId]) async {
    if (byId == null) {
      return await db.query(getTableName);
    } else {
      return await db.query(getTableName, where: 'id = ?', whereArgs: <int>[byId]);
    }
  }

  /// 若 [byId] 为 null，则 query 的是全部 row。
  static Future<List<MToken>> queryRowsAsModels([int? byId]) async {
    final List<Map<String, Object?>> rows = await queryRowsAsJsons(byId);
    final List<MToken> rowModels = <MToken>[];
    for (final Map<String, Object?> row in rows) {
        final MToken newRowModel = MToken();
        newRowModel._rowJson.addAll(row);
        rowModels.add(newRowModel);
    }
    return rowModels;
  }

  @override
  Map<String, Object?> get getRowJson => _rowJson;

  @override
  Map<String, String?> get getForeignKeyTableNames => _foreignKeyTableNames;

  @override
  List<String> get getDeleteChildFollowFathers => _deleteChildFollowFathers;

  @override
  List<String> get getDeleteFatherFollowChilds => _deleteFatherFollowChilds;

  final Map<String, Object?> _rowJson = <String, Object?>{};

  final Map<String, String?> _foreignKeyTableNames = <String, String?>{};

  final List<String> _deleteChildFollowFathers = <String>[];

  final List<String> _deleteFatherFollowChilds =<String>[];

  @override
  String get getCurrentTableName => getTableName;

@override int? get get_id => _rowJson[id] as int?;@override int? get get_atid => _rowJson[atid] as int?;@override String? get get_uuid => _rowJson[uuid] as String?; String? get get_access_token => _rowJson[access_token] as String?; String? get get_refresh_token => _rowJson[refresh_token] as String?;@override int? get get_created_at => _rowJson[created_at] as int?;@override int? get get_updated_at => _rowJson[updated_at] as int?;
}
