import 'package:flutter/material.dart';

final GlobalKey globalKey = GlobalKey();

const String unknown = 'unknown';

/// 一个顶层 Listener，当嵌套的 Listener 被依次触发时，把被触发事件存进该 List 里，顶层 Listener 被触发时，获取 position 后对 List 元素依次触发
///
/// ! 仅限 [Listener]，因为 [TextButton] 会先触发顶层 Listener 后触发嵌套 Button
List<Function> touchPositionUpEvent = <Function>[];
Offset touchPosition = Offset.zero;
