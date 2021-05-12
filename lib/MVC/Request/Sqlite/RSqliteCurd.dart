import 'package:jysp/Database/Models/MBase.dart';
import 'package:jysp/Database/Models/MDownloadModule.dart';
import 'package:jysp/Database/Models/MGlobalEnum.dart';
import 'package:jysp/Database/Models/MUpload.dart';
import 'package:jysp/Database/Models/MVersionInfo.dart';
import 'package:jysp/Tools/TDebug.dart';
import 'package:sqflite/sqflite.dart';

/// Sqlite 专属表（没有对应可匹配的 mysql 表）不可用当前类
///
/// T MBase 类型
class RSqliteCurd {
  ///

  RSqliteCurd.byModel(this.model) {
    if (MBase.modelCategory(tableName: model.getCurrentTableName) == ModelCategory.onlySqlite) {
      throw 'ModelCategory can not be onlySqlite';
    }
  }

  /// 需要被 CURD 的 [model]。
  MBase model;

  /// 需要被 CURD 的 [model] 对应的 [uploadModel]。
  late MUpload uploadModel;

  /// 对 [model] 的 [insert] 操作。
  ///
  /// 若已存在，则抛异常
  Future<bool> insertRow({required Batch connectBatch, required bool isConnectBatchCommitInternal}) async {
    try {
      // 插入时只存在 uuid
      if (model.get_uuid == null || model.get_aiid != null) {
        throw '${model.get_uuid}.${model.get_aiid}';
      }

      // 检查模型是否已存在
      final List<Map<String, Object?>> queryResult = await MBase.queryByTableNameAsJsons(
        tableName: model.getCurrentTableName,
        where: 'uuid = ?',
        whereArgs: <Object>[model.get_uuid!],
      );

      if (queryResult.isNotEmpty) {
        throw 'The model already exsits.';
      }

      connectBatch.insert(model.getCurrentTableName, model.getRowJson);
      connectBatch.insert(
        MUpload.getTableName,
        MUpload.asJsonNoId(
          aiid_v: null,
          uuid_v: null,
          table_name_v: model.getCurrentTableName,
          row_id_v: model.get_id,
          row_aiid_v: model.get_aiid,
          row_uuid_v: model.get_uuid,
          updated_columns_v: null,
          curd_status_v: CurdStatus.C,
          upload_status_v: UploadStatus.notUploaded,
          created_at_v: DateTime.now().millisecondsSinceEpoch,
          updated_at_v: DateTime.now().millisecondsSinceEpoch,
        ),
      );

      if (isConnectBatchCommitInternal) {
        await connectBatch.commit();
      }

      return true;
    } catch (e) {
      dLog(() => 'insert err: ', () => e);
      return false;
    }
  }

  /// 对 [model] 的 [update] 操作。
  ///
  /// - [updateContent]：更新的内容。
  ///
  /// 当将被 update 的 row 不存在时，会进行 create，这是 update 本身的特性。
  Future<bool> updateRow({required Map<String, Object?> updateContent, required Batch connectBatch, required bool isConnectBatchCommitInternal}) async {
    try {
      await findRowFromUpload();

      // 新增的 UpdatedColumns 和原来的 UpdatedColumns 合并
      final List<String> updatedColumns = uploadModel.get_updated_columns == null ? <String>[] : uploadModel.get_updated_columns!.split(',');
      final String allUpdatedColumns = <String>{...updateContent.keys, ...updatedColumns}.toList().join(',');

      // 必然要 update model
      connectBatch.update(model.getCurrentTableName, updateContent, where: 'id = ?', whereArgs: <Object?>[model.get_id]);

      // R
      if (uploadModel.get_curd_status == CurdStatus.R) {
        connectBatch.insert(
          MUpload.getTableName,
          MUpload.asJsonNoId(
            aiid_v: null,
            uuid_v: null,
            table_name_v: model.getCurrentTableName,
            row_id_v: model.get_id,
            row_aiid_v: model.get_aiid,
            row_uuid_v: model.get_uuid,
            updated_columns_v: allUpdatedColumns,
            curd_status_v: CurdStatus.U,
            upload_status_v: UploadStatus.notUploaded,
            created_at_v: DateTime.now().millisecondsSinceEpoch,
            updated_at_v: DateTime.now().millisecondsSinceEpoch,
          ),
        );
      }

      // C
      if (uploadModel.get_curd_status == CurdStatus.C) {
        connectBatch.update(
          MUpload.getTableName,
          <String, Object?>{
            MUpload.updated_at: DateTime.now().millisecondsSinceEpoch,
          },
          where: '${MUpload.row_id} = ?',
          whereArgs: <Object?>[model.get_id],
        );
      }

      // U
      else if (uploadModel.get_curd_status == CurdStatus.U) {
        connectBatch.update(
          MUpload.getTableName,
          <String, Object?>{
            MUpload.updated_columns: allUpdatedColumns,
            MUpload.updated_at: DateTime.now().millisecondsSinceEpoch,
          },
          where: '${MUpload.row_id} = ?',
          whereArgs: <Object?>[model.get_id],
        );
      } else {
        throw 'unkown currentCurdStatus: ${uploadModel.get_curd_status}';
      }

      if (isConnectBatchCommitInternal) {
        await connectBatch.commit();
      }

      return true;
    } catch (e) {
      dLog(() => 'update err: ', () => e);
      return false;
    }
  }

