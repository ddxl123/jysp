import 'package:jysp/Database/Models/MVersionInfo.dart';
import 'package:jysp/G/GSqlite/GSqlite.dart';
import 'package:jysp/Tools/Helper.dart';
import 'package:package_info_plus/package_info_plus.dart';

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

class AppVersionManager {
  ///

  /// 获取被保存在本地应用版本
  Future<String?> _getSavedAppVersion() async {
    final Object? savedVersion = (await db.query(MVersionInfo.getTableName, limit: 1)).first[MVersionInfo.saved_version];
    if (savedVersion == null) {
      throw 'savedVersion is null';
    }
    return savedVersion.toString();
  }

  /// 获取当前应用版本
  Future<String> getCurrentAppVersion() async {
    final PackageInfo packageInfo = await PackageInfo.fromPlatform();
    return packageInfo.version;
  }

  /// 应用版本检查
  /// - **前提: sqlite 数据库中必须存在 version_infos 表**
  Future<VersionStatus> appVersionCheck() async {
    final String currentAppVersion = await getCurrentAppVersion();
    final String saveAppVersion = (await _getSavedAppVersion())!;

    final List<String> currentAppVersionString = currentAppVersion.split('.');
    final List<String> saveAppVersionString = saveAppVersion.split('.');

    final Compare zeroCompare = Helper.compare(int.parse(currentAppVersionString[0]), int.parse(saveAppVersionString[0]));
    final Compare oneCompare = Helper.compare(int.parse(currentAppVersionString[1]), int.parse(saveAppVersionString[1]));
    final Compare twoCompare = Helper.compare(int.parse(currentAppVersionString[2]), int.parse(saveAppVersionString[2]));

    if (zeroCompare == Compare.frontBig) {
      return VersionStatus.changeDbAfterUpload;
    } else if (zeroCompare == Compare.backBig) {
      return VersionStatus.back;
    } else {
      if (oneCompare == Compare.frontBig) {
        return VersionStatus.changeDbNotUpload;
      } else if (oneCompare == Compare.backBig) {
        return VersionStatus.back;
      } else {
        if (twoCompare == Compare.frontBig) {
          return VersionStatus.notChangeDB;
        } else if (twoCompare == Compare.backBig) {
          return VersionStatus.back;
        } else {
          return VersionStatus.keep;
        }
      }
    }
  }
}
