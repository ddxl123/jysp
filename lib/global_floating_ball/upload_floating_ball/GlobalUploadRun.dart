import 'package:jysp/database/merge_models/MMBase.dart';
import 'package:jysp/database/models/MBase.dart';
import 'package:jysp/database/models/MUpload.dart';

// ignore: avoid_classes_with_only_static_members
class GlobalUploadRun {
  ///

  /// 是否自动上传
  static bool isAutoUpload = true;

  /// 正在上传的数据
  static List<MUpload> uploadings = <MUpload>[];

  ///
  static Future<void> setUploads() async {
    final List<MUpload> result = await MBase.queryRowsAsModels<MUpload, MMBase, MUpload>(
      connectTransaction: null,
      tableName: MUpload.tableName,
      returnMMWhere: null,
      returnMWhere: (MUpload model) {
        return model;
      },
    );
    uploadings.addAll(result);
  }

  ///
}
