import 'package:jysp/database/g_sqlite/GSqlite.dart';
import 'package:jysp/database/merge_models/MMBase.dart';
import 'package:jysp/database/models/MBase.dart';
import 'package:jysp/database/models/MGlobalEnum.dart';
import 'package:jysp/database/models/MUpload.dart';
import 'package:jysp/tools/Helper.dart';
import 'package:jysp/tools/TDebug.dart';
import 'package:sqflite/sqflite.dart';

// ============================================================================
//
// 事务中可以进行 txn.query，即可以查询已修改但未提交的事务。
//
// 事务失败的原因是事务内部 throw 异常，因此不能在事务内部进行 try 异常，否则就算 err 也会提交事务。
//
// 需要中途取消事务，则直接在内部 throw 即可。
//
// 事务中每条 sql 语句都必须 await。
//
// ============================================================================

///
///
///
///
///

/// 我们每次 CURD 都会依赖于事务，因此上传队列的每行之间都存在着事务关联，
/// 若要上传到云端，就必须让云端方也遵循相应的事务关联。
///
/// 每次 CURD 都有且仅有一个 [transaction] 对象进行连接。
/// 同时，有 [transaction] 则必须同时有 [mark]。
/// 上传队列中所有属于同一事务的行需要做相同标记 [mark]，
/// [mark] 使用时间戳来标记，以便每个 [TransactionMark] 具有唯一性。
class TransactionMark {
  TransactionMark(this.transaction) {
    mark = createCurrentTimestamp();
  }
  Transaction transaction;
  late int mark;
}

///
///
///
///
///

class RSqliteCurd<T extends MBase> {
  ///

  ///! 只有存储至本地后，需要待上传至后端数据库进行存储的数据，才可使用这个方法。
  RSqliteCurd.byModel(this.model) {
    if (MBase.modelCategory(tableName: model.getTableName) == ModelCategory.onlySqlite) {
      throw 'ModelCategory can not be onlySqlite';
    }
  }

  /// 需要被 CURD 的 [model]。
  T model;

  /// 当前 [model] 对应的 [uploadModel]。
  late MUpload uploadModel;

  ///
  ///
  ///
  ///
  ///

  /// {@macro RSqliteCurd.insertRow}
  Future<T?> insertRow({required TransactionMark? transactionMark}) async {
    if (transactionMark == null) {
      try {
        return await db.transaction<T>(
          (Transaction txn) async {
            return await _toInsertRow(transactionMark: TransactionMark(txn));
          },
        );
      } catch (e) {
        dLog(() => 'insert err: $e');
        return null;
      }
    } else {
      // 这里不能捕获异常，而必须在事务的外部捕获异常
      return await _toInsertRow(transactionMark: transactionMark);
    }
  }

  /// {@macro RSqliteCurd.updateRow}
  Future<T?> updateRow({required Map<String, Object?> updateContent, required bool isReturnNewModel, required TransactionMark? transactionMark}) async {
    if (transactionMark == null) {
      try {
        return await db.transaction<T?>(
          (Transaction txn) async {
            return await _toUpdateRow(updateContent: updateContent, isReturnNewModel: isReturnNewModel, transactionMark: TransactionMark(txn));
          },
        );
      } catch (e) {
        dLog(() => 'update err: $e');
        return null;
      }
    } else {
      // 这里不能捕获异常，而必须在事务的外部捕获异常
      return await _toUpdateRow(updateContent: updateContent, isReturnNewModel: isReturnNewModel, transactionMark: transactionMark);
    }
  }

  /// {@macro RSqliteCurd.deleteRow}
  ///
  /// 返回是否删除成功，捕获到异常返回 false
  Future<bool> deleteRow({required TransactionMark? transactionMark}) async {
    if (transactionMark == null) {
      try {
        await db.transaction<void>(
          (Transaction txn) async {
            await _toDeleteRow(transactionMark: TransactionMark(txn));
          },
        );
        return true;
      } catch (e, r) {
        dLog(() => 'delete err: $e---$r');
        return false;
      }
    } else {
      // 这里不能捕获异常，而必须在事务的外部捕获异常
      await _toDeleteRow(transactionMark: transactionMark);
      return true;
    }
  }

