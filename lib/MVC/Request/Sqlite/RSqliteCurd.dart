import 'package:jysp/Database/MergeModels/MMBase.dart';
import 'package:jysp/Database/Models/MBase.dart';
import 'package:jysp/Database/Models/MGlobalEnum.dart';
import 'package:jysp/Database/Models/MUpload.dart';
import 'package:jysp/G/GSqlite/GSqlite.dart';
import 'package:jysp/Tools/TDebug.dart';
import 'package:sqflite/sqflite.dart';

/// Sqlite 专属表（没有对应可匹配的 mysql 表）不可用当前类
///
/// T MBase 类型
class RSqliteCurd<T extends MBase> {
  ///

  RSqliteCurd.byModel(this.model) {
    if (MBase.modelCategory(tableName: model.getTableName) == ModelCategory.onlySqlite) {
      throw 'ModelCategory can not be onlySqlite';
    }
  }

  /// 需要被 CURD 的 [model]。
  T model;

  /// 需要被 CURD 的 [model] 对应的 [uploadModel]。
  late MUpload uploadModel;

  // ============================================================================
  //
  //
  // 注意事项：
  //
  // 事务中可以进行 txn.query，可以查询未提交的事务。
  //
  // 事务失败的原因是事务内部 throw 异常，因此不能在事务内部进行 try 异常，否则会导致事务被提交而被 try 的事务未提交。
  //
  // 事务中每条 sql 语句都必须 await
  //
  //
  // ============================================================================

  /// 返回被插入的 model，且该模型的 id 被赋值
  ///
  /// 返回 null 时，代表捕获到异常，即插入失败
  ///
  /// [connectTransaction] 不为空时，需在外部进行异常捕获
  Future<T?> toInsertRow({required Transaction? connectTransaction}) async {
    if (connectTransaction == null) {
      try {
        return await db.transaction<T>(
          (Transaction txn) async {
            return await _insertRow(connectTransaction: txn);
          },
        );
      } catch (e) {
        dLog(() => 'insert err: $e');
        return null;
      }
    } else {
      // 这里不能捕获异常，而必须在事务的外部捕获异常
      return await _insertRow(connectTransaction: connectTransaction);
    }
  }

  Future<T?> toUpdateRow({required Map<String, Object?> updateContent, required bool isReturnNewModel, required Transaction? connectTransaction}) async {
    if (connectTransaction == null) {
      try {
        return await db.transaction<T?>(
          (Transaction txn) async {
            return await _updateRow(updateContent: updateContent, isReturnNewModel: isReturnNewModel, connectTransaction: txn);
          },
        );
      } catch (e) {
        dLog(() => 'update err: $e');
        return null;
      }
    } else {
      // 这里不能捕获异常，而必须在事务的外部捕获异常
      return await _updateRow(updateContent: updateContent, isReturnNewModel: isReturnNewModel, connectTransaction: connectTransaction);
    }
  }

  /// 返回是否删除成功，捕获到异常返回 false
  Future<bool> toDeleteRow({required Transaction? connectTransaction}) async {
    if (connectTransaction == null) {
      try {
        await db.transaction<void>(
          (Transaction txn) async {
            await _deleteRow(connectTransaction: txn);
          },
        );
        return true;
      } catch (e, r) {
        dLog(() => 'delete err: $e---$r');
        return false;
      }
    } else {
      // 这里不能捕获异常，而必须在事务的外部捕获异常
      await _deleteRow(connectTransaction: connectTransaction);
      return true;
    }
  }

  ///
  ///
  ///
  ///
  ///

