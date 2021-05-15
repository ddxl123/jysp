enum AppInitStatus {
  ///准备初始化
  readyInit,

  /// 初始化完成
  ok,

  /// 表损坏
  tableLost,

  /// 已被初始化过
  initialized,

  /// 异常
  err,
}

enum VersionStatus {
  /// app 没有被重新安装, 或 app 安装覆盖旧版本后, 版本没有发生变化
  keep,

  /// app 安装覆盖原来的版本后, 新版本高于旧版本, 但未对数据库结构进行改变
  notChangeDB,

  /// app 安装覆盖原来的版本后, 新版本高于旧版本, 也对数据库结构进行了改变, 但无需让用户将旧版本中未上传的数据全部上传后再对数据库结构进行覆盖
  changeDbNotUpload,

  /// app 安装覆盖原来的版本后, 新版本高于旧版本, 也对数据库结构进行了改变, 但需要让用户将旧版本中未上传的数据全部上传后才能对数据库结构进行覆盖
  changeDbAfterUpload,

  /// app 安装覆盖原来的版本后, 新版本低于旧版本
  back,
}
