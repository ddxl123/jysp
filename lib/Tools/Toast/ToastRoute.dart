import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:jysp/g/G.dart';
import 'package:jysp/tools/Helper.dart';

class PopResult {
  PopResult({required this.popResultSelect, required this.value});
  PopResultSelect popResultSelect;
  Object? value;

  @override
  String toString() {
    return 'popResultSelect: $popResultSelect, value: $value';
  }
}

enum PopResultSelect {
  clickBackground,
  one,
  two,
  three,
  four,
  five,
}

///
///
///
///
/// [ToastRoute] 具有触发返回功能的 toast
abstract class ToastRoute extends OverlayRoute<PopResult> {
  ///

  ToastRoute(this.fatherContext);
  final BuildContext fatherContext;

  // ==============================================================================
  //
  // 需实现的部分
  //

  /// [whenPop]：
  /// - 若返回 true，则异步完后整个 route 被 pop,；
  /// - 若返回 false，则异步完后 route 不进行 pop，只有等待页面被 pop。
  ///
  /// 参数值 [popResult]：
  /// - 若参数值的 [PopResult] 为 null，则代表(或充当)'物理返回'。
  /// - 若参数值的 [PopResultSelect] 为 [PopResultSelect.clickBackground]，则代表点击了背景。
  ///
  /// 已经被设定多次触发时只会执行第一次
  Future<Toast<bool>> whenPop(PopResult? popResult);

  ///初始化
  void init() {}

  /// 初始化结束
  void initDone() {}

  /// build
  ///
  /// 会先执行 [build] 函数，后返回 widget。
  void buildCallBack() {}

  /// body
  ///
  /// Widget 为 [Positioned] 或 [AutoPositioned]
  List<Widget> body();

  /// 背景不透明度
  double get backgroundOpacity;

  /// 背景颜色
  Color get backgroundColor;

  // ==============================================================================
  //
  // 非实现部分
  //

  /// 当前 route 的根 Widget 的 context
  late BuildContext context;

  /// 当前 route 的根 Widget 的 setState
  SetState? toastRouteSetState;

  /// 父 widget 的 Rect
  late Rect fatherWidgetRect;

  /// 是否显示 popWaiting
  bool _isPopWaiting = false;

  /// 是否 pop
  bool _isPop = false;

  /// 是否正在 pop 中
  bool _isToPoping = false;

  /// 1. 点击背景调用
  /// 2. 触发物理返回调用
  Future<void> _toPop(PopResult? result) async {
    if (_isToPoping) {
      return;
    }
    _isToPoping = true;
    _isPopWaiting = true;
    runSetState(toastRouteSetState!);

    final bool isPop = (await whenPop(result)).returnValue;
    if (isPop) {
      _isPop = true;
      didPop(null);
    } else {
      _isToPoping = false;
      _isPopWaiting = false;
      runSetState(toastRouteSetState!);
    }
  }

  /// 物理返回 的 [result] 为 null
  @override
  bool didPop(PopResult? result) {
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
        maintainState: true,
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
    widget.toastRoute.toastRouteSetState ??= setState;

    final RenderBox fatherRenderBox = widget.toastRoute.fatherContext.findRenderObject()! as RenderBox;
    final Size size = fatherRenderBox.size;
    final Offset offset = fatherRenderBox.localToGlobal(Offset.zero);
    widget.toastRoute.fatherWidgetRect = Rect.fromLTWH(offset.dx, offset.dy, size.width, size.height);
    WidgetsBinding.instance!.addPostFrameCallback(
      (Duration timeStamp) {
        widget.toastRoute.initDone();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    widget.toastRoute.buildCallBack();
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Container(
        width: MediaQueryData.fromWindow(window).size.width,
        height: MediaQueryData.fromWindow(window).size.height,
        child: Stack(
          alignment: Alignment.topLeft,
          children: <Widget>[
            background(),
            ...widget.toastRoute.body(),
            popWaiting(),
          ],
        ),
      ),
    );
  }

  /// 背景
  Widget background() {
    return Positioned(
      top: 0,
      child: Listener(
        onPointerUp: (_) {
          widget.toastRoute._toPop(PopResult(value: null, popResultSelect: PopResultSelect.clickBackground));
        },
        child: Opacity(
          opacity: widget.toastRoute.backgroundOpacity,
          child: Container(
            width: MediaQueryData.fromWindow(window).size.width,
            height: MediaQueryData.fromWindow(window).size.height,
            color: widget.toastRoute.backgroundColor,
          ),
        ),
      ),
    );
  }

  /// popWaiting
  Widget popWaiting() {
    return Positioned(
      top: 0,
      child: Offstage(
        offstage: !widget.toastRoute._isPopWaiting,
        child: Opacity(
          opacity: 0.5,
          child: Container(
            width: MediaQueryData.fromWindow(window).size.width,
            height: MediaQueryData.fromWindow(window).size.height,
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

///
///
///
///
///

/// 自动设置 child 在屏幕中的位置
///
/// 要注意 child 高度不能大于屏幕高度的一半，否则溢出部分无法显示
class AutoPositioned extends StatefulWidget {
  const AutoPositioned({required this.child});
  final Widget child;

  @override
  _AutoPositionedState createState() => _AutoPositionedState();
}

class _AutoPositionedState extends State<AutoPositioned> {
  final Size screenSize = MediaQueryData.fromWindow(window).size;
  final Size halfScreenSize = MediaQueryData.fromWindow(window).size / 2;
  double? left;
  double? right;
  double? top;
  double? buttom;

  @override
  void initState() {
    super.initState();
    // 必须放在 init 中，因为 OverlayRoute pop 或 push 前后会 触发 setState
    // 当 maintainState == true 时，不会触发 init ，而只会触发 setState
    if (touchPosition.dx < halfScreenSize.width && touchPosition.dy < halfScreenSize.height) {
      left = touchPosition.dx;
      top = touchPosition.dy;
    } else if (touchPosition.dx < halfScreenSize.width && touchPosition.dy > halfScreenSize.height) {
      left = touchPosition.dx;
      buttom = screenSize.height - touchPosition.dy;
    } else if (touchPosition.dx > halfScreenSize.width && touchPosition.dy < halfScreenSize.height) {
      right = screenSize.width - touchPosition.dx;
      top = touchPosition.dy;
    } else if (touchPosition.dx > halfScreenSize.width && touchPosition.dy > halfScreenSize.height) {
      right = screenSize.width - touchPosition.dx;
      buttom = screenSize.height - touchPosition.dy;
    } else {
      left = touchPosition.dx;
      top = touchPosition.dy;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: left,
      right: right,
      top: top,
      bottom: buttom,
      child: widget.child,
    );
  }
}
