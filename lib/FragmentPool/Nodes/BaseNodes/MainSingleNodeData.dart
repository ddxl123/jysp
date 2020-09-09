import 'package:jysp/FragmentPool/Nodes/ToolNodes/FreeBox.dart';

class MainSingleNodeData {
  int thisIndex;
  String thisRouteName;
  Map<dynamic, dynamic> thisRouteMap = {};
  String thisFatherRouteName;
  Map<dynamic, dynamic> thisFatherRouteMap = {};

  List<Map<dynamic, dynamic>> fragmentPoolDataList;
  Map<String, dynamic> fragmentPoolLayoutDataMap;
  FreeBoxController freeBoxController;
  Function(Function callback) resetLayout = (callback) {};
}
