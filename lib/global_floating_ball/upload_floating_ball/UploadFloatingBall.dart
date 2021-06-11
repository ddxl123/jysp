import 'package:flutter/material.dart';
import 'package:jysp/global_floating_ball/FloatingBallBase.dart';
import 'package:jysp/tools/RoundedBox..dart';
import 'package:jysp/tools/TDebug.dart';
import 'package:jysp/tools/toast/ShowToast.dart';
import 'package:jysp/tools/toast/ToastRoute.dart';

class UploadFloatingBall extends FloatingBallBase {
  @override
  ToastRoute firstRoutes(BuildContext floatingBallContext) {
    return First(floatingBallContext);
  }

  @override
  String get floatingBallName => '上传队列';

  @override
  Offset get initPosition => const Offset(200, 200);

  @override
  double get radius => 60;
}

class First extends ToastRoute {
  First(BuildContext fatherContext) : super(fatherContext);

  @override
  Color get backgroundColor => Colors.transparent;

  @override
  double get backgroundOpacity => 0;

  @override
  List<Widget> body() {
    return <Positioned>[
      Positioned(
        child: Center(
          child: RoundedBox(
            width: MediaQuery.of(context).size.width * 2 / 3,
            height: MediaQuery.of(context).size.height * 2 / 3,
            children: <Widget>[
              Row(
                children: <Widget>[
                  Expanded(
                    child: TextButton(onPressed: () {}, child: const Text('查看正在上传的数据')),
                  ),
                ],
              ),
              Row(
                children: <Widget>[
                  Expanded(
                    child: TextButton(onPressed: () {}, child: const Text('查看全部需要上传的数据')),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    ];
  }

  @override
  void init() {}

  @override
  void rebuild() {}

  @override
  Future<Toast<bool>> whenPop(PopResult? popResult) async {
    try {
      if (popResult == null || popResult.popResultSelect == PopResultSelect.clickBackground) {
        return showToast<bool>(text: '已返回', returnValue: true);
      } else {
        throw 'unknown popResult: $popResult';
      }
    } catch (e, r) {
      dLog(() => '$e---$r');
      return showToast<bool>(text: 'err', returnValue: false);
    }
  }
}
