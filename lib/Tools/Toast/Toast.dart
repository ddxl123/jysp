import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:jysp/Tools/Toast/ShowToast.dart';

///
///
///
///
/// [ToastRoute] 具有触发返回功能
abstract class ToastRoute extends OverlayRoute<int> {
  ///

  ToastRoute(this.fatherContext);
  final BuildContext fatherContext;

  //
  //
  // 需实现的部分
  //
  //

  /// [whenPop]：
  /// - 若 [whenPop] 为 null，则代表点击背景会直接 pop；
  /// - 若返回 true，则异步完后整个 route 被 pop,；
  /// - 若返回 false，则异步完后 route 不进行 pop，只有等待页面被 pop。
  ///
  /// 参数值 [result]：
  /// - 若参数值为 null，则代表(或充当)'点击背景'、'物理返回'。
  ///
  /// 已经被设定成只会执行一次
  Future<Toast<bool>> Function(int? result)? get whenPop;

  /// 默认定位
  AlignmentDirectional get stackAlignment;

  ///初始化
  void init();

  /// rebuild
  ///
  /// 会先执行 [rebuild] 函数，后对 widget 执行 rebuild
  void rebuild();

  /// body
  ///
  /// [Positioned] 定位为 null 时，会根据 [isBodyCenter] 来定位
  List<Positioned> body();

  ///
  ///
  /// 非实现部分
  ///
  ///

  /// 当前 route 的根 Widget 的 context
  late BuildContext context;

  /// 当前 route 的根 Widget 的 setState
  late Function(Function()) setState;

  /// 是否显示 popWaiting
  bool _isPopWaiting = false;

  /// 是否 pop
  bool _isPop = false;

  /// 是否正在 pop 中
  bool _isToPoping = false;

  /// 1. 点击背景调用
  /// 2. 触发物理返回调用
  Future<void> _toPop(int? result) async {
    if (_isToPoping) {
      return;
    }
    _isToPoping = true;
    _isPopWaiting = true;
    setState(() {});

    if (whenPop != null) {
      final bool isPop = (await whenPop!(result)).returnValue;
      if (isPop) {
        _isPop = true;
        didPop(null);
      } else {
        _isToPoping = false;
        _isPopWaiting = false;
        setState(() {});
      }
    } else {
      _isPop = true;
      didPop(null);
    }
  }

  /// 物理返回的 [result] 为 null
  @override
  bool didPop(int? result) {
    if (_isPop == true) {
      super.didPop(null);
      return true;
    } else {
      _toPop(result);
      return false;
    }
  }

  @override
  Iterable<OverlayEntry> createOverlayEntries() {
    return <OverlayEntry>[
      OverlayEntry(
        builder: (_) {
          return ToastRouteWidget(this);
        },
      ),
    ];
  }

  ///
}

class ToastRouteWidget extends StatefulWidget {
  const ToastRouteWidget(this.toastRoute);
  final ToastRoute toastRoute;

  @override
  _ToastRouteWidgetState createState() => _ToastRouteWidgetState();
}

class _ToastRouteWidgetState extends State<ToastRouteWidget> {
  @override
  void initState() {
    super.initState();
    widget.toastRoute.init();
    widget.toastRoute.context = context;
    widget.toastRoute.setState = setState;
  }

  @override
  Widget build(BuildContext context) {
    widget.toastRoute.rebuild();
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Stack(
        alignment: widget.toastRoute.stackAlignment,
        children: <Widget>[
          background(),
          ...widget.toastRoute.body(),
          popWaiting(),
        ],
      ),
    );
  }

  /// 背景
  Widget background() {
    return Positioned(
      top: 0,
      width: MediaQueryData.fromWindow(window).size.width,
      height: MediaQueryData.fromWindow(window).size.height,
      child: Listener(
        onPointerUp: (_) {
          widget.toastRoute._toPop(null);
        },
        child: Opacity(
          opacity: 0.5,
          child: Container(color: Colors.black),
        ),
      ),
    );
  }

  /// popWaiting
  Widget popWaiting() {
    return Positioned(
      top: 0,
      width: MediaQueryData.fromWindow(window).size.width,
      height: MediaQueryData.fromWindow(window).size.height,
      child: Offstage(
        offstage: !widget.toastRoute._isPopWaiting,
        child: Opacity(
          opacity: 0.5,
          child: Container(
            alignment: Alignment.center,
            color: Colors.white,
            child: const Text('等待中...'),
          ),
        ),
      ),
    );
  }
}

///
///
///
///
/// [ToastWidget] 全局的 toast，不具有触发返回的功能
class ToastWidget extends StatefulWidget {
  const ToastWidget({required this.text});
  final String text;

  @override
  _ToastWidgetState createState() => _ToastWidgetState();
}

class _ToastWidgetState extends State<ToastWidget> {
  @override
  Widget build(BuildContext context) {
    final List<Color> colors = <Color>[Colors.red, Colors.green, Colors.yellow, Colors.amber, Colors.blue, Colors.cyan, Colors.indigo];
    final Random random = Random();
    return Container(
      padding: EdgeInsets.fromLTRB(0, MediaQueryData.fromWindow(window).padding.top, 0, 0),
      alignment: Alignment.topCenter,
      child: Material(
        child: Container(
          color: colors[random.nextInt(colors.length)],
          child: Text(
            widget.text,
            style: const TextStyle(fontSize: 18),
          ),
        ),
      ),
    );
  }
}

///
///
///
///
/// [Toast]：[showToast] 的返回类型
///
/// [T] 返回值类型
class Toast<T> {
  Toast(this.returnValue);
  T returnValue;
}
