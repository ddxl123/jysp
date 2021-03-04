import 'package:jysp/LWCR/Controller/AAExampleController.dart';

/// Request 只可引用 Root

mixin ExampleRequest1 on ExampleRootController {}

mixin ExampleRequest2 on ExampleRootController {}
