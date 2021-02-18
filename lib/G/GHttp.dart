import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:jysp/G/G.dart';
import 'package:jysp/TableModel/local/TToken.dart';
import 'package:jysp/Tools/TDebug.dart';
import 'package:jysp/Tools/Toast.dart';

class GHttp {
  /// 全局 [dio]
  Dio dio = Dio();

  /// 不可并发请求标志
  Map<dynamic, dynamic> sameNotConcurrentMap = {};

  /// 是否处于正在 refresh token 状态
  bool _isTokenRefreshing = false;

  /// 是否处于正在 get token 状态
  bool _isTokenCreating = false;

  /// 初始化 [http]
  GHttp init() {
    dio.options.baseUrl = "http://192.168.10.10:80/";
    dio.options.connectTimeout = 5000; //5s
    dio.options.receiveTimeout = 3000;
    return this;
  }

  ///
  ///
  ///
  /// general request
  ///
  /// - [method] GET POST
  /// - [route] 请求路径,/api$route
  /// - [data] 请求体。只有在 POST 请求时使用。
  /// - [isAuth] 是否需通过 auth 验证
  /// - [queryParameters] 请求 queryParameters。只有在 GET 请求时使用。
  /// - [resultCallback] 响应结果。[code] 响应码, [data] 响应数据。
  /// - [sameNotConcurrent] 相同请求不可并发标记，为 null 时代表不进行标记。
  /// - [interruptedCallback] 被中断的回调
  ///   - [tokenStatus]：
  ///     - [isAuth = true] 时：含 [TokenStatus.concurrentAfter]、[TokenStatus.concurrentBefore]、[TokenStatus.tokenExpired]、[TokenStatus.localDioError]、[TokenStatus.localUnknownError]
  ///        - 其中 [TokenStatus.tokenExpired] 会调用 [sendRefreshTokenRequest] 函数
  ///     - [isAuth = false] 时：含 [TokenStatus.concurrentBefore]、[TokenStatus.localDioError]、[TokenStatus.localUnknownError]
  ///
  Future<void> sendRequest({
    @required String method,
    @required String route,
    @required bool isAuth,
    Map<String, dynamic> data,
    Map<String, dynamic> queryParameters,
    @required void Function({int code, dynamic data}) resultCallback,
    @required String sameNotConcurrent,
    @required Function(TokenStatus tokenStatus) interruptedCallback,
  }) async {
    await Future(() async {
      /// 若相同请求被并发，或正处在 refresh token 状态，或正处在 create token 状态，则直接返回。
      if (sameNotConcurrentMap.containsKey(sameNotConcurrent) || _isTokenRefreshing || _isTokenCreating) {
        // 或相同请求并发，或 token 正在刷新，或 token 正在生成
        interruptedCallback(TokenStatus.concurrentBefore);
        return;
      }

      /// 当相同请求未并发时，对当前请求做阻断标记
      sameNotConcurrentMap[sameNotConcurrent] = 1;

      /// 延迟请求测试，正式版需注释掉
      await Future.delayed(Duration(seconds: 2));

      /// 给请求头设置 token
      Map<String, dynamic> headers = {};
      if (isAuth) {
        String accessToken = await _getSqliteToken(TToken.access_token);
        headers["Authorization"] = "Bearer " + accessToken;
      }

      await dio
          .request(
            "/api$route",
            data: data,
            queryParameters: queryParameters,
            options: Options(method: method, headers: headers),
          )
          .then(
            (Response<dynamic> response) {
              int code = response.data["code"];
              dynamic data = response.data["data"];

              switch (code) {
                case -1:
                  // 验证 access_token 失败
                  // 1. 可能当前响应是并发请求的响应，在请求 refresh token、create token 之前请求而在其之后响应
                  if (_isTokenRefreshing || _isTokenCreating) {
                    interruptedCallback(TokenStatus.concurrentAfter);
                  } else {
                    // 2. 可能是 access_token 过期而未进行 refresh token，则需进行 refresh token
                    interruptedCallback(TokenStatus.tokenExpired);
                    sendRefreshTokenRequest(
                      tokenRefreshFailCallback: (TokenStatus tokenstatus) {
                        switch (tokenstatus) {
                          case TokenStatus.refreshing:
                            showToast("token 正在刷新中，请勿并发");
                            break;
                          case TokenStatus.codeUnknown:
                            showToast("未知响应码");
                            break;
                          case TokenStatus.dataUnknown:
                            showToast("未知响应数据");
                            break;
                          case TokenStatus.refreshFail:
                            showToast("刷新 token 失败，用户需重新登陆");
                            break;
                          default:
                            showToast("未知TokenStatus");
                        }
                      },
                      tokenRefreshSuccessCallback: (tokens) {
                        showToast("刷新 token 成功");
                        dPrint(tokens.toString());
                      },
                    );
                  }
                  break;
                default:
                  resultCallback(code: code, data: data);
              }
            },
          )
          .catchError((onError) => _catchLocalError(onError, interruptedCallback))
          .whenComplete(() {
            sameNotConcurrentMap.remove(sameNotConcurrent);
          });
    });
  }