  /// 当 sqlite 应该存在 model 时，
  ///
  /// 检验 current model
  Future<void> _checkCurrentModel({required Transaction connectTransaction}) async {
    //
    // 只检查 model 的 aiid/uuid ,而不用再检查 sqlite，因为 model get_xx 是只读的。

    // 判断当前 model 的 id 是否存在
    final List<T> queryResult = await MBase.queryRowsAsModels<T, MMBase, T>(
      tableName: model.getTableName,
      where: 'id = ?',
      whereArgs: <Object?>[model.get_id],
      connectTransaction: connectTransaction,
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

  /// 当 sqlite 应该存在 model 时，
  ///
  /// 获取并检验 MUpload
  Future<void> _getMUploadAndcheck({required Transaction connectTransaction}) async {
    // 通过 MUpload 的 row_id 进行 find
    final List<MUpload> uploadModels = await MBase.queryRowsAsModels<MUpload, MMBase, MUpload>(
      tableName: MUpload.tableName,
      where: '${MUpload.row_id} = ? AND ${MUpload.table_name} = ?',
      whereArgs: <Object?>[model.get_id, model.getTableName],
      connectTransaction: connectTransaction,
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

      // 当前 model 的 aiid/uuid 与对应 MUpload 的不匹配
      if (uploadModel.get_row_aiid != model.get_aiid || uploadModel.get_row_uuid != model.get_uuid) {
        throw 'aiid/uuid err: ${uploadModel.get_row_aiid}-${model.get_aiid}-${uploadModel.get_row_uuid}-${model.get_uuid}';
      }
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
    }
  }

  /// 当 sqlite 应该存在 model 时，
  ///
  /// 查询并检验当前 model 以及对应的 MUpload
  Future<void> _haveModelAndMUpload({required Transaction connectTransaction}) async {
    // 必须按照这个顺序
    await _checkCurrentModel(connectTransaction: connectTransaction);
    await _getMUploadAndcheck(connectTransaction: connectTransaction);
  }

  /// 对 [model] 的 [insert] 操作。
  ///
  /// [return]：插入的模型（带有插入后 sqlite 生成的 id），未插入前的 model 不带有 id。
  ///
  /// 若已存在，则抛异常.
  Future<T> _insertRow({required Transaction connectTransaction}) async {
    // 插入时只存在 uuid
    if (model.get_uuid == null || model.get_aiid != null) {
      throw '${model.get_uuid}.${model.get_aiid}';
    }
    // 检查模型是否已存在
    final List<Map<String, Object?>> queryResult = await MBase.queryRowsAsJsons(
      tableName: model.getTableName,
      where: 'uuid = ?',
      whereArgs: <Object>[model.get_uuid!],
      connectTransaction: connectTransaction,
    );

    if (queryResult.isNotEmpty) {
      throw 'The model already exsits.';
    }

    final int rowId = await connectTransaction.insert(model.getTableName, model.getRowJson);
    model.getRowJson['id'] = rowId;
    await connectTransaction.insert(
      MUpload.tableName,
      MUpload.asJsonNoId(
        aiid_v: null,
        uuid_v: null,
        table_name_v: model.getTableName,
        row_id_v: rowId,
        row_aiid_v: model.get_aiid,
        row_uuid_v: model.get_uuid,
        updated_columns_v: null,
        curd_status_v: CurdStatus.C,
        upload_status_v: UploadStatus.notUploaded,
        created_at_v: DateTime.now().millisecondsSinceEpoch,
        updated_at_v: DateTime.now().millisecondsSinceEpoch,
      ),
    );
    return model;
  }

  ///
  ///
  ///
  ///
  ///

  /// 对 [model] 的 [update] 操作。
  ///
  /// - [updateContent]：更新的内容。
  /// - [isReturnNewModel]：是否返回新模型，为 false 时返回 null。
  ///
  /// 当将被 update 的 row 不存在时，会进行 create，这是 update 本身的特性。
  ///
  /// 但 [_haveModel] 函数已经让 [_updateRow] 函数的 row 必然存在。
  ///
  /// 当 {xx:null} 时，会将数据会覆盖成 null; 而 {不存在xx} 时，则并不进行覆盖。
  ///
  /// [return]：
  Future<T?> _updateRow({required Map<String, Object?> updateContent, required Transaction connectTransaction, required bool isReturnNewModel}) async {
    await _haveModelAndMUpload(connectTransaction: connectTransaction);

    // 新增的 UpdatedColumns 和原来的 UpdatedColumns 合并
    final List<String> updatedColumns = uploadModel.get_updated_columns == null ? <String>[] : uploadModel.get_updated_columns!.split(',');
    final String allUpdatedColumns = <String>{...updateContent.keys, ...updatedColumns}.toList().join(',');

    // 必然要 update model
    await connectTransaction.update(model.getTableName, updateContent, where: 'id = ?', whereArgs: <Object?>[model.get_id]);

    T? newModel;
    if (isReturnNewModel) {
      final List<T> queryResults = await MBase.queryRowsAsModels<T, MMBase, T>(
        tableName: model.getTableName,
        where: 'id = ?',
        whereArgs: <Object?>[model.get_id],
        connectTransaction: connectTransaction,
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
      await connectTransaction.insert(
        MUpload.tableName,
        MUpload.asJsonNoId(
          aiid_v: null,
          uuid_v: null,
          table_name_v: model.getTableName,
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
    else if (uploadModel.get_curd_status == CurdStatus.C) {
      await connectTransaction.update(
        MUpload.tableName,
        <String, Object?>{
          MUpload.updated_at: DateTime.now().millisecondsSinceEpoch,
        },
        where: '${MUpload.row_id} = ? AND ${MUpload.table_name} = ?',
        whereArgs: <Object?>[model.get_id, model.getTableName],
      );
    }

    // U
    else if (uploadModel.get_curd_status == CurdStatus.U) {
      await connectTransaction.update(
        MUpload.tableName,
        <String, Object?>{
          MUpload.updated_columns: allUpdatedColumns,
          MUpload.updated_at: DateTime.now().millisecondsSinceEpoch,
        },
        where: '${MUpload.row_id} = ? AND ${MUpload.table_name} = ?',
        whereArgs: <Object?>[model.get_id, model.getTableName],
      );
    } else {
      throw 'unkown currentCurdStatus: ${uploadModel.get_curd_status}';
    }

    return newModel;
  }

  /// 对 [model] 的 [delete] 操作。
  ///
  /// 当将被 delete 的 row 不存在时，并不会抛异常，这是 delete 本身的特性。
  Future<void> _deleteRow({required Transaction connectTransaction}) async {
    await _haveModelAndMUpload(connectTransaction: connectTransaction);

    // 无论 CURD 都需要删除本体
    await connectTransaction.delete(model.getTableName, where: 'id = ?', whereArgs: <Object?>[model.get_id]);

    // C
    if (uploadModel.get_curd_status == CurdStatus.C) {
      // 直接删除
      await connectTransaction.delete(
        MUpload.tableName,
        where: '${MUpload.row_id} = ? AND ${MUpload.table_name} = ?',
        whereArgs: <Object?>[model.get_id, model.getTableName],
      );
    }

    // U
    else if (uploadModel.get_curd_status == CurdStatus.U) {
      // 将本体对应的 MUpload 的 curd_status 置为 D
      await connectTransaction.update(
        MUpload.tableName,
        <String, Object?>{
          MUpload.curd_status: CurdStatus.D.index,
          MUpload.updated_at: DateTime.now().millisecondsSinceEpoch,
        },
        where: '${MUpload.row_id} = ? AND ${MUpload.table_name} = ?',
        whereArgs: <Object?>[model.get_id, model.getTableName],
      );
    }

    // R
    else if (uploadModel.get_curd_status == CurdStatus.R) {
      dLog(() => uploadModel.getTableName);
      // 生成本体对应的 MUpload ，并设 curd_status 为 D
      await connectTransaction.insert(
        MUpload.tableName,
        MUpload.asJsonNoId(
          aiid_v: uploadModel.get_aiid,
          uuid_v: uploadModel.get_uuid,
          table_name_v: uploadModel.get_table_name, // 注意这里不是 getTableName, 而是 get_table_name
          row_id_v: uploadModel.get_row_id,
          row_aiid_v: uploadModel.get_row_aiid,
          row_uuid_v: uploadModel.get_row_uuid,
          updated_columns_v: uploadModel.get_updated_columns,
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
    await _toDeleteForeignKeyBelongsTo(connectTransaction: connectTransaction);
    await _toDeleteForeignKeyHaveMany(connectTransaction: connectTransaction);
  }

  /// 筛选出需要同时删除的外键 row
  ///
  /// 这个函数（含内调用的函数）不会牵扯 MUpload 表，除了递归调用后。
  Future<void> _toDeleteForeignKeyBelongsTo({required Transaction connectTransaction}) async {
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
          connectTransaction: connectTransaction,
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
            connectTransaction: connectTransaction,
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
            connectTransaction: connectTransaction,
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
  Future<void> _toDeleteForeignKeyHaveMany({required Transaction connectTransaction}) async {
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
          connectTransaction: connectTransaction,
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
          connectTransaction: connectTransaction,
          tableName: manyTableName,
          columnName: manyColumnNameAiid,
          columnNameValue: currentColumnNameValueAiid,
        );
      } else if (currentColumnNameValueUuid != null) {
        await _recursionDelete(
          connectTransaction: connectTransaction,
          tableName: manyTableName,
          columnName: manyColumnNameUuid,
          columnNameValue: currentColumnNameValueUuid,
        );
      }
    }
  }

  /// 对每个被筛选出来的外键所对应的 row 进行递归 delete
  Future<void> _recursionDelete({required String tableName, required String columnName, required Object columnNameValue, required Transaction connectTransaction}) async {
    // 查询外键对应的 row 模型
    final List<MBase> queryResult = await MBase.queryRowsAsModels<MBase, MMBase, MBase>(
      tableName: tableName,
      where: '$columnName = ?',
      whereArgs: <Object>[columnNameValue],
      connectTransaction: connectTransaction,
      returnMWhere: (MBase model) => model,
      returnMMWhere: null,
    );

    // 把查询到的进行递归 delete
    if (queryResult.isNotEmpty) {
      await RSqliteCurd<MBase>.byModel(queryResult.first)._deleteRow(connectTransaction: connectTransaction);
    }
  }

  ///
}
