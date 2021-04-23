import 'package:flutter/material.dart';

enum SendEmailButtonHandlerEnum {
  /// 倒计时状态
  countdown,

  /// 未发送状态
  unSent,
}
enum LoadingBarrierHandlerEnum {
  /// 启用状态
  enabled,

  /// 禁用状态
  disabled,
}

///
///
///
/// rebuild 处理模块
///
class RebuildHandler<T> {
  /// [_handleCode]：默认值。
  RebuildHandler([this._handleCode]);

  /// 处理代号
  T? _handleCode;
  T? get handleCode => _handleCode;

  Function() _rebuild = () {};
  Map<dynamic, dynamic> state = <dynamic, dynamic>{};

  void rebuildHandle(T handleCode, [bool isClearState = false]) {
    if (isClearState) {
      state.clear();
    }
    _handleCode = handleCode;
    _rebuild();
  }
}

class RebuildHandleWidget<T> extends StatefulWidget {
  const RebuildHandleWidget({required this.rebuildHandler, required this.builder});
  final RebuildHandler<T> rebuildHandler;
  final Widget Function(RebuildHandler<T>) builder;
  @override
  _RebuildHandleWidgetState<T> createState() => _RebuildHandleWidgetState<T>();
}

class _RebuildHandleWidgetState<T> extends State<RebuildHandleWidget<T>> {
  @override
  void initState() {
    super.initState();
    widget.rebuildHandler._rebuild = () {
      setState(() {});
    };
  }

  @override
  Widget build(BuildContext context) {
    return widget.builder(widget.rebuildHandler);
  }
}