  ///
  ///
  ///
  /// refresh token
  ///
  /// - [tokenRefreshSuccessCallback]：token 刷新成功的回调；
  ///   - [tokens]：响应的 {"access_token":string,"refresh_token":string}
  /// - [tokenRefreshFailCallback]：token 刷新失败的回调；
  ///   - [tokenStatus]：含 [TokenStatus.refreshing]、[TokenStatus.codeUnknown]、[TokenStatus.dataUnknown]、[TokenStatus.refreshFail]
  ///
  Future<void> sendRefreshTokenRequest({
    @required Function(dynamic tokens) tokenRefreshSuccessCallback,
    @required Function(TokenStatus tokenStatus) tokenRefreshFailCallback,
  }) async {
    await Future(() async {
      if (_isTokenRefreshing) {
        tokenRefreshFailCallback(TokenStatus.refreshing);
        return;
      }
      _isTokenRefreshing = true;

      // 延迟请求测试，正式版需注释掉
      await Future.delayed(Duration(seconds: 2));

      /// 从 sqlite 中获取 refresh_token
      /// 无论是否失败，或是否为 null，都要将请求发送出去，以便能拿到可使用的 tokens
      String refreshToken;
      try {
        refreshToken = (await G.sqlite.db.query(TToken.getTableName))[0][TToken.refresh_token];
      } catch (e) {
        // 获取失败。可能是 query 失败，也可能是 [0] 值为 null，也可能是 [TToken.refresh_token] 值为 null
        refreshToken = null;
      }
      dPrint("从 sqlite 中获取 refresh_token 的结果：" + refreshToken);

      await dio.request("/api/refresh_token", options: Options(method: "GET", headers: {"Authorization": "Bearer " + refreshToken})).then(
        (Response<dynamic> response) {
          int code = response.data["code"];
          dynamic data = response.data["data"];

          switch (code) {
            case -2:
              // 刷新 token 成功，验证 data 是否符合
              if (data == null || data["access_token"] == null || data["refresh_token"] == null) {
                tokenRefreshSuccessCallback(TokenStatus.dataUnknown);
              } else {
                tokenRefreshSuccessCallback(data);
              }
              break;
            case -3:
              // 刷新 token 失败，可能是过期，或者 refresh_token 值不准确
              tokenRefreshFailCallback(TokenStatus.refreshFail);
              break;
            default:
              // 1. 可能是未知code
              // 2. code 值可能非int类型，比如null
              tokenRefreshFailCallback(TokenStatus.codeUnknown);
          }
        },
      ).catchError((onError) => _catchLocalError(onError, tokenRefreshFailCallback));
    }).whenComplete(() {
      _isTokenRefreshing = false;
    });
  }

  ///
  ///
  ///
  /// create token
  ///
  /// - [route]：请求 route
  /// - [willVerifyData]：将验证的数据，比如 邮箱+密码
  /// - [resultCallback]：响应的结果的回调
  ///   - [code]：响应的结果码
  ///   - [data]：响应的结果码对应的数据
  /// - [tokenCreateFailCallback]：token 生成失败的回调
  ///   - [tokenStatus]：含 [TokenStatus.creating]、[TokenStatus.localDioError]、[TokenStatus.localUnknownError]
  ///
  Future<void> sendCreateTokenRequest({
    @required String route,
    @required Map<String, dynamic> willVerifyData,
    @required void Function({int code, dynamic data}) resultCallback,
    @required Function(TokenStatus tokenStatus) tokenCreateFailCallback,
  }) async {
    await Future(() async {
      if (_isTokenCreating) {
        tokenCreateFailCallback(TokenStatus.creating);
        return;
      }
      _isTokenCreating = true;

      // 延迟请求测试，正式版需注释掉
      await Future.delayed(Duration(seconds: 2));

      await dio.request("/api$route", options: Options(method: "POST"), data: willVerifyData).then(
        (Response<dynamic> response) {
          int code = response.data["code"];
          dynamic data = response.data["data"];

          resultCallback(code: code, data: data);
        },
      ).catchError((onError) => _catchLocalError(onError, tokenCreateFailCallback));
    }).whenComplete(() {
      _isTokenCreating = false;
    });
  }

  ///
  ///
  ///
  /// catch local error
  ///
  void _catchLocalError(dynamic onError, Function(TokenStatus tokenStatus) tokenStatusCallback) {
    dPrint(onError.toString());
    if (onError.runtimeType == DioError) {
      // 1.可能本地请求的发送异常
      // 2.可能返回的响应码非 200
      showToast("捕获到本地DioError异常!");
      tokenStatusCallback(TokenStatus.localDioError);
    } else {
      showToast("捕获到本地未知异常!");
      tokenStatusCallback(TokenStatus.localUnknownError);
    }
  }

  ///
  ///
  ///
  /// 从 sqlite 中获取 access_token 或 refresh_token
  /// 无论是否失败，或是否为 null，都要将请求发送出去，以便能拿到可使用的 tokens
  Future<String> _getSqliteToken(String tokenType) async {
    String token;
    try {
      token = (await G.sqlite.db.query(TToken.getTableName))[0][tokenType];
    } catch (e) {
      // 获取失败。可能是 query 失败，也可能是 [0] 值为 null，也可能是 [TToken.refresh_token] 值为 null
      token = null;
    }
    dPrint("从 sqlite 中获取 $tokenType 的结果：" + token);
    return token;
  }

  ///
}

enum TokenStatus {
  /// refresh token
  refreshing,
  codeUnknown,
  dataUnknown,
  refreshFail,

  /// create token
  creating,

  /// general request
  concurrentBefore,
  concurrentAfter,
  tokenExpired,

  /// catch local error
  localDioError,
  localUnknownError,
}