  ///
  ///
  ///
  ///
  ///

  /// 检验当前 [model]。
  Future<void> _checkCurrentModel({required TransactionMark transactionMark}) async {
    //
    // 只检查 model 的 aiid/uuid ,而不用再检查 sqlite，因为 model get_xx 是只读的。

    // 判断当前 model 的 id 是否存在
    final List<T> queryResult = await MBase.queryRowsAsModels<T, MMBase, T>(
      tableName: model.getTableName,
      where: 'id = ?',
      whereArgs: <Object?>[model.get_id],
      connectTransaction: transactionMark.transaction,
      returnMWhere: (T model) => model,
      returnMMWhere: null,
    );
    // 2种情况：model.get_id == null 或 查询到 0 个
    if (queryResult.isEmpty) {
      throw 'Current model does not exsit!';
    }
    // aiid/uuid 不能同时为 null 且不能同时不为 null
    if ((queryResult.first.get_aiid == null && queryResult.first.get_uuid == null) || (queryResult.first.get_aiid != null && queryResult.first.get_uuid != null)) {
      throw 'aiid/uuid err: ${queryResult.first.get_aiid}-${queryResult.first.get_uuid}-${queryResult.first.get_aiid}-${queryResult.first.get_uuid}';
    }
  }

  /// 获取并检验当前 [model] 对应的 [MUpload]。
  Future<void> _getMUploadAndcheck({required TransactionMark transactionMark}) async {
    // 通过 MUpload 的 row_id 进行 find
    final List<MUpload> uploadModels = await MBase.queryRowsAsModels<MUpload, MMBase, MUpload>(
      tableName: MUpload.tableName,
      where: '${MUpload.row_id} = ? AND ${MUpload.table_name} = ?',
      whereArgs: <Object?>[model.get_id, model.getTableName],
      connectTransaction: transactionMark.transaction,
      returnMWhere: (MUpload model) => model,
      returnMMWhere: null,
    );

    // 若不存在时，代表只进行过 R
    if (uploadModels.isEmpty) {
      uploadModel = MUpload.createModel(
        aiid_v: null,
        uuid_v: null,
        table_name_v: model.getTableName,
        row_id_v: model.get_id,
        updated_columns_v: null,
        curd_status_v: CurdStatus.R, // 主要是要配置这个选项
        upload_status_v: UploadStatus.uploaded,
        mark_v: null,
        created_at_v: null,
        updated_at_v: null,
      );
    } else {
      uploadModel = uploadModels.first;

      // 当前 model 的 aiid/uuid 与对应 MUpload 的不匹配
      // if (uploadModel.get_row_aiid != model.get_aiid || uploadModel.get_row_uuid != model.get_uuid) {
      //   throw 'aiid/uuid err: ${uploadModel.get_row_aiid}-${model.get_aiid}-${uploadModel.get_row_uuid}-${model.get_uuid}';
      // }
      // 当前 model 的 table_name 与对应的 MUpload 的不匹配
      if (uploadModel.get_table_name != model.getTableName) {
        throw 'table_name err: ${uploadModel.get_table_name}-${model.getTableName}';
      }
    }

    // curd_status_v 不为 CurdStatus 对应的状态时，会在 curd 操作中进行判断，不在这里判断

    // 若为 uploading 状态，则需要先判断是否已经 upload 成功，成功则修改成 uploaded 后才能继续。
    if (uploadModel.get_upload_status == null) {
      throw '${uploadModel.get_upload_status}';
    } else if (uploadModel.get_upload_status == UploadStatus.uploading) {
      //TODO: 从 mysql 中对照是否 upload 成功过，若成功过则设为 uploaded，若未成功过则进行 upload 后再设为 uploaded
      throw '${uploadModel.get_upload_status}';
    }
  }

