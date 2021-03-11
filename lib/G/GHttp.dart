import 'package:dio/dio.dart';
import 'package:jysp/G/G.dart';
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
    dio.options.connectTimeout = 30000; //30s
    dio.options.receiveTimeout = 30000;
    return this;
  }

  ///
  ///
  ///
  /// general request
  ///
  /// 调用该函数后，会立即触发 [ sameNotConcurrentMap[sameNotConcurrent] = 1 ]，(非异步触发，即会在函数内的异步操作前被触发)，以供其他请求进行中断。
  ///
  /// - [method] GET POST
  /// - [route] 请求路径, $route
  /// - [data] 请求体。只有在 POST 请求时使用。
  /// - [isAuth] 是否需通过 auth 验证
  /// - [queryParameters] 请求 queryParameters。只有在 GET 请求时使用。
  /// - [resultCallback] 响应结果。[code] 响应码, [data] 响应数据。**注意:返回的结果可以是 Future, 函数内部已嵌套 await**
  /// - [sameNotConcurrent] 相同请求不可并发标记，为 null 时代表不进行标记。**注意:返回的结果可以是 Future, 函数内部已嵌套 await**
  /// - [interruptedCallback] 被中断的回调
  ///   - [GeneralRequestInterruptedStatus]：
  ///     - [isAuth = true] 时：含 [GeneralRequestInterruptedStatus.concurrentBefore]、[GeneralRequestInterruptedStatus.concurrentAfter]、
  ///                             [GeneralRequestInterruptedStatus.accessTokenExpired]、[GeneralRequestInterruptedStatus.localDioError]、
  ///                             [GeneralRequestInterruptedStatus.localUnknownError]
  ///        - 其中 [GeneralRequestInterruptedStatus.accessTokenExpired] 会调用 [sendRefreshTokenRequest] 函数
  ///     - [isAuth = false] 时：含 [GeneralRequestInterruptedStatus.concurrentBefore]、[GeneralRequestInterruptedStatus.localDioError]、
  ///                              [GeneralRequestInterruptedStatus.localUnknownError]
  ///
  Future<void> sendRequest({
    required String method,
    required String route,
    required bool isAuth,
    Map<String, dynamic>? data,
    Map<String, dynamic>? queryParameters,
    required Function({int? code, dynamic? data}) resultCallback,
    required String? sameNotConcurrent,
    required Function(GeneralRequestInterruptedStatus generalRequestInterruptedStatus) interruptedCallback,
  }) async {
    /// 若相同请求被并发，或正处在 refresh token 状态，或正处在 create token 状态，则直接返回。
    if ((sameNotConcurrent != null && sameNotConcurrentMap.containsKey(sameNotConcurrent)) || _isTokenRefreshing || _isTokenCreating) {
      // 或相同请求并发，或 token 正在刷新，或 token 正在生成
      dLog(() => "concurrent:$sameNotConcurrentMap");
      await interruptedCallback(GeneralRequestInterruptedStatus.concurrentBefore);
      return;
    }

    /// 当相同请求未并发时，对当前请求做阻断标记
    sameNotConcurrentMap[sameNotConcurrent] = 1;

    // "await Future(() async {" 这段不能放在当前函数内的最顶端，否则并发时出现 sameNotConcurrentMap 未设置的情况
    await Future(() async {
      /// 延迟请求测试，正式版需注释掉
      await Future.delayed(Duration(seconds: 2));

      /// 给请求头设置 token
      Map<String, dynamic> headers = {};
      if (isAuth) {
        String accessToken = await G.sqlite.getSqliteToken(tokenTypeCode: 0);
        headers["Authorization"] = "Bearer " + accessToken;
      }

      await dio
          .request(
        "$route",
        data: data,
        queryParameters: queryParameters,
        options: Options(method: method, headers: headers),
      )
          .then(
        (Response<dynamic> response) async {
          CodeAndData codeAndData = CodeAndData(response);

          switch (codeAndData.code) {
            case -1:
              // 验证 access_token 失败
              // 1. 可能当前响应是并发请求的响应，在请求 refresh token、create token 之前请求而在其之后响应
              if (_isTokenRefreshing || _isTokenCreating) {
                await interruptedCallback(GeneralRequestInterruptedStatus.concurrentAfter);
              } else {
                // 2. 可能是 access_token 过期而未进行 refresh token，则需进行 refresh token
                await interruptedCallback(GeneralRequestInterruptedStatus.accessTokenExpired);
                // 刷新 token 的函数无需 await
                sendRefreshTokenRequest(
                  tokenRefreshFailCallback: (RefreshTokenInterruptedStatus refreshTokenInterruptedStatus) {
                    switch (refreshTokenInterruptedStatus) {
                      case RefreshTokenInterruptedStatus.refreshing:
                        dLog(() => "token 正在刷新中，请勿并发");
                        break;
                      case RefreshTokenInterruptedStatus.codeUnknown:
                        dLog(() => "未知响应码");
                        break;
                      case RefreshTokenInterruptedStatus.tokensIsNull:
                        dLog(() => "响应 tokens 值为 null");
                        break;
                      case RefreshTokenInterruptedStatus.refreshTokenExpired:
                        dLog(() => "刷新 token 失败，用户需重新登陆");
                        break;
                      default:
                        dLog(() => "未知InterruptedStatus");
                    }
                  },
                  tokenRefreshSuccessCallback: () {
                    dLog(() => "token 刷新成功");
                  },
                );
              }
              break;
            default:
              await resultCallback(code: codeAndData.code, data: codeAndData.data);
          }
        },
      ).catchError(
        (onError) async => await _catchLocalError(
          onError,
          interruptedCallback,
          GeneralRequestInterruptedStatus.localDioError,
          GeneralRequestInterruptedStatus.localUnknownError,
        ),
      );
    })
        // whenComplete 要放在最外层
        .whenComplete(() {
      sameNotConcurrentMap.remove(sameNotConcurrent);
    });
  }

  ///
  ///
  ///
  /// create token
  ///
  /// 调用该函数后，会立即触发 [ _isTokenCreating = true ]，(非异步触发，即会在函数内的异步操作前被触发)，以供其他请求进行中断。
  ///
  /// - [route]：请求 route
  /// - [willVerifyData]：将验证的数据，比如 邮箱+密码
  /// - [resultCallback]：响应的结果的回调。**注意:返回的结果可以是 Future, 函数内部已嵌套 await**
  ///   - [code]：响应的结果码
  ///   - [data]：响应的结果码对应的数据
  /// - [tokenCreateFailCallback]：token 生成失败的回调。**注意:返回的结果可以是 Future, 函数内部已嵌套 await**
  ///
  Future<void> sendCreateTokenRequest({
    required String route,
    required Map<String, dynamic> willVerifyData,
    required Function({int? code, dynamic? data}) resultCallback,
    required Function(CreateTokenInterruptedStatus createTokenInterruptedStatus) tokenCreateFailCallback,
  }) async {
    if (_isTokenCreating) {
      await tokenCreateFailCallback(CreateTokenInterruptedStatus.creating);
      return;
    }
    _isTokenCreating = true;

    // "await Future(() async {" 这段不能放在当前函数内的最顶端，否则并发时出现 _isTokenCreating 未设置的情况
    await Future(() async {
      // 延迟请求测试，正式版需注释掉
      await Future.delayed(Duration(seconds: 2));

      await dio.request("$route", options: Options(method: "POST"), data: willVerifyData).then(
        (Response<dynamic> response) async {
          CodeAndData codeAndData = CodeAndData(response);

          await resultCallback(code: codeAndData.code, data: codeAndData.data);
        },
      ).catchError(
        (onError) async => await _catchLocalError(
          onError,
          tokenCreateFailCallback,
          CreateTokenInterruptedStatus.localDioError,
          CreateTokenInterruptedStatus.localUnknownError,
        ),
      );
    })
        // whenComplete 要放在最外层
        .whenComplete(() {
      _isTokenCreating = false;
    });
  }

  ///
  ///
  ///
  /// refresh token
  ///
  /// 调用该函数后，会立即触发 [ _isTokenRefreshing = true ]，(非异步触发，即会在函数内的异步操作前被触发)，以供其他请求进行中断。
  ///
  /// 虽然该函数是异步函数，但调用该函数时，无需 await 进行等待，因为会导致调用该函数的异步函数被延迟调用其 whenComplete 。
  ///
  /// - [tokenRefreshSuccessCallback]：token 刷新成功的回调；**注意:返回的结果可以是 Future, 函数内部已嵌套 await**
  /// - [tokenRefreshFailCallback]：token 刷新失败的回调；**注意:返回的结果可以是 Future, 函数内部已嵌套 await**
  ///
  Future<void> sendRefreshTokenRequest({
    required Function() tokenRefreshSuccessCallback,
    required Function(RefreshTokenInterruptedStatus refreshTokenInterruptedStatus) tokenRefreshFailCallback,
  }) async {
    if (_isTokenRefreshing) {
      await tokenRefreshFailCallback(RefreshTokenInterruptedStatus.refreshing);
      return;
    }
    _isTokenRefreshing = true;
    dLog(() => "正在 refresh token");

    // "await Future(() async {" 这段不能放在当前函数内的最顶端，否则并发时出现 _isTokenRefreshing 未设置的情况
    await Future(() async {
      // 延迟请求测试，正式版需注释掉
      await Future.delayed(Duration(seconds: 2));

      // 从 sqlite 中获取 refresh_token
      String refreshToken = await G.sqlite.getSqliteToken(tokenTypeCode: 1);

      await dio.request("/api/refresh_token", options: Options(method: "GET", headers: {"Authorization": "Bearer " + refreshToken})).then(
        (Response<dynamic> response) async {
          CodeAndData codeAndData = CodeAndData(response);

          switch (codeAndData.code) {
            case -2:
              // 存储响应的 tokens
              await G.sqlite.setSqliteToken(
                tokens: codeAndData.data,
                success: () async {
                  await tokenRefreshSuccessCallback();
                },
                fail: (failCode) async {
                  if (failCode == 1) {
                    await tokenRefreshFailCallback(RefreshTokenInterruptedStatus.tokensIsNull);
                  } else {
                    await tokenRefreshFailCallback(RefreshTokenInterruptedStatus.tokensSaveFail);
                  }
                },
              );
              break;
            case -3:
              // 刷新 token 失败，可能是过期，或者 refresh_token 值不准确
              await tokenRefreshFailCallback(RefreshTokenInterruptedStatus.refreshTokenExpired);
              break;
            default:
              // 1. 可能是未知code
              // 2. code 值可能非int类型，比如null
              await tokenRefreshFailCallback(RefreshTokenInterruptedStatus.codeUnknown);
          }
        },
      ).catchError(
        (onError) async => await _catchLocalError(
          onError,
          tokenRefreshFailCallback,
          CreateTokenInterruptedStatus.localDioError,
          CreateTokenInterruptedStatus.localUnknownError,
        ),
      );
    })
        // whenComplete 要放在最外层
        .whenComplete(() {
      _isTokenRefreshing = false;
    });
  }

  ///
  ///
  ///
  /// catch local error
  ///
  /// catchError 需要返回 Future<Null> 类型
  ///
  Future<Null> _catchLocalError(
    dynamic onError,
    Function interruptedStatusCallback,
    dynamic localDioErrorInterruptedStatus,
    dynamic localUnknownErrorInterruptedStatus,
  ) async {
    if (onError.runtimeType == DioError) {
      // 1.可能本地请求的发送异常
      // 2.可能返回的响应码非 200
      dLog(() => "捕获到本地DioError异常!", () => onError);
      await interruptedStatusCallback(localDioErrorInterruptedStatus);
    } else {
      dLog(() => "捕获到本地未知异常!", () => onError);
      await interruptedStatusCallback(localUnknownErrorInterruptedStatus);
    }
  }

  ///
}

