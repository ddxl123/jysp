import 'dart:convert';

import 'package:jysp/Database/both/TFragmentPoolNode.dart';
import 'package:jysp/G/G.dart';
import 'package:jysp/G/GHttp.dart';
import 'package:jysp/MVC/Controllers/FragmentPoolController.dart';
import 'package:jysp/Tools/TDebug.dart';
import 'package:sqflite/sqflite.dart';

mixin LayoutNodesRequest on FragmentPoolControllerRoot {
  ///

  ///
  /// return true 时：获取数据成功。
  ///
  /// return false 时：获取数据异常。
  ///
  /// return null 时：获取数据成功，但 toPool 被中断。
  Future<bool?> layoutNodesRequest(PoolType toPoolType) async {
    return await _sqlite(toPoolType);
  }

  Future<bool?> _sqlite(PoolType toPoolType) async {
    // 本地/云端获取数据是否成功
    bool? isSuccess = false;

    // 进行本地查询
    await G.sqlite.db.query(TFragmentPoolNode.getTableName, where: '${TFragmentPoolNode.pool_type} = ?', whereArgs: [toPoolType.index]).then(
      (data) async {
        // 若本地中一个也没有，则代表未初始化，需向云端请求数据
        if (data.length == 0) {
          dLog(() => "本地查询到 0 个结果");

          // 这里也必须 await，否则屏障直接会被关闭
          isSuccess = await _cloud(toPoolType);
        }

        // 若本地中存在，则代表已初始化过，无需向云端请求数据，直接使用即可
        else {
          dLog(() => "本地查询到至少一个结果：", () => data);
          isSuccess = await _saveToSqliteAndSetToRoot(toPoolType, data, true);
        }
      },
    ).catchError((onError) {
      dLog(() => "本地查询 err:" + onError);
      isSuccess = false;
    });

    return isSuccess;
  }

  /// TODO: GET /api/get_fragment_pool_nodes
  Future<bool?> _cloud(PoolType toPoolType) async {
    bool? isSuccess = false;
    await G.http.sendRequest(
      method: "GET",
      route: "api/get_fragment_pool_nodes",
      isAuth: true,
      queryParameters: {"pool_type": toPoolType.index},
      sameNotConcurrent: "layoutNodesRequest_cloud",
      resultCallback: ({int? code, dynamic? data}) async {
        switch (code) {
          case 300:
            dLog(() => "缺少 pool_type 参数");
            isSuccess = false;
            break;
          case 301:
            dLog(() => "从 mysql 中获取当前碎片池节点成功:", () => data);
            // 将获取的数据存储至 sqlite
            isSuccess = await _saveToSqliteAndSetToRoot(toPoolType, data, false);
            break;
          case 302:
            dLog(() => "获取当前碎片池节点异常");
            isSuccess = false;
            break;
          default:
            dLog(() => "unknown code:$code");
            isSuccess = false;
        }
      },
      interruptedCallback: (GeneralRequestInterruptedStatus generalRequestInterruptedStatus) {
        isSuccess = false;
        dLog(() => generalRequestInterruptedStatus);
      },
    );
    return isSuccess;
  }

  Future<bool?> _saveToSqliteAndSetToRoot(PoolType toPoolType, dynamic data, bool isDataFromSqlite) async {
    if (data == null) {
      dLog(() => "data is null");
      return false;
    }

    // sqlite query 到的数据是只读状态，因此需要对其深拷贝
    data = jsonDecode(jsonEncode(data));

    // 检查 data 是否为 List<Map> 类型
    // - data=[] 不属于 List<Map> 类型，而属于 List<dynamic> 类型，因此 "[] is List<Map>" is false，但是 [].cast<Map>() 会返回 []
    // - cast 后，地址与上一个 data 不同
    List<Map> dataCorrect;
    try {
      dataCorrect = (data as List<dynamic>).cast<Map>();
    } catch (e) {
      dLog(() => "data is not List<Map> type");
      return false;
    }

    if (isDataFromSqlite) {
      return await _sqliteData(toPoolType, dataCorrect, isDataFromSqlite);
    } else {
      return await _mysqlData(toPoolType, dataCorrect, isDataFromSqlite);
    }
  }

  Future<bool> _sqliteData(PoolType toPoolType, List<Map> data, bool isDataFromSqlite) async {
    return this.setFragmentPoolNodes(
      (nodes) {
        nodes.clear();
        nodes.addAll(data);
      },
      toPoolType,
    );
  }

  Future<bool> _mysqlData(PoolType toPoolType, List<Map> data, bool isDataFromSqlite) async {
    Batch batch = G.sqlite.db.batch();
    List<Map> needData = [];

    try {
      for (int i = 0; i < data.length; i++) {
        // 检查不能为 null 的字段
        if (data[i][TFragmentPoolNode.fragment_pool_node_id] == null || data[i][TFragmentPoolNode.pool_type] == null) {
          dLog(() => "必要值为 null");
          return false;
        }

        // 待插入
        Map<String, dynamic> single = TFragmentPoolNode.toMap(
          fragment_pool_node_id_v: data[i][TFragmentPoolNode.fragment_pool_node_id],
          fragment_pool_node_id_s_v: data[i][TFragmentPoolNode.fragment_pool_node_id_s], //因为是 sqlite 生成，插入的 _s 是 null 值
          pool_type_v: data[i][TFragmentPoolNode.pool_type],
          node_type_v: data[i][TFragmentPoolNode.node_type],
          position_v: data[i][TFragmentPoolNode.position],
          name_v: data[i][TFragmentPoolNode.name],
          created_at_v: data[i][TFragmentPoolNode.created_at],
          updated_at_v: data[i][TFragmentPoolNode.updated_at],
        );
        batch.insert(TFragmentPoolNode.getTableName, single, conflictAlgorithm: ConflictAlgorithm.replace);
        needData.add(single);
      }
    } catch (e) {
      // 可能是 值类型 错误，比如 String 赋值给了 int
      dLog(() => "待插入失败:$e");
      return false;
    }

    bool isSuccess = false;
    // 提交待插入
    await batch.commit(continueOnError: false).then(
      (onValue) async {
        dLog(() => "fragment_pool_nodes 插入至 sqlite 成功");
        // 插入成功。
        // 将获取到的值赋予给需要的变量中。
        isSuccess = this.setFragmentPoolNodes(
          (nodes) {
            nodes.clear();
            nodes.addAll(needData);
          },
          toPoolType,
        );
      },
    ).catchError(
      (onError) {
        dLog(() => "提交待插入数据失败：" + onError.toString());
        isSuccess = false;
      },
    );

    return isSuccess;
  }
}