  /// 当 sqlite 应该存在当前 [model] 时，获取并检验当前 [model] 以及对应的 [MUpload]
  Future<void> _haveModelAndMUpload({required TransactionMark transactionMark}) async {
    // 必须按照这个顺序
    await _checkCurrentModel(transactionMark: transactionMark);
    await _getMUploadAndcheck(transactionMark: transactionMark);
  }

  ///
  ///
  ///
  ///
  ///

  /// {@template RSqliteCurd.insertRow}
  ///
  /// 对当前 [model] 执行 [insert] 操作。
  ///
  /// 返回插入的模型（带有插入后 sqlite 生成的 id），未插入前的 [model] 不带有 id。
  /// 返回 null 时，代表捕获到异常，即插入失败。若插入的 [model] 已存在，则会抛异常。
  ///
  /// - [transactionMark] 不为空时，需在外部进行异常捕获。
  ///
  /// {@endtemplate}
  Future<T> _toInsertRow({required TransactionMark transactionMark}) async {
    // 插入时只存在 uuid
    if (model.get_uuid == null || model.get_aiid != null) {
      throw '${model.get_uuid}.${model.get_aiid}';
    }
    // 检查模型是否已存在
    final List<Map<String, Object?>> queryResult = await MBase.queryRowsAsJsons(
      tableName: model.getTableName,
      where: 'uuid = ?',
      whereArgs: <Object>[model.get_uuid!],
      connectTransaction: transactionMark.transaction,
    );

    if (queryResult.isNotEmpty) {
      throw 'The model already exsits.';
    }

    final int rowId = await transactionMark.transaction.insert(model.getTableName, model.getRowJson);
    model.getRowJson['id'] = rowId;
    await transactionMark.transaction.insert(
      MUpload.tableName,
      MUpload.asJsonNoId(
        aiid_v: null,
        uuid_v: null,
        table_name_v: model.getTableName,
        row_id_v: rowId,
        updated_columns_v: null,
        curd_status_v: CurdStatus.C,
        upload_status_v: UploadStatus.notUploaded,
        mark_v: transactionMark.mark,
        created_at_v: DateTime.now().millisecondsSinceEpoch,
        updated_at_v: DateTime.now().millisecondsSinceEpoch,
      ),
    );
    return model;
  }