enum GeneralRequestInterruptedStatus {
  concurrentBefore, // 请求并发，但请求未发送。
  concurrentAfter, // 响应并发，其中发生了 access_token 过期的响应，防止并发 refresh token 函数。
  accessTokenExpired, // 发生了 access_token 过期的响应，需进行 refresh token。

  /// catch local error
  localDioError,
  localUnknownError,
}

enum CreateTokenInterruptedStatus {
  creating, // 创建 token 中

  /// catch local error
  localDioError,
  localUnknownError,
}

enum RefreshTokenInterruptedStatus {
  refreshing, // 刷新 tokens 中
  codeUnknown, // 刷新 tokens 时，响应的未知码
  tokensIsNull, // 刷新 tokens 后，响应的 tokens 为 null
  tokensSaveFail, // 已获取正确的 tokens，但存储至 sqlite 失败
  refreshTokenExpired, // 刷新 tokens 失败，代表 refresh 过期

  /// catch local error
  localDioError,
  localUnknownError,
}

class CodeAndData {
  int? code;
  dynamic? data;

  /// 将响应的数据转化成 Map 类型
  /// 若 response.data 不是 Map 类型，则转化成 {"code":null,"data":null}
  CodeAndData(Response response) {
    if (!(response.data is Map)) {
      dLog(() => "response is not map");
      this.code = null;
      this.data = null;
    } else {
      this.code = response.data["code"];
      this.data = response.data["data"];
    }
  }
}
