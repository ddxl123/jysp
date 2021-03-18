import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:jysp/Tools/LoadingAnimation.dart';

///
///
///
///
///
class NodeSheetPage extends OverlayRoute {
  NodeSheetPage({required this.slivers});

  final List<Widget> Function(SheetPageController) slivers;

  Function _removeAnimation = () {};

  @override
  Iterable<OverlayEntry> createOverlayEntries() {
    return [
      OverlayEntry(
        builder: (_) {
          return Stack(
            children: [
              _backgroundHitTest(),
              _sheet(),
            ],

            ///
          );
        },
      )
    ];
  }

  Widget _backgroundHitTest() {
    return Positioned(
      top: 0,
      child: Listener(
        behavior: HitTestBehavior.deferToChild,
        onPointerMove: (event) {
          print(event);
        },
        child: Container(
          color: null,
          height: double.maxFinite,
          width: double.maxFinite,
        ),
      ),
    );
  }

  Widget _sheet() {
    return Sheet(
      sheetRoute: this,
      getRemoveAnimation: (ra) {
        this._removeAnimation = ra;
      },
      slivers: this.slivers,
    );
  }

  /// 返回监听:
  /// 当调用 [Navigator.pop] 时，会调用 [didpop] ,该函数中会调用 [NavigatorState] 的 [finalizeRoute] 函数来释放资源(如等待动画完成)。然后再调用route的 [dispose] 函数。
  /// 当调用 [Navigator.removeRoute] 时,会立即调用route的 [dispose] 。
  /// 当前路线是：被 [Navigator.pop] 后不进行任何操作，而是调用了 [_removeAnimation] 中的 [Navigator.removeRoute] 。
  /// 若在 [_removeAnimation] 中调用 [Navigator.pop] 则会循环的调用 [_removeAnimation] ,当然 [_removeAnimation] 中有仅执行一次的判断。
  @override
  // ignore: must_call_super
  bool didPop(result) {
    _removeAnimation();
    return false;
  }
}

///
///
///
///
///
class Sheet extends StatefulWidget {
  Sheet({
    required this.sheetRoute,
    required this.getRemoveAnimation,

    //
    required this.slivers,
  });

  final NodeSheetPage sheetRoute;
  final Function getRemoveAnimation;

  final List<Widget> Function(SheetPageController) slivers;

  @override
  _SheetState createState() => _SheetState();
}

class _SheetState extends State<Sheet> with SingleTickerProviderStateMixin {
  SheetPageController _sheetPageController = SheetPageController();

  /// 初始高度占满屏幕
  double _maxHeight = MediaQueryData.fromWindow(window).size.height - MediaQueryData.fromWindow(window).padding.top;

  /// 动画
  late Animation<double> _animation;
  late AnimationController _animationController;

  /// 内部滑动控制器
  ScrollController _scrollController = ScrollController();

  /// [初始化] 时播放到一半时停止的单次事件,防止初始化时滑到满屏
  bool _isOnceHalfDone = false;

  /// 触摸方向。如果 [_touchDirection>0.0] 则正在向上滚动,如果 [_touchDirection<0.0] 则正在向下滚动。
  double _lastTouchDelta = 0.0;

  /// 是否将被移除，防止 [_remove] 被触发多次
  bool _isWillRemoveOnce = false;

  /// 圆角半径
  double _circular = 10.0;

