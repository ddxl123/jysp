import 'package:jysp/Database/Base/MBase.dart';
import 'package:jysp/Database/Models/GlobalEnum.dart';
import 'package:jysp/Database/Models/MUpload.dart';
import 'package:jysp/G/GSqlite/GSqlite.dart';
import 'package:jysp/Tools/TDebug.dart';
import 'package:sqflite/sqflite.dart';

/// Sqlite 专属表（没有对应可匹配的 mysql 表）不可用当前类
class RSqliteCurd {
  ///

  /// [model]：被 CURD 的 [model]。
  RSqliteCurd(this.model);

  /// 需要 CURD 的 [model]。
  late MBase model;

  /// 为 R 时代表 [MUpload] 表中不存在当前 [model]。
  late CurdStatus currentCurdStatus;

  /// 为 [ ] 或 存在一个及以上元素。
  late List<String> currentUpdatedColumns;

  /// 当前 [model] 的上传状态。
  late UploadStatus currentUploadStatus;

  /// 从 [MUpload] 中查询当前 [model]。
  Future<void> findFromUploadModel() async {
    try {
      final List<Map<String, Object?>> uploadResult = await db.query(
        MUpload.getTableName,
        where: '${MUpload.row_id} = ?',
        whereArgs: <Object?>[model.get_id],
      );

      // 若不存在时，代表只进行过 R
      if (uploadResult.isEmpty) {
        currentCurdStatus = CurdStatus.R;
        currentUpdatedColumns = <String>[];
        currentUploadStatus = UploadStatus.uploaded;
      } else {
        if (uploadResult.first[MUpload.curd_status] == null) {
          throw 'curd_status is null';
        } else {
          currentCurdStatus = uploadResult.first[MUpload.curd_status]! as CurdStatus;
        }

        if (uploadResult.first[MUpload.updated_columns] == null) {
          currentUpdatedColumns = <String>[];
        } else {
          currentUpdatedColumns = (uploadResult.first[MUpload.updated_columns]! as String).split(',');
        }

        if (uploadResult.first[MUpload.upload_status] == null) {
          throw 'upload_status is null';
        } else {
          currentUploadStatus = uploadResult.first[MUpload.upload_status]! as UploadStatus;
        }
      }
    } catch (e) {
      dLog(() => 'findFromUploadModel err: ', () => e);
      throw 'findFromUploadModel err';
    }
  }

  /// 对 [model] 的 [update] 操作。
  ///
  /// - [updateContent]：更新的内容。
  ///
  /// 当将被 update 的 row 不存在时，会进行 create，这是 update 本身的特性。
  Future<bool> update(Map<String, Object?> updateContent) async {
    try {
      // TODO: 检查该 model 是否仍然存在

      await findFromUploadModel();

      if (currentUploadStatus == UploadStatus.uploading) {
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
      if (currentCurdStatus == CurdStatus.R) {
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
      if (currentCurdStatus == CurdStatus.C) {
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
      else if (currentCurdStatus == CurdStatus.U) {
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

      throw 'unkown currentCurdStatus: $currentCurdStatus';
    } catch (e) {
      dLog(() => 'update err: ', () => e);
      return false;
    }
  }

  /// 对 [model] 的 [insert] 操作。
  Future<bool> insert() async {
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
  Future<bool> delete() async {
    // TODO: 检查该 model 是否存在

    await findFromUploadModel();

    // final Future<void> Function() toDelete = () async {};

    if (currentCurdStatus == CurdStatus.C) {
      final Batch batch = db.batch();
      // 删除本体
      batch.delete(model.getCurrentTableName, where: 'id = ?', whereArgs: <Object?>[model.get_id]);
      // 删除本体对应的 MUpload
      batch.delete(MUpload.getTableName, where: '${MUpload.row_id} = ?', whereArgs: <Object?>[model.get_id]);
      // 删除外键为本体且 isDeleteFatherFollowChild = true 的 row

      // 删除本体的外键且 isDeleteChildFollowFather = true 的 row
    }
  }

  ///
}