  /// 对 [model] 的 [delete] 操作。
  ///
  /// 当将被 delete 的 row 不存在时，并不会抛异常，这是 delete 本身的特性。
  Future<bool> deleteRow({required Batch connectBatch, required bool isConnectBatchCommitInternal}) async {
    try {
      await findRowFromUpload();

      // 无论 CURD 都需要删除本体
      connectBatch.delete(model.getCurrentTableName, where: 'id = ?', whereArgs: <Object?>[model.get_id]);

      // C
      if (uploadModel.get_curd_status == CurdStatus.C) {
        // 直接删除本体对应的 MUpload
        connectBatch.delete(
          MUpload.getTableName,
          where: '${MUpload.row_id} = ?',
          whereArgs: <Object?>[model.get_id],
        );
      }

      // U
      else if (uploadModel.get_curd_status == CurdStatus.U) {
        // 将本体对应的 MUpload 的 curd_status 置为 D
        connectBatch.update(
          MUpload.getTableName,
          <String, Object?>{
            MUpload.curd_status: CurdStatus.D,
            MUpload.updated_at: DateTime.now().millisecondsSinceEpoch,
          },
          where: '${MUpload.row_id} = ?',
          whereArgs: <Object?>[model.get_id],
        );
      }

      // R
      else if (uploadModel.get_curd_status == CurdStatus.R) {
        // 生成本体对应的 MUpload ，并设 curd_status 为 D
        connectBatch.insert(
          MUpload.getTableName,
          MUpload.asJsonNoId(
            aiid_v: null,
            uuid_v: null,
            table_name_v: model.getCurrentTableName,
            row_id_v: model.get_id,
            row_aiid_v: model.get_aiid,
            row_uuid_v: model.get_uuid,
            updated_columns_v: null,
            curd_status_v: CurdStatus.D,
            upload_status_v: UploadStatus.notUploaded,
            created_at_v: DateTime.now().millisecondsSinceEpoch,
            updated_at_v: DateTime.now().millisecondsSinceEpoch,
          ),
        );
      }

      // D or null or unknown
      else {
        throw 'uploadModel.get_curd_status == ${uploadModel.get_curd_status.toString()}';
      }

      // 同时删除外键约束
      await _toDeleteForeignKeyBelongsTo(connectBatch: connectBatch);
      await _toDeleteForeignKeyHaveMany(connectBatch: connectBatch);

      // 若全部递归完成（全部递归都处在同一条异步中），则提交事务
      if (isConnectBatchCommitInternal) {
        await connectBatch.commit();
      }

      return true;
    } catch (e) {
      dLog(() => 'delete err: ', () => e);
      return false;
    }
  }

