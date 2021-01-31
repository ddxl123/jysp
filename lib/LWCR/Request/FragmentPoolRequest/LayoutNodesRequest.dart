import 'package:jysp/G/G.dart';
import 'package:jysp/Table/TFragmentPoolNodes.dart';
import 'package:jysp/Tools/TDebug.dart';

mixin LayoutNodesRequest {
  Future<bool> layoutNodesRequest() async {
    return await _sqlite();
  }

  Future<bool> _sqlite() async {
    /// 本地/云端获取数据是否成功
    bool isSuccess = false;

    /// 进行本地查询
    await G.sqlite.db.query(TFragmentPoolNodes.getTableName).then(
      (successValue) async {
        dLog("本地查询结果" + successValue.toString());

        /// 若本地中一个也没有，则代表未初始化，需向云端请求数据
        if (successValue.length == 0) {
          dLog("本地查询到 0 个结果");
          isSuccess = await _cloud();
        }

        /// 若本地中存在，则代表已初始化过，无需向云端请求数据，直接使用即可
        else {
          dLog("本地查询到至少一个结果");
          isSuccess = true;
        }
      },
    ).catchError((onError) {
      dPrint("本地查询 err" + onError.toString());

      /// 若本地 sqlite 错误，则 Toast 提示
      isSuccess = false;
    });

    return isSuccess;
  }

  /// TODO: GET /api/fragment_pool_nodes
  Future<bool> _cloud() async {
    bool isSuccess = false;
    await G.http.sendRequest(
      method: "GET",
      route: "/fragment_pool_nodes",
      queryParameters: {
        "pool_type": "",
      },
      result: ({response, unknownCode}) {
        dLog(response.toString());
      },
      haveError: () {},
      notConcurrent: null,
    );
    return isSuccess;
  }
}