  /// {@template RSqliteCurd.updateRow}
  ///
  /// 对 [model] 的 [update] 操作。
  ///
  /// 当将被 update 的 row 不存在时，会进行 create，这是 update 本身的特性。
  /// 但 [_haveModelAndMUpload] 函数已经让被更新的 row 必然存在，不存在则会抛异常。
  ///
  /// 当 { xx:null } 时，会将数据会覆盖成 null; 而 { 不存在xx } 时，则并不进行覆盖。
  ///
  /// - [updateContent]：更新的内容。
  ///
  /// - [isReturnNewModel]：是否返回新模型，为 false 时返回 null。
  ///
  /// - [transactionMark] 不为空时，需在外部进行异常捕获。
  ///
  /// {@endtemplate}
  Future<T?> _toUpdateRow({required Map<String, Object?> updateContent, required TransactionMark transactionMark, required bool isReturnNewModel}) async {
    await _haveModelAndMUpload(transactionMark: transactionMark);

    // 新增的 UpdatedColumns 和原来的 UpdatedColumns 合并
    final List<String> updatedColumns = uploadModel.get_updated_columns == null ? <String>[] : uploadModel.get_updated_columns!.split(',');
    final String allUpdatedColumns = <String>{...updateContent.keys, ...updatedColumns}.toList().join(',');

    // 必然要 update model
    await transactionMark.transaction.update(model.getTableName, updateContent, where: 'id = ?', whereArgs: <Object?>[model.get_id]);

    T? newModel;
    if (isReturnNewModel) {
      final List<T> queryResults = await MBase.queryRowsAsModels<T, MMBase, T>(
        tableName: model.getTableName,
        where: 'id = ?',
        whereArgs: <Object?>[model.get_id],
        connectTransaction: transactionMark.transaction,
        returnMWhere: (T model) => model,
        returnMMWhere: null,
      );
      if (queryResults.isEmpty) {
        throw 'query result is empty';
      } else {
        newModel = queryResults.first;
      }
    } else {
      newModel = null;
    }

    // R
    if (uploadModel.get_curd_status == CurdStatus.R) {
      await transactionMark.transaction.insert(
        MUpload.tableName,
        MUpload.asJsonNoId(
          aiid_v: null,
          uuid_v: null,
          table_name_v: model.getTableName,
          row_id_v: model.get_id,
          updated_columns_v: allUpdatedColumns,
          curd_status_v: CurdStatus.U,
          upload_status_v: UploadStatus.notUploaded,
          mark_v: transactionMark.mark,
          created_at_v: DateTime.now().millisecondsSinceEpoch,
          updated_at_v: DateTime.now().millisecondsSinceEpoch,
        ),
      );
    }

    // C
    else if (uploadModel.get_curd_status == CurdStatus.C) {
      _toUpdateMUpload(
        transactionMark: transactionMark,
        updateContent: <String, Object?>{
          MUpload.mark: transactionMark.mark,
          MUpload.updated_at: DateTime.now().millisecondsSinceEpoch,
        },
      );
    }

    // U
    else if (uploadModel.get_curd_status == CurdStatus.U) {
      _toUpdateMUpload(
        transactionMark: transactionMark,
        updateContent: <String, Object?>{
          MUpload.updated_columns: allUpdatedColumns,
          MUpload.mark: transactionMark.mark,
          MUpload.updated_at: DateTime.now().millisecondsSinceEpoch,
        },
      );
    } else {
      throw 'unkown currentCurdStatus: ${uploadModel.get_curd_status}';
    }

    return newModel;
  }

