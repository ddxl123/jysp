import 'package:flutter/material.dart';
import 'package:jysp/Database/Models/MBase.dart';
import 'package:jysp/MVC/Request/Sqlite/RSqliteCurd.dart';
import 'package:jysp/MVC/Views/HomePage/ToastRoutes/NodeReNameRoute.dart';
import 'package:jysp/Tools/TDebug.dart';
import 'package:jysp/Tools/Toast/ShowToast.dart';
import 'package:jysp/Tools/Toast/Toast.dart';

class NodeLongPressMenuRoute extends ToastRoute {
  NodeLongPressMenuRoute({required this.baseModel});
  final MBase baseModel;

  @override
  AlignmentDirectional get stackAlignment => AlignmentDirectional.center;

  @override
  void init() {}

  @override
  void rebuild() {}

  @override
  List<Positioned> body() {
    return <Positioned>[
      Positioned(
        child: Container(
          alignment: Alignment.center,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              TextButton(
                child: const Text('删除节点'),
                onPressed: () {
                  Navigator.pop<int>(context, 0);
                },
              ),
              TextButton(
                child: const Text('修改名称'),
                onPressed: () {
                  Navigator.pop<int>(context, null);
                  showToastRoute(context, NodeRenameRoute());
                },
              ),
              TextButton(
                child: const Text('其他2'),
                onPressed: () {},
              ),
            ],
          ),
        ),
      ),
    ];
  }

  @override
  Future<Toast<bool>> Function(int?)? get whenPop => (int? result) async {
        try {
          if (result == null) {
            return showToast(text: '未选择', returnValue: true);
          } else if (result == 0) {
            final bool isOk = await RSqliteCurd.byModel(baseModel).toDeleteRow(connectTransaction: null);
            if (isOk) {
              return showToast(text: '删除成功', returnValue: true);
            } else {
              return showToast(text: '删除失败', returnValue: false);
            }
          } else {
            throw 'result err: $result';
          }
        } catch (e) {
          dLog(() => e);
          return showToast(text: 'pop err', returnValue: false);
        }
      };
}
