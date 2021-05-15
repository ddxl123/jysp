import 'package:dio/dio.dart';
import 'package:jysp/G/GHttp/CodeAndData.dart';
import 'package:jysp/G/GHttp/RequestInterruptedType.dart';
import 'package:jysp/G/GSqlite/Token.dart';
import 'package:jysp/Tools/TDebug.dart';

class GHttp {
  int i = 0;

  /// 全局 [dio]
  static final Dio dio = Dio();

  /// 不可并发请求标志
  static final Map<String, bool> _sameNotConcurrentMap = <String, bool>{};

  /// 是否处于正在 refresh token 状态
  static bool _isTokenRefreshing = false;

  /// 是否处于正在 get token 状态
  static bool _isTokenCreating = false;

  /// 是否延迟请求(2s)
  static const bool _isDelay = false;

  /// 初始化 [http]
  static void init() {
    // dio.options.baseUrl = 'http://jysp.free.idcfengye.com/'; // 内网穿透-测试
    dio.options.baseUrl = 'http://192.168.10.10:80/'; // 仅本地
    dio.options.connectTimeout = 30000; // ms
    dio.options.receiveTimeout = 30000; // ms
  }

  ///
  ///
  ///
  /// general request
  ///
  /// 调用该函数后，会立即触发 [ sameNotConcurrentMap[sameNotConcurrent] = 1 ]，(非异步触发，即会在函数内的异步操作前被触发)，以供其他请求进行中断。
  ///
  /// - [<T>] 响应的 [data] 类型
  /// - [method] GET POST
  /// - [route] 请求路径, $route eg."api/xxx"
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
  static Future<void> sendRequest<T>({
    required String method,
    required String route,
    required bool isAuth,
    Map<String, dynamic>? data,
    Map<String, dynamic>? queryParameters,
    required Function(int code, T data) resultCallback,
    required String? sameNotConcurrent,
    required Function(RequestInterruptedType requestInterruptedType) interruptedCallback,
  }) async {
    try {
      /// 若相同请求被并发，或正处在 refresh token 状态，或正处在 create token 状态，则直接返回。
      if (_sameNotConcurrentMap.containsKey(sameNotConcurrent) || _isTokenRefreshing || _isTokenCreating) {
        // 或相同请求并发，或 token 正在刷新，或 token 正在生成
        dLog(() => 'concurrent:$_sameNotConcurrentMap');
        await interruptedCallback(RequestInterruptedType.generalConcurrentBefore);
        return;
      }

      /// 当相同请求未并发时，对当前请求做阻断标记
      if (sameNotConcurrent != null) {
        _sameNotConcurrentMap[sameNotConcurrent] = true;
      }

      dLog(() => '$method ' + dio.options.baseUrl + route);

      // "await Future(() async {" 这段不能放在当前函数内的最顶端，否则并发时出现 sameNotConcurrentMap 未设置的情况
      await Future<void>(() async {
        /// 延迟请求测试，正式版需注释掉
        if (_isDelay) {
          await Future<void>.delayed(const Duration(seconds: 2));
        }

        /// 给请求头设置 token
        final Map<String, dynamic> headers = <String, dynamic>{};
        if (isAuth) {
          final String accessToken = await Token().getSqliteToken(tokenTypeCode: 0);
          headers['Authorization'] = 'Bearer ' + accessToken;
        }
        await dio
            .request<Map<String, dynamic>>(
          route,
          data: data,
          queryParameters: queryParameters,
          options: Options(method: method, headers: headers),
        )
            .then(
          (Response<Map<String, dynamic>> response) async {
            final CodeAndData<T> codeAndData = CodeAndData<T>(response);

            switch (codeAndData.resultCode) {
              case -1:
                // 验证 access_token 失败
                // 1. 可能当前响应是并发请求的响应，在请求 refresh token、create token 之前请求而在其之后响应
                if (_isTokenRefreshing || _isTokenCreating) {
                  await interruptedCallback(RequestInterruptedType.generalConcurrentAfter);
                } else {
                  // 2. 可能是 access_token 过期而未进行 refresh token，则需进行 refresh token
                  await interruptedCallback(RequestInterruptedType.generalAccessTokenExpired);
                  // 刷新 token 的函数无需 await
                  sendRefreshTokenRequest(
                    tokenRefreshFailCallback: (RequestInterruptedType requestInterruptedType) {
                      switch (requestInterruptedType) {
                        case RequestInterruptedType.refreshTokenRefreshing:
                          dLog(() => 'token 正在刷新中，请勿并发');
                          break;
                        case RequestInterruptedType.refreshTokenCodeUnknown:
                          dLog(() => '未知响应码');
                          break;
                        case RequestInterruptedType.refreshTokenTokensIsNull:
                          dLog(() => '响应 tokens 值为 null');
                          break;
                        case RequestInterruptedType.refreshTokenRefreshTokenExpired:
                          dLog(() => '刷新 token 失败，用户需重新登陆');
                          break;
                        default:
                          dLog(() => '未知InterruptedStatus');
                      }
                    },
                    tokenRefreshSuccessCallback: () {
                      dLog(() => 'token 刷新成功');
                    },
                  );
                }
                break;
              default:
                await resultCallback(codeAndData.resultCode, codeAndData.resultData);
            }
          },
        );
      });
    } catch (e) {
      await _catchLocalError(e, interruptedCallback);
    } finally {
      _sameNotConcurrentMap.remove(sameNotConcurrent);
    }
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
  static Future<void> sendCreateTokenRequest({
    required String route,
    required Map<String, dynamic> willVerifyData,
    required Function(int code, Map<String, String> data) resultCallback,
    required Function(RequestInterruptedType requestInterruptedType) tokenCreateFailCallback,
  }) async {
    try {
      if (_isTokenCreating) {
        await tokenCreateFailCallback(RequestInterruptedType.createTokenCreating);
        return;
      }
      _isTokenCreating = true;

      dLog(() => 'POST ' + dio.options.baseUrl + route);

      // "await Future(() async {" 这段不能放在当前函数内的最顶端，否则并发时出现 _isTokenCreating 未设置的情况
      await Future<void>(() async {
        // 延迟请求测试，正式版需注释掉
        if (_isDelay) {
          await Future<void>.delayed(const Duration(seconds: 2));
        }

        await dio.request<Map<String, dynamic>>(route, options: Options(method: 'POST'), data: willVerifyData).then(
          (Response<Map<String, dynamic>> response) async {
            final CodeAndData<Map<String, String>> codeAndData = CodeAndData<Map<String, String>>(response);

            await resultCallback(codeAndData.resultCode, codeAndData.resultData);
          },
        );
      });
    } catch (e) {
      await _catchLocalError(e, tokenCreateFailCallback);
    } finally {
      _isTokenCreating = false;
    }
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
  static Future<void> sendRefreshTokenRequest({
    required Function() tokenRefreshSuccessCallback,
    required Function(RequestInterruptedType requestInterruptedType) tokenRefreshFailCallback,
  }) async {
    try {
      if (_isTokenRefreshing) {
        await tokenRefreshFailCallback(RequestInterruptedType.refreshTokenRefreshing);
        return;
      }
      _isTokenRefreshing = true;
      dLog(() => '正在 refresh token');

      // "await Future(() async {" 这段不能放在当前函数内的最顶端，否则并发时出现 _isTokenRefreshing 未设置的情况
      await Future<void>(() async {
        // 延迟请求测试，正式版需注释掉
        if (_isDelay) {
          await Future<void>.delayed(const Duration(seconds: 2));
        }

        // 从 sqlite 中获取 refresh_token
        final String refreshToken = await Token().getSqliteToken(tokenTypeCode: 1);

        await dio
            .request<Map<String, dynamic>>(
          '/api/refresh_token',
          options: Options(method: 'GET', headers: <String, String>{'Authorization': 'Bearer ' + refreshToken}),
        )
            .then(
          (Response<Map<String, dynamic>> response) async {
            final CodeAndData<Map<String, String>> codeAndData = CodeAndData<Map<String, String>>(response);

            switch (codeAndData.resultCode) {
              case -2:
                // 存储响应的 tokens
                await Token().setSqliteToken(
                  tokens: codeAndData.resultData,
                  success: () async {
                    await tokenRefreshSuccessCallback();
                  },
                  fail: (int failCode) async {
                    if (failCode == 1) {
                      await tokenRefreshFailCallback(RequestInterruptedType.refreshTokenTokensIsNull);
                    } else {
                      await tokenRefreshFailCallback(RequestInterruptedType.refreshTokenTokensSaveFail);
                    }
                  },
                );
                break;
              case -3:
                // 刷新 token 失败，可能是过期，或者 refresh_token 值不准确
                await tokenRefreshFailCallback(RequestInterruptedType.refreshTokenRefreshTokenExpired);
                break;
              default:
                // 1. 可能是未知code
                // 2. code 值可能非int类型，比如null
                await tokenRefreshFailCallback(RequestInterruptedType.refreshTokenCodeUnknown);
            }
          },
        );
      });
    } catch (e) {
      await _catchLocalError(e, tokenRefreshFailCallback);
    } finally {
      _isTokenRefreshing = false;
    }
  }

  ///
  ///
  ///
  /// catch local error
  ///
  /// catchError 需要返回 Future<Null> 类型
  ///
  // ignore: prefer_void_to_null
  static Future<Null> _catchLocalError(
    dynamic onError,
    Function interruptedStatusCallback,
  ) async {
    if (onError is DioError) {
      // 1.可能本地请求的发送异常
      // 2.可能返回的响应码非 200
      dLog(() => '捕获到本地 DioError 异常!', () => onError);
      await interruptedStatusCallback(RequestInterruptedType.localDioError);
    } else if (onError is RequestInterruptedType) {
      dLog(() => '捕获到 RequestInterruptedType 异常!', () => onError);
      await interruptedStatusCallback(RequestInterruptedType.codeAndDataError);
    } else {
      dLog(() => '捕获到本地未知异常!', () => onError);
      await interruptedStatusCallback(RequestInterruptedType.localUnknownError);
    }
  }

  ///
}