  @override
  void initState() {
    super.initState();

    /// 绑定返回键
    widget.getRemoveAnimation(_remove);

    ///
    ///
    ///
    ///
    /// 动画区
    _animationController = AnimationController(duration: Duration(milliseconds: 300), vsync: this);

    _animation = CurvedAnimation(parent: _animationController, curve: Curves.linear);

    /// 当手指滑动时，最大限度是 [end],因此不能设置成 [_initHeight/2] ，而需设置为 [_maxHeight]，且应触发 [once] 单次事件来监听当动画播放到 [_initHeight/2] 时另其 [stop()];
    _animation = Tween(begin: 0.0, end: _maxHeight).animate(_animation);

    /// 初始化上升动作：从 [0.0] 到 [_maxHeight/2]
    _animationController.forward();

    _animationController.addListener(() {
      /// 监听初始播放到一半时停止
      if (!_isOnceHalfDone && _animation.value >= _maxHeight / 3) {
        _isOnceHalfDone = true;
        _animationController.stop();
      }

      /// 向下滚动到一定范围内自动 [remove]
      if (_sheetPageController.touchDirection == TouchDirection.forward && _animation.value <= MediaQueryData.fromWindow(window).padding.top * 2) {
        _remove();
      }

      /// 是否处在 [LoadingArea]
      if (_animation.value >= _scrollController.position.maxScrollExtent + 50) {
        _sheetPageController.isInLoadingArea = true;
        _sheetPageController.doNotifyListener();
      } else {
        _sheetPageController.isInLoadingArea = false;
        _sheetPageController.doNotifyListener();
      }

      /// 每次 [_animationController.value] 发生变化时调用,目的是调用 [setState]
      setState(() {});
    });

    _scrollController.addListener(() {
      /// 是否处在 [LoadingArea]
      if (_maxHeight + _scrollController.position.pixels > _scrollController.position.maxScrollExtent + 50) {
        _sheetPageController.isInLoadingArea = true;
        _sheetPageController.doNotifyListener();
      } else {
        _sheetPageController.isInLoadingArea = false;
        _sheetPageController.doNotifyListener();
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _animationController.dispose();

    super.dispose();
    print("dispose");
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 0,
      height: _animation.value,
      width: MediaQueryData.fromWindow(window).size.width,
      child: Listener(
        onPointerDown: _onPointerDown,
        onPointerMove: _onPointerMove,
        onPointerUp: _onPointerUp,

        ///
        child: Material(
          type: MaterialType.transparency,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(_circular),
            child: CustomScrollView(
              controller: _scrollController,
              slivers: widget.slivers(_sheetPageController),
            ),
          ),
        ),
      ),
    );
  }

  void _remove() {
    /// 禁止触发 [_onPointerXXX] 事件,并防止被多次触发 [remove]
    if (!_isWillRemoveOnce) {
      _isWillRemoveOnce = true;

      /// 这里不能把 [Curves.easeInQuart] 放到 [init] 中,需求是从慢到非常快，而放 [init] 里曲线是会是反向的先快后慢。
      _animationController.animateTo(0, duration: Duration(milliseconds: 300), curve: Curves.easeInQuart).whenCompleteOrCancel(() {
        /// [removeRoute(currentRoute)] 后,会调用 [dispose] ,以及当中的 [controller.dispose()] [removeListener()]
        /// 不能使用 [pop] ,因为当 [sheet] 已被打开时，再打开新的 [sheet] 时， [pop] 的话会把新打开的 [sheet] [pop] 了,而并不会把旧 [sheet] 关闭
        Navigator.of(this.context).removeRoute(widget.sheetRoute);
      });
    }
  }

  /// 事件
  void _onPointerDown(event) {
    if (_isWillRemoveOnce) {
      return;
    }

    /// 按下时所有的动画停止
    _animationController.stop();

    /// 清除
    _lastTouchDelta = 0.0;
  }

  void _onPointerMove(event) {
    if (_isWillRemoveOnce) {
      return;
    }

    /// 给 [_onPointerUp] 使用
    _lastTouchDelta = event.delta.dy;

    /// 监听触摸方向。如果 [touchDirection>0.0] 则正在向上滚动,如果 [touchDirection<0.0] 则正在向下滚动。
    TouchDirection touchDirection = event.delta.dy > 0.0 ? TouchDirection.forward : (event.delta.dy < 0.0 ? TouchDirection.reverse : TouchDirection.idle);
    _sheetPageController.touchDirection = touchDirection;

    /// 1、未满屏时，内部不滑动，外部滑动。
    if (_animation.value != _maxHeight) {
      _animationController.value -= event.delta.dy / _maxHeight;
      _scrollController.jumpTo(0);
    }

    /// 2、满屏时，内部滑动，外部不滑动。
    else if (_animation.value == _maxHeight) {
      /// 当 [offset==0.0] 时，可向下 [touch_move] ，回到 [1、] 。
      if (_scrollController.offset == 0.0) {
        _animationController.value -= event.delta.dy / _maxHeight;
      }
    }

    /// 已经在 [addListener] 中 [setState] 了
  }

  void _onPointerUp(event) {
    if (_isWillRemoveOnce) {
      return;
    }

    if (_animation.value != _maxHeight) {
      _animationController.animateTo(
        _animationController.value - (_lastTouchDelta / _maxHeight) * 20,
        curve: Curves.easeOutQuart,
        duration: Duration(milliseconds: 1000),
      );
    }

    ///
    else if (_animation.value == _maxHeight) {
      if (_scrollController.offset == 0.0) {
        _animationController.animateTo(
          _animationController.value - (_lastTouchDelta / _maxHeight) * 20,
          curve: Curves.easeOutQuart,
          duration: Duration(milliseconds: 1000),
        );
      }
    }
  }
}

///
///
///
///
///
enum TouchDirection { idle, forward, reverse }

class SheetPageController extends ChangeNotifier {
  void doNotifyListener() {
    notifyListeners();
  }

  TouchDirection touchDirection = TouchDirection.idle;

  /// 是否处在 [LoadingArea]
  bool isInLoadingArea = false;

  LoadingController loadingController = LoadingController();
}