  /// {@template RSqliteCurd.deleteRow}
  ///
  /// 对 [model] 的 [delete] 操作。
  ///
  /// 当将被 delete 的 row 不存在时，并不会抛异常，这是 delete 本身的特性。
  /// 但 [_haveModelAndMUpload] 函数已经让被删除的 row 必然存在，不存在则会抛异常。
  ///
  /// {@endtemplate}
  Future<void> _toDeleteRow({required TransactionMark transactionMark}) async {
    await _haveModelAndMUpload(transactionMark: transactionMark);

    // 无论 CURD 都需要删除本体
    await transactionMark.transaction.delete(model.getTableName, where: 'id = ?', whereArgs: <Object?>[model.get_id]);

    // C
    if (uploadModel.get_curd_status == CurdStatus.C) {
      // 直接删除
      await transactionMark.transaction.delete(
        MUpload.tableName,
        where: '${MUpload.row_id} = ? AND ${MUpload.table_name} = ?',
        whereArgs: <Object?>[model.get_id, model.getTableName],
      );
    }

    // U
    else if (uploadModel.get_curd_status == CurdStatus.U) {
      // 将本体对应的 MUpload 的 curd_status 置为 D
      _toUpdateMUpload(
        transactionMark: transactionMark,
        updateContent: <String, Object?>{
          MUpload.curd_status: CurdStatus.D.index,
          MUpload.mark: transactionMark.mark,
          MUpload.updated_at: DateTime.now().millisecondsSinceEpoch,
        },
      );
    }

    // R
    else if (uploadModel.get_curd_status == CurdStatus.R) {
      dLog(() => uploadModel.getTableName);
      // 生成本体对应的 MUpload ，并设 curd_status 为 D
      await transactionMark.transaction.insert(
        MUpload.tableName,
        MUpload.asJsonNoId(
          aiid_v: uploadModel.get_aiid,
          uuid_v: uploadModel.get_uuid,
          table_name_v: uploadModel.get_table_name, // 注意这里不是 getTableName, 而是 get_table_name
          row_id_v: uploadModel.get_row_id,
          updated_columns_v: uploadModel.get_updated_columns,
          curd_status_v: CurdStatus.D,
          upload_status_v: UploadStatus.notUploaded,
          mark_v: transactionMark.mark,
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
    await _toDeleteForeignKeyBelongsTo(transactionMark: transactionMark);
    await _toDeleteForeignKeyHaveMany(transactionMark: transactionMark);
  }

  ///
  ///
  ///
  ///
  ///

  /// 对当前 [MUpload] 进行删除操作。
  Future<void> _toDeleteMUpload({required TransactionMark transactionMark}) async {
    await transactionMark.transaction.delete(
      MUpload.tableName,
      where: '${MUpload.row_id} = ? AND ${MUpload.table_name} = ?',
      whereArgs: <Object?>[model.get_id, model.getTableName],
    );
  }

  /// 对当前 [MUpload] 进行更新操作。
  Future<void> _toUpdateMUpload({required TransactionMark transactionMark, required Map<String, Object?> updateContent}) async {
    await _toDeleteMUpload(transactionMark: transactionMark);

    // 防止插入到原先的 id 上。
    uploadModel.getRowJson.remove(MUpload.id);
    for (int i = 0; i < updateContent.length; i++) {
      uploadModel.getRowJson[updateContent.keys.elementAt(i)] = updateContent.values.elementAt(i);
    }
    await transactionMark.transaction.insert(MUpload.tableName, uploadModel.getRowJson);
  }

  /// 筛选出需要同时删除的 foreginKey-row。
  Future<void> _toDeleteForeignKeyBelongsTo({required TransactionMark transactionMark}) async {
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
          transactionMark: transactionMark,
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
            transactionMark: transactionMark,
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
            transactionMark: transactionMark,
            tableName: foreignKeyTableNameUuid,
            columnName: foreignKeyColumnNameUuid,
            columnNameValue: foreignKeyValueForUuid,
          );
        }
      }
    }
  }

  /// 筛选出需要同时删除的 关联该表的其他表对应的 row。
  Future<void> _toDeleteForeignKeyHaveMany({required TransactionMark transactionMark}) async {
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
          transactionMark: transactionMark,
          tableName: manyTableName,
          columnName: manyColumnName,
          columnNameValue: currentValue,
        );
      }
    }

    dLog(() => model.getDeleteManyForeignKeyForTwo);
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

      // 若当前被引用的键都没有对应的值
      if (currentColumnNameValueAiid != null && currentColumnNameValueUuid != null) {
        throw '$currentColumnNameValueAiid.$currentColumnNameValueUuid';
      } else if (currentColumnNameValueAiid != null) {
        await _recursionDelete(
          transactionMark: transactionMark,
          tableName: manyTableName,
          columnName: manyColumnNameAiid,
          columnNameValue: currentColumnNameValueAiid,
        );
      } else if (currentColumnNameValueUuid != null) {
        await _recursionDelete(
          transactionMark: transactionMark,
          tableName: manyTableName,
          columnName: manyColumnNameUuid,
          columnNameValue: currentColumnNameValueUuid,
        );
      }
    }
  }

  /// 对每个被筛选出来的 row 进行递归 delete。
  Future<void> _recursionDelete({required String tableName, required String columnName, required Object columnNameValue, required TransactionMark transactionMark}) async {
    // 查询外键对应的 row 模型
    final List<MBase> queryResult = await MBase.queryRowsAsModels<MBase, MMBase, MBase>(
      tableName: tableName,
      where: '$columnName = ?',
      whereArgs: <Object>[columnNameValue],
      connectTransaction: transactionMark.transaction,
      returnMWhere: (MBase model) => model,
      returnMMWhere: null,
    );

    // 把查询到的进行递归 delete
    if (queryResult.isNotEmpty) {
      for (int i = 0; i < queryResult.length; i++) {
        await RSqliteCurd<MBase>.byModel(queryResult[i])._toDeleteRow(transactionMark: transactionMark);
      }
    }
  }

  ///
}
