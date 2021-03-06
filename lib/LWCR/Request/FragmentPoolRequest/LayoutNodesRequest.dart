import 'package:jysp/Database/both/TFragmentPoolNode.dart';
import 'package:jysp/FragmentPool/FragmentPoolEnum.dart';
import 'package:jysp/G/G.dart';
import 'package:jysp/G/GHttp.dart';
import 'package:jysp/LWCR/Controller/FragmentPoolController.dart';
import 'package:jysp/Tools/TDebug.dart';
import 'package:sqflite/sqflite.dart';

mixin LayoutNodesRequest on FragmentPoolControllerRoot {
  ///

  Future<bool> layoutNodesRequest(PoolType toPoolType, bool isCancelToPool) async {
    return await _sqlite(toPoolType, isCancelToPool);
  }

  Future<bool> _sqlite(PoolType toPoolType, bool isCancelToPool) async {
    // 本地/云端获取数据是否成功
    bool isSuccess = false;

    // 进行本地查询
    await G.sqlite.db.query(TFragmentPoolNode.getTableName, where: 'node_type = ?', whereArgs: [toPoolType.index]).then(
      (successData) async {
        // 若本地中一个也没有，则代表未初始化，需向云端请求数据
        if (successData.length == 0) {
          dLog(() => "本地查询到 0 个结果");

          // 这里也必须 await，否则屏障直接会被关闭
          isSuccess = await _cloud(toPoolType, isCancelToPool);
        }

        // 若本地中存在，则代表已初始化过，无需向云端请求数据，直接使用即可
        else {
          dLog(() => "本地查询到至少一个结果：", () => successData);
          isSuccess = await _saveToSqliteAndSetToRoot(toPoolType, successData, isCancelToPool, true);
        }
      },
    ).catchError((onError) {
      dLog(() => "本地查询 err:" + onError);
      isSuccess = false;
    });

    return isSuccess;
  }

  /// TODO: GET /api/get_fragment_pool_nodes
  Future<bool> _cloud(PoolType toPoolType, bool isCancelToPool) async {
    bool isSuccess = false;
    await G.http.sendRequest(
      method: "GET",
      route: "api/get_fragment_pool_nodes",
      isAuth: true,
      queryParameters: {"pool_type": toPoolType.index},
      sameNotConcurrent: "layoutNodesRequest_cloud",
      resultCallback: ({int code, data}) async {
        switch (code) {
          case 300:
            dLog(() => "缺少 pool_type 参数");
            isSuccess = false;
            break;
          case 301:
            dLog(() => "从 mysql 中获取当前碎片池节点成功:", () => data);
            // 将获取的数据存储至 sqlite
            isSuccess = await _saveToSqliteAndSetToRoot(toPoolType, data, isCancelToPool, false);
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

  Future<bool> _saveToSqliteAndSetToRoot(PoolType toPoolType, dynamic data, bool isCancelToPool, bool isDataFromSqlite) async {
    // 若被取消，则不对数据进行操作
    if (isCancelToPool) {
      // 只有这一处返回的是 null
      return null;
    }
    if (isDataFromSqlite) {
      return await _sqliteData(toPoolType, data, isCancelToPool, isDataFromSqlite);
    } else {
      return await _mysqlData(toPoolType, data, isCancelToPool, isDataFromSqlite);
    }
  }

  Future<bool> _sqliteData(PoolType toPoolType, dynamic data, bool isCancelToPool, bool isDataFromSqlite) async {
    // data 必然是 List 类型
    this.setFragmentPoolNodes(true, (fpn) {
      fpn.addAll(data);
    });
    return true;
  }

  Future<bool> _mysqlData(PoolType toPoolType, dynamic data, bool isCancelToPool, bool isDataFromSqlite) async {
    bool isSuccess = false;
    Batch batch = G.sqlite.db.batch();

    List<Map> needData = [];

    // 检查 data 是否为 List 类型
    if (data == null || !(data is List)) {
      dLog(() => "data is null 或 not List");
      isSuccess = false;
      return isSuccess;
    }

    List list = data as List;

    try {
      for (int i = 0; i < list.length; i++) {
        // 检查 item 是否为 Map 类型
        if (!(list[i] is Map)) {
          dLog(() => "item is not Map (like Null)");
          isSuccess = false;
          return isSuccess;
        }

        // 检查不能为 null 的字段
        if (list[i][TFragmentPoolNode.fragment_pool_node_id] == null || list[i][TFragmentPoolNode.pool_type] == null) {
          dLog(() => "必要值为 null");
          isSuccess = false;
          return isSuccess;
        }

        // 待插入
        Map single = TFragmentPoolNode.toMap(
          fragment_pool_node_id_v: list[i][TFragmentPoolNode.fragment_pool_node_id],
          fragment_pool_node_id_s_v: list[i][TFragmentPoolNode.fragment_pool_node_id_s], //因为是 mysql 生成，插入的 _s 是 null 值
          pool_type_v: list[i][TFragmentPoolNode.pool_type],
          node_type_v: list[i][TFragmentPoolNode.node_type],
          branch_v: list[i][TFragmentPoolNode.branch],
          name_v: list[i][TFragmentPoolNode.name],
          created_at_v: list[i][TFragmentPoolNode.created_at],
          updated_at_v: list[i][TFragmentPoolNode.updated_at],
        );
        batch.insert(TFragmentPoolNode.getTableName, single, conflictAlgorithm: ConflictAlgorithm.replace);
        needData.add(single);
      }
    } catch (e) {
      // 可能是 值类型 错误，比如 String 赋值给了 int
      dLog(() => "待插入失败:$e");
      isSuccess = false;
      return isSuccess;
    }

    // 提交待插入
    await batch.commit(continueOnError: false).then(
      (onValue) async {
        List<Map> queryResult = await G.sqlite.db.query(TFragmentPoolNode.getTableName);
        dLog(() => "fragment_pool_nodes 插入至 sqlite 成功:", () => queryResult);
        // 插入成功。
        isSuccess = true;
        // 将获取到的值赋予给需要的变量中。
        this.setFragmentPoolNodes(true, (fpn) {
          fpn.addAll(needData);
        });
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
