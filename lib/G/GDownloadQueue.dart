class GDownloadQueue {
  ///

  /// 下载模块，以及对应的进度
  /// 进度为 -1 时代表未下载，进度为 -2 时代表下载完成
  /// eg. {"user_info":{"progress":20,"widget":Text(""),"setState":setState}}
  static Map<String, Map<String, dynamic>> downloadModules = {};

  ///
}
