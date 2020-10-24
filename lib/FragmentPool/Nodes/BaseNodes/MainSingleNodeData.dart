// import 'package:flutter/cupertino.dart';
// import 'package:jysp/Global/GlobalData.dart';

// enum NeedRouteType {
//   currentMap,
//   fatherMap,
//   currentRouteName,
//   fatherRouteName,
//   currentIndex,
// }

// class MainSingleNodeData {
//   int currentIndex;
//   Map<String, dynamic> fragmentPoolLayoutDataMap = {};
//   Map<String, dynamic> fragmentPoolLayoutDataMapTemp = {};

//   dynamic getNodeData({@required NeedRouteType needRouteType, @required String key}) {
//     String thisRouteName = GlobalData.instance.fragmentPoolDataList[currentIndex]["route"];

//     switch (needRouteType) {

//       ///
//       case NeedRouteType.currentMap:
//         Map<dynamic, dynamic> thisRouteMap = fragmentPoolLayoutDataMap[thisRouteName] ?? {};
//         Map<dynamic, dynamic> thisTempMap = fragmentPoolLayoutDataMapTemp[thisRouteName] ?? {};
//         return thisRouteMap[key] ?? thisTempMap[key] ?? _defaultLayoutPropertyMap()[key];
//         break;

//       ///
//       case NeedRouteType.fatherMap:
//         String thisFatherRouteName = () {
//           List<String> spl = thisRouteName.split("-");
//           return spl.sublist(0, spl.length - 1).join("-");
//         }();
//         Map<dynamic, dynamic> thisFatherRouteMap = fragmentPoolLayoutDataMap[thisFatherRouteName] ?? {};
//         Map<dynamic, dynamic> thisFatherTempMap = fragmentPoolLayoutDataMapTemp[thisFatherRouteName] ?? {};
//         return thisFatherRouteMap[key] ?? thisFatherTempMap[key] ?? _defaultLayoutPropertyMap()[key];
//         break;

//       ///
//       case NeedRouteType.currentRouteName:
//         return thisRouteName;

//       ///
//       case NeedRouteType.fatherRouteName:
//         return () {
//           List<String> spl = thisRouteName.split("-");
//           return spl.sublist(0, spl.length - 1).join("-");
//         }();

//       ///
//       default:
//     }
//   }

//   /// 默认布局数据
//   Map<dynamic, dynamic> _defaultLayoutPropertyMap({Size size}) {
//     return {
//       "child_count": 0,
//       "layout_width": size == null ? 10 : size.width, // 不设置它为0是为了防止出现bug观察不出来
//       "layout_height": size == null ? 10 : size.height,
//       "layout_left": -10000.0,
//       "layout_top": -10000.0,
//       "container_height": size == null ? 10 : size.height,
//       "vertical_center_offset": 0.0
//     };
//   }
// }
