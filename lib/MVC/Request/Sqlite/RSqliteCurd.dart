import 'package:jysp/Database/Base/MBase.dart';
import 'package:jysp/Database/Models/GlobalEnum.dart';
import 'package:jysp/Database/Models/MUpload.dart';
import 'package:jysp/G/GSqlite/GSqlite.dart';
import 'package:jysp/Tools/TDebug.dart';
import 'package:sqflite/sqflite.dart';

class RSqliteCurd {
  ///

  /// 对 [model] 的 [update] 操作。
  /// - [model]：被更新的 [model] —— [sqlite] 映射过来的。
  /// - [updateContent]：更新的内容。
  /// - 当将被 update 的 row 不存在时，会进行 create，这是 update 本身的特性。
  Future<bool> update(MBase model, Map<String, Object?> updateContent) async {
    try {
      // TODO: 检查该 model 是否仍然存在

      // 从 MUpload 中查询当前 model。
      final List<Map<String, Object?>> uploadResult = await db.query(
        MUpload.getTableName,
        where: '${MUpload.row_id} = ?',
        whereArgs: <Object?>[model.get_id],
      );

      // 为 R 时代表 MUpload 中不存在当前 model
      CurdStatus currentStatus;

      // 为 [] 或 存在一个及以上元素
      List<String> currentUpdatedColumns;

      // 当前 model 的上传状态
      UploadStatus uploadStatus;

      // 若不存在时，代表只进行过 R
      if (uploadResult.isEmpty) {
        currentStatus = CurdStatus.R;
        currentUpdatedColumns = <String>[];
        uploadStatus = UploadStatus.uploaded;
      } else {
        if (uploadResult.first[MUpload.curd_status] == null) {
          throw 'curd_status is null';
        } else {
          currentStatus = uploadResult.first[MUpload.curd_status]! as CurdStatus;
        }

        if (uploadResult.first[MUpload.updated_columns] == null) {
          currentUpdatedColumns = <String>[];
        } else {
          currentUpdatedColumns = (uploadResult.first[MUpload.updated_columns]! as String).split(',');
        }

        if (uploadResult.first[MUpload.upload_status] == null) {
          throw 'upload_status is null';
        } else {
          uploadStatus = uploadResult.first[MUpload.upload_status]! as UploadStatus;
        }
      }

      if (uploadStatus == UploadStatus.uploading) {
        // TODO: 需要先重新进行上传后才能继续
      }

      // 新增的 UpdatedColumns 和原来的 UpdatedColumns 合并
      final String allUpdatedColumns = <String>{...updateContent.keys, ...currentUpdatedColumns}.toList().join(',');

      // 必然要 update model
      final Future<void> Function(Function(Batch)) toUpdate = (Function(Batch batch) uploadCallback) async {
        final Batch batch = db.batch();
        batch.update(model.getCurrentTableName, updateContent, where: 'id = ?', whereArgs: <Object?>[model.get_id]);
        uploadCallback(batch);
        await batch.commit();
      };

      // R
      if (currentStatus == CurdStatus.R) {
        await toUpdate(
          (Batch batch) {
            batch.insert(
              MUpload.getTableName,
              MUpload.asJsonNoId(
                atid_v: null,
                uuid_v: null,
                table_name_v: model.getCurrentTableName,
                row_id_v: model.get_id,
                row_atid_v: model.get_atid,
                row_uuid_v: model.get_uuid,
                updated_columns_v: allUpdatedColumns,
                curd_status_v: CurdStatus.U,
                upload_status_v: UploadStatus.notUploaded,
                created_at_v: DateTime.now().millisecondsSinceEpoch,
                updated_at_v: DateTime.now().millisecondsSinceEpoch,
              ),
            );
          },
        );
        return true;
      }

      // C
      if (currentStatus == CurdStatus.C) {
        await toUpdate(
          (Batch batch) {
            batch.update(
              MUpload.getTableName,
              <String, Object?>{
                MUpload.updated_at: DateTime.now().millisecondsSinceEpoch,
              },
              where: '${MUpload.row_id} = ?',
              whereArgs: <Object?>[model.get_id],
            );
          },
        );
        return true;
      }

      // U
      else if (currentStatus == CurdStatus.U) {
        await toUpdate(
          (Batch batch) {
            batch.update(
              MUpload.getTableName,
              <String, Object?>{
                MUpload.updated_columns: allUpdatedColumns,
                MUpload.updated_at: DateTime.now().millisecondsSinceEpoch,
              },
              where: '${MUpload.row_id} = ?',
              whereArgs: <Object?>[model.get_id],
            );
          },
        );
        return true;
      }

      // 其他
      dLog(() => 'unkown currentStatus: ', () => currentStatus);
      return false;
    } catch (e) {
      dLog(() => 'update err: ', () => e);
      return false;
    }
  }

  /// 对 [model] 的 [insert] 操作。
  /// - [model]：将被插入的 [model]
  Future<bool> insert(MBase model) async {
    // TODO: 检查模型是否已存在，根据 atid 和 uuid 来检查

    try {
      final Batch batch = db.batch();
      batch.insert(model.getCurrentTableName, model.getRowJson);
      batch.insert(
        MUpload.getTableName,
        MUpload.asJsonNoId(
          atid_v: null,
          uuid_v: null,
          table_name_v: model.getCurrentTableName,
          row_id_v: model.get_id,
          row_atid_v: model.get_atid,
          row_uuid_v: model.get_uuid,
          updated_columns_v: null,
          curd_status_v: CurdStatus.C,
          upload_status_v: UploadStatus.notUploaded,
          created_at_v: DateTime.now().millisecondsSinceEpoch,
          updated_at_v: DateTime.now().millisecondsSinceEpoch,
        ),
      );
      await batch.commit();
      return true;
    } catch (e) {
      dLog(() => 'insert err: ', () => e);
      return false;
    }
  }

  /// 对 [model] 的 [delete] 操作。
  /// - [model]：将被删除的 [model]
  Future<bool> delete() async {}

  ///
}
