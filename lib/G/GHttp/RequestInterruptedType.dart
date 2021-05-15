enum RequestInterruptedType {
  ///

  /// 一般请求
  generalConcurrentBefore, // 请求并发，但请求未发送。
  generalConcurrentAfter, // 响应并发，其中发生了 access_token 过期的响应，防止并发 refresh token 函数。
  generalAccessTokenExpired, // 发生了 access_token 过期的响应，需进行 refresh token。

  /// 生成 token 请求
  createTokenCreating, // 创建 token 中

  /// 刷新 token 请求
  refreshTokenRefreshing, // 刷新 tokens 中
  refreshTokenCodeUnknown, // 刷新 tokens 时，响应的未知码
  refreshTokenTokensIsNull, // 刷新 tokens 后，响应的 tokens 为 null
  refreshTokenTokensSaveFail, // 已获取正确的 tokens，但存储至 sqlite 失败
  refreshTokenRefreshTokenExpired, // 刷新 tokens 失败，代表 refresh 过期

  /// 响应数据
  codeAndDataError,

  /// catch local error
  localDioError,
  localUnknownError,

  ///
}