  /// 筛选出需要同时删除的外键 row
  ///
  /// 这个函数（含内调用的函数）不会牵扯 MUpload 表，除了递归调用后。
  Future<void> _toDeleteForeignKeyBelongsTo({required Batch connectBatch}) async {
    // for single
    for (int i = 0; i < model.getDeleteForeignKeyFollowCurrentForSingle.length; i++) {
      final String foreignKeyName = model.getDeleteForeignKeyFollowCurrentForSingle.elementAt(i);
      final Object? foreignKeyValue = model.getRowJson[foreignKeyName];
      final String? foreignKeyColumnNameWithTableName = model.getForeignKeyBelongsTos(foreignKeyName: foreignKeyName);
      final List<String>? foreignKeyTableNameAndColumnName = foreignKeyColumnNameWithTableName == null ? null : foreignKeyColumnNameWithTableName.split('.');
      late String foreignKeyTableName;
      late String foreignKeyColumnName;

      // 若该外键有对应的值，且，
      // 若该外键有对应的表（本地 sqlite 中没有对应的表）。
      if (foreignKeyValue != null && foreignKeyTableNameAndColumnName != null) {
        foreignKeyTableName = foreignKeyTableNameAndColumnName[0];
        foreignKeyColumnName = foreignKeyTableNameAndColumnName[1];
        await _recursionDelete(
          connectBatch: connectBatch,
          tableName: foreignKeyTableName,
          columnName: foreignKeyColumnName,
          columnNameValue: foreignKeyValue,
        );
      }
    }

    // for two
    for (int i = 0; i < model.getDeleteForeignKeyFollowCurrentForTwo.length; i++) {
      final String foreignKeyNameForAiid = model.getDeleteForeignKeyFollowCurrentForTwo.elementAt(i) + '_aiid';
      final String foreignKeyNameForUuid = model.getDeleteForeignKeyFollowCurrentForTwo.elementAt(i) + '_uuid';
      final int? foreignKeyValueForAiid = model.getRowJson[foreignKeyNameForAiid] as int?;
      final String? foreignKeyValueForUuid = model.getRowJson[foreignKeyNameForUuid] as String?;

      final String? foreignKeyColumnNameWithTableNameAiid = model.getForeignKeyBelongsTos(foreignKeyName: foreignKeyNameForAiid);
      final String? foreignKeyColumnNameWithTableNameUuid = model.getForeignKeyBelongsTos(foreignKeyName: foreignKeyNameForUuid);
      final List<String>? foreignKeyTableNameAndColumnNameAiid = foreignKeyColumnNameWithTableNameAiid == null ? null : foreignKeyColumnNameWithTableNameAiid.split('.');
      final List<String>? foreignKeyTableNameAndColumnNameUuid = foreignKeyColumnNameWithTableNameUuid == null ? null : foreignKeyColumnNameWithTableNameUuid.split('.');
      late String foreignKeyTableNameAiid;
      late String foreignKeyTableNameUuid;
      late String foreignKeyColumnNameAiid;
      late String foreignKeyColumnNameUuid;

      // 若该外键有对应的值
      if (foreignKeyValueForAiid != null && foreignKeyValueForUuid != null) {
        throw '$foreignKeyValueForAiid.$foreignKeyValueForUuid';
      } else if (foreignKeyValueForAiid != null) {
        // 若该外键有对应的表（本地 sqlite 中没有对应的表）。
        if (foreignKeyTableNameAndColumnNameAiid != null) {
          foreignKeyTableNameAiid = foreignKeyTableNameAndColumnNameAiid[0];
          foreignKeyColumnNameAiid = foreignKeyTableNameAndColumnNameAiid[1];
          await _recursionDelete(
            connectBatch: connectBatch,
            tableName: foreignKeyTableNameAiid,
            columnName: foreignKeyColumnNameAiid,
            columnNameValue: foreignKeyValueForAiid,
          );
        }
      } else if (foreignKeyValueForUuid != null) {
        // 若该外键有对应的表（本地 sqlite 中没有对应的表）。
        if (foreignKeyTableNameAndColumnNameUuid != null) {
          foreignKeyTableNameUuid = foreignKeyTableNameAndColumnNameUuid[0];
          foreignKeyColumnNameUuid = foreignKeyTableNameAndColumnNameUuid[1];
          await _recursionDelete(
            connectBatch: connectBatch,
            tableName: foreignKeyTableNameUuid,
            columnName: foreignKeyColumnNameUuid,
            columnNameValue: foreignKeyValueForUuid,
          );
        }
      }
    }
  }

