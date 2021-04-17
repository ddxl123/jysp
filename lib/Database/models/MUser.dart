// ignore_for_file: non_constant_identifier_names
import 'package:jysp/G/GSqlite/GSqlite.dart';
import 'package:jysp/Database/models/GlobalEnum.dart';

class MUser {

  MUser();

  MUser.createModel({required int? user_id_v,required String? username_v,required String? email_v,required int? created_at_v,required int? updated_at_v,required Curd? curd_status_v,}) {
    _rowModel.addAll({user_id:user_id_v,username:username_v,email:email_v,created_at:created_at_v,updated_at:updated_at_v,curd_status:curd_status_v?.index,});
  }

  static String get getTableName => "users";

  static String get user_id => "user_id";
  static String get username => "username";
  static String get email => "email";
  static String get created_at => "created_at";
  static String get updated_at => "updated_at";
  static String get curd_status => "curd_status";


  static Map<String, Object?> toSqliteMap({required int? user_id_v,required String? username_v,required String? email_v,required int? created_at_v,required int? updated_at_v,required Curd? curd_status_v,}
  ) {
    return {user_id:user_id_v,username:username_v,email:email_v,created_at:created_at_v,updated_at:updated_at_v,curd_status:curd_status_v?.index,};
  }

  static Map<String, Object?> toModelMap(Map<String, Object?> sqliteMap) {
    return {user_id:sqliteMap[user_id],username:sqliteMap[username],email:sqliteMap[email],created_at:sqliteMap[created_at],updated_at:sqliteMap[updated_at],curd_status:sqliteMap[curd_status] == null ? null : Curd.values[sqliteMap[curd_status] as int],};
  }

  static Future<List<Map<String, Object?>>> getAllRowsAsSqliteMap() async {
    return await GSqlite.db.query(getTableName);
  }

  static Future<List<MUser>> getAllRowsAsModel() async {
    List<Map<String, Object?>> allRows = await getAllRowsAsSqliteMap();
    List<MUser> allRowModels = [];
    allRows.forEach(
      (row) {
        MUser newRowModel = MUser();
        newRowModel._rowModel.addAll(toModelMap(row));
        allRowModels.add(newRowModel);
      },
    );
    return allRowModels;
  }

  Map<String, Object?> _rowModel = {};



  int? get get_user_id => _rowModel[user_id] as int?;
  String? get get_username => _rowModel[username] as String?;
  String? get get_email => _rowModel[email] as String?;
  int? get get_created_at => _rowModel[created_at] as int?;
  int? get get_updated_at => _rowModel[updated_at] as int?;
  Curd? get get_curd_status => _rowModel[curd_status] as Curd?;

}
