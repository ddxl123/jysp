import 'package:jysp/Database/base/DBTableBase.dart';
import 'package:jysp/Database/models/MVersionInfo.dart';import 'package:jysp/Database/models/MToken.dart';import 'package:jysp/Database/models/MUser.dart';import 'package:jysp/Database/models/MUpload.dart';import 'package:jysp/Database/models/MDownloadModule.dart';import 'package:jysp/Database/models/MDownloadRow.dart';import 'package:jysp/Database/models/MPnPendingPoolNode.dart';import 'package:jysp/Database/models/MPnMemoryPoolNode.dart';import 'package:jysp/Database/models/MPnCompletePoolNode.dart';import 'package:jysp/Database/models/MPnRulePoolNode.dart';import 'package:jysp/Database/models/MFragmentsAboutPendingPoolNode.dart';import 'package:jysp/Database/models/MFragmentsAboutMemoryPoolNode.dart';import 'package:jysp/Database/models/MFragmentsAboutCompletePoolNode.dart';import 'package:jysp/Database/models/MRule.dart';
class ModelList {
  static List<DBTableBase> models = [MVersionInfo(), MToken(), MUser(), MUpload(), MDownloadModule(), MDownloadRow(), MPnPendingPoolNode(), MPnMemoryPoolNode(), MPnCompletePoolNode(), MPnRulePoolNode(), MFragmentsAboutPendingPoolNode(), MFragmentsAboutMemoryPoolNode(), MFragmentsAboutCompletePoolNode(), MRule()];

  static List<String> downloadBaseModules = [
"user_info",
"pending_pool_nodes",
"memory_pool_nodes",
"complete_pool_nodes",
"rule_pool_nodes"
];
}
