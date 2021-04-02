import 'package:jysp/Database/base/DBTableBase.dart';
import 'package:jysp/Database/models/MUser.dart';import 'package:jysp/Database/models/MCurd.dart';import 'package:jysp/Database/models/MToken.dart';import 'package:jysp/Database/models/MPnPendingPoolNode.dart';import 'package:jysp/Database/models/MPnMemoryPoolNode.dart';import 'package:jysp/Database/models/MPnCompletePoolNode.dart';import 'package:jysp/Database/models/MPnRulePoolNode.dart';import 'package:jysp/Database/models/MFragmentsAboutPendingPoolNode.dart';import 'package:jysp/Database/models/MFragmentsAboutMemoryPoolNode.dart';import 'package:jysp/Database/models/MFragmentsAboutCompletePoolNode.dart';import 'package:jysp/Database/models/MRule.dart';
class ModelList {
  List<DBTableBase> models = [MUser(), MCurd(), MToken(), MPnPendingPoolNode(), MPnMemoryPoolNode(), MPnCompletePoolNode(), MPnRulePoolNode(), MFragmentsAboutPendingPoolNode(), MFragmentsAboutMemoryPoolNode(), MFragmentsAboutCompletePoolNode(), MRule()];
}
