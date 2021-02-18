import 'package:flutter/material.dart';
import 'package:jysp/LWCR/Request/AAExampleRequest.dart';

class _Init extends ChangeNotifier {
  /// 书写构造函数进行初始化的地方。
  /// 继承 ChangeNotifier 的目的是进行 setState
}

/// 以下使用 mixin 是方便构造函数进行初始化，若也用 class 进行层层继承的话，构造函数需要层层书写，使用 mixin 更为合适

/// 混入需要的 request
mixin _Root on _Init, ExampleRequest {
  /// 顶层调用的地方。
}

mixin _Other on _Root {
  /// 其他逻辑
}

class ExampleController extends _Init with ExampleRequest, _Root, _Other {}
