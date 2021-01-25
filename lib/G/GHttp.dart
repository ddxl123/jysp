import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:jysp/Tools/Toast.dart';

class GHttp {
  /// 全局 [dio]
  Dio dio = Dio();

  /// 不可并发请求标志
  Map<dynamic, dynamic> notConcurrentMap = {};

  /// 初始化 [http]
  GHttp init() {
    dio.options.baseUrl = "http://192.168.10.10:80/";
    dio.options.connectTimeout = 5000; //5s
    dio.options.receiveTimeout = 3000;
    return this;
  }

  /// [route] 请求路径
  /// [data] 请求体
  /// [result] 响应结果。[response] 响应数据, [unknowCode] 未知响应码
  /// [error] 本地异常
  /// [notConcurrent] 不可并发请求标志
  Future<void> sendPostRequest({
    @required String route,
    @required dynamic data,
    @required Function({Response<dynamic> response, Function unknownCode}) result,
    @required Function error,
    @required String notConcurrent,
  }) async {
    // 若并发了，则直接返回。
    if (notConcurrentMap.containsKey(notConcurrent)) {
      print("请求并发");
      return;
    }
    notConcurrentMap[notConcurrent] = 1;

    await Future.delayed(Duration(seconds: 2));
    dio.post("/api$route", data: data).then(
      (Response<dynamic> response) {
        result(
          response: response,
          unknownCode: () {
            showToast("Unknown code!");
          },
        );
      },
    ).catchError(
      (dynamic onError) {
        if (onError.runtimeType == DioError) {
          showToast("捕获到本地DioError异常!");
        } else {
          showToast("捕获到本地未知异常!");
        }
        error();
      },
    ).whenComplete(() {
      notConcurrentMap.remove(notConcurrent);
    });
  }
}