  /// 筛选出需要同时删除其他关联该表中的外键的 row
  ///
  /// 这个函数（含内调用的函数）不会牵扯 MUpload 表，除了递归调用后。
  Future<void> _toDeleteForeignKeyHaveMany({required Batch connectBatch}) async {
    // for single
    for (int i = 0; i < model.getDeleteManyForeignKeyForSingle.length; i++) {
      final List<String> manyTableNameAndColumnNameAndCurrentColumnName = model.getDeleteManyForeignKeyForSingle[i].split('.');
      final String manyTableName = manyTableNameAndColumnNameAndCurrentColumnName[0];
      final String manyColumnName = manyTableNameAndColumnNameAndCurrentColumnName[1];
      final String currentColumnName = manyTableNameAndColumnNameAndCurrentColumnName[2];
      final Object? currentValue = model.getRowJson[currentColumnName];

      // 若 value 为 null，则说明其外表关联的键为 null，意味着没有值没有被关联(row 名被关联)
      if (currentValue != null) {
        await _recursionDelete(
          connectBatch: connectBatch,
          tableName: manyTableName,
          columnName: manyColumnName,
          columnNameValue: currentValue,
        );
      }
    }

    // for two
    for (int i = 0; i < model.getDeleteManyForeignKeyForTwo.length; i++) {
      final List<String> manyTableNameAndColumnNameAndCurrentColumnName = model.getDeleteManyForeignKeyForTwo[i].split('.');
      final String manyTableName = manyTableNameAndColumnNameAndCurrentColumnName[0];
      final String manyColumnName = manyTableNameAndColumnNameAndCurrentColumnName[1];
      final String currentColumnName = manyTableNameAndColumnNameAndCurrentColumnName[2];

      // 转换为 aiid/uuid/_aiid/uuid 后缀
      final String manyColumnNameAiid = manyColumnName + '_aiid';
      final String manyColumnNameUuid = manyColumnName + '_uuid';
      late String currentColumnNameAiid;
      late String currentColumnNameUuid;
      if (currentColumnName == '') {
        currentColumnNameAiid = 'aiid';
        currentColumnNameUuid = 'uuid';
      } else {
        currentColumnNameAiid = currentColumnName + '_aiid';
        currentColumnNameUuid = currentColumnName + '_uuid';
      }

      final int? currentColumnNameValueAiid = model.getRowJson[currentColumnNameAiid] as int?;
      final String? currentColumnNameValueUuid = model.getRowJson[currentColumnNameUuid] as String?;

      // 若当前被引用的键有对应的值
      if (currentColumnNameValueAiid != null && currentColumnNameValueUuid != null) {
        throw '$currentColumnNameValueAiid.$currentColumnNameValueUuid';
      } else if (currentColumnNameValueAiid != null) {
        await _recursionDelete(
          connectBatch: connectBatch,
          tableName: manyTableName,
          columnName: manyColumnNameAiid,
          columnNameValue: currentColumnNameValueAiid,
        );
      } else if (currentColumnNameValueUuid != null) {
        await _recursionDelete(
          connectBatch: connectBatch,
          tableName: manyTableName,
          columnName: manyColumnNameUuid,
          columnNameValue: currentColumnNameValueUuid,
        );
      }
    }
  }

  /// 对每个被筛选出来的外键所对应的 row 进行递归 delete
  Future<void> _recursionDelete({required Batch connectBatch, required String tableName, required String columnName, required Object columnNameValue}) async {
    // 查询外键对应的 row 模型
    final List<MBase> query = await MBase.queryByTableNameAsModels(
      tableName: tableName,
      where: '$columnName = ?',
      whereArgs: <Object>[columnNameValue],
    );

    // length 为 0 时，说明对应的 row 已被 delete
    // 把查询到的进行递归 delete
    if (query.isNotEmpty) {
      await RSqliteCurd.byModel(query.first).deleteRow(connectBatch: connectBatch, isConnectBatchCommitInternal: false);
    }
  }

  /// 从 [MUpload] 中查询当前 [row]。
  Future<void> findRowFromUpload() async {
    try {
      // 通过 MUpload 的 row_id 进行 find
      final List<MUpload> uploadModels = await MUpload.queryRowsAsModels(
        where: '${MUpload.row_id} = ?',
        whereArgs: <Object?>[model.get_id],
      );

      // 若不存在时，代表只进行过 R
      if (uploadModels.isEmpty) {
        uploadModel = MUpload.createModel(
          aiid_v: null,
          uuid_v: null,
          table_name_v: model.getCurrentTableName,
          row_id_v: model.get_id,
          row_aiid_v: model.get_aiid,
          row_uuid_v: model.get_uuid,
          updated_columns_v: null,
          curd_status_v: CurdStatus.R, // 主要是要配置这个选项
          upload_status_v: UploadStatus.uploaded,
          created_at_v: null,
          updated_at_v: null,
        );
      } else {
        uploadModel = uploadModels.first;
      }

      // curd_status_v 不为 CurdStatus 时，在 curd 操作中进行判断，不在这里判断

      // 若为 uploading 状态，则需要先判断是否已经 upload 成功，成功则修改成 uploaded 后才能继续。
      if (uploadModel.get_upload_status == null) {
        throw '${uploadModel.get_upload_status}';
      } else if (uploadModel.get_upload_status == UploadStatus.uploading) {
        //TODO: 从 mysql 中对照是否 upload 成功过，若成功过则设为 uploaded，若未成功过则进行 upload 后再设为 uploaded
      }
    } catch (e) {
      dLog(() => e);
      throw 'findFromUploadModel err: $e';
    }
  }

  ///
}
