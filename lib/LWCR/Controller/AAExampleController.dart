import 'package:flutter/material.dart';
import 'package:jysp/LWCR/Request/AAExampleRequest.dart';

class _Init extends ChangeNotifier {
  /// 书写构造函数进行初始化的地方。
  /// 继承 ChangeNotifier 的目的是进行 setState
}

/// 以下使用 mixin 是方便构造函数进行初始化，若也用 class 进行层层继承的话，构造函数需要层层书写，使用 mixin 更为合适

mixin ExampleRootController on _Init {
  /// 存放的是顶层变量成员，不能放函数
}

/// 混入 Request:
/// 1. Request 需要 顶层变量成员。
/// 2. Other 中需要调用 Request。
/// Request 处在 1.和 2. 之间。
mixin PutRequest on ExampleRequest1, ExampleRequest2 {}

mixin _Other1 on PutRequest {
  /// 其他逻辑
}
mixin _Other2 on PutRequest {
  /// 其他逻辑
}

class ExampleController extends _Init with ExampleRootController, ExampleRequest2, ExampleRequest1, PutRequest, _Other1, _Other2 {}
