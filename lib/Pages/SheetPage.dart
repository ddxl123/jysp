import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

///
///
///
///
///
class SheetRoute extends OverlayRoute {
  SheetRoute({@required this.slivers});

  /// [topWidget] [topPaddingWidget] [bottomWidget]
  final List<Widget> Function(ScrollController) slivers;

  Function _removeAnimation = () {};

  @override
  Iterable<OverlayEntry> createOverlayEntries() {
    return [
      OverlayEntry(
        builder: (_) {
          return Stack(
            children: [
              _backgroundHitTest(),
              _sheetControl(),
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
        /// 当 [child: Container(color:null)] 时, [HitTestBehavior.translucent] 能触发背景点击事件
        /// TODO: 而当 [child: Container(color:Colors.transparent)] 时,并不会触发背景点击事件。不知为何原因。
        behavior: HitTestBehavior.translucent,
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

  Widget _sheetControl() {
    return SheetControl(
      sheetRoute: this,
      getRemoveAnimation: (ra) {
        this._removeAnimation = ra;
      },
      slivers: this.slivers,
    );
  }

  /// 返回键监听
  @override
  Future<RoutePopDisposition> willPop() {
    _removeAnimation();
    return Future.value(RoutePopDisposition.doNotPop);
  }
}

///
///
///
///
///
class SheetControl extends StatefulWidget {
  SheetControl({
    @required this.sheetRoute,
    @required this.getRemoveAnimation,

    ///
    @required this.slivers,
  });

  final SheetRoute sheetRoute;
  final Function getRemoveAnimation;

  final List<Widget> Function(ScrollController) slivers;

  @override
  _SheetControlState createState() => _SheetControlState();
}

class _SheetControlState extends State<SheetControl> with SingleTickerProviderStateMixin {
  /// 初始高度占满屏幕
  double _screenHeight = MediaQueryData.fromWindow(window).size.height;

  /// 动画
  Animation _animation;
  AnimationController _animationController;

  /// 内部滑动控制器
  ScrollController _scrollController = ScrollController();

  /// [初始化] 时播放到一半时停止的单次事件,防止初始化时滑到满屏
  bool _isOnceHalfDone = false;

  /// 惯性滑动，防止之后 [>=0.5] 并有另外动画时被持续 [stop()]，
  double _lastDelta = 0.0;

  /// 是否将被移除，防止 [_remove] 被触发多次
  bool _isWillRemoveOnce = false;

  /// 是否达到 [加载区]
  bool _isEnterLoadingArea = false;

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
    _animationController = AnimationController(vsync: this, duration: Duration(milliseconds: 300));

    _animation = CurvedAnimation(parent: _animationController, curve: Curves.linear);

    /// 当手指滑动时，最大限度是 [end],因此不能设置成 [_initHeight/2] ，而需设置为 [_initHeight]，且应触发 [once] 单次事件来监听当动画播放到 [_initHeight/2] 时另其 [stop()];
    _animation = Tween(begin: 0.0, end: _screenHeight).animate(_animation);

    /// 初始化上升动作：从 [0.0] 到 [_screenHeight/2]
    _animationController.forward();

    _animationController.addListener(() {
      /// 监听初始播放到一半时停止
      if (!_isOnceHalfDone && _animation.value >= _screenHeight / 2) {
        _isOnceHalfDone = true;
        _animationController.stop();
      }

      /// 下滑到一定范围内自动 [remove]
      if (_lastDelta > 0 && _animation.value <= MediaQueryData.fromWindow(window).padding.top * 2) {
        _remove();
      }

      /// 每次 [_animationController.value] 发生变化时调用,目的是调用 [setState]
      setState(() {});
    });

    ///
    ///
    ///
    /// [ScrollController] 区
    /// 是否达到加载区监听
    _scrollController.addListener(() {
      if (_scrollController.position.pixels >= (_scrollController.position.maxScrollExtent - _screenHeight)) {
        _isEnterLoadingArea = true;
      } else {
        _isEnterLoadingArea = false;
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
          child: CustomScrollView(
            controller: _scrollController,
            slivers: widget.slivers(_scrollController),
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
  }

  void _onPointerMove(event) {
    if (_isWillRemoveOnce) {
      return;
    }

    /// 1、未满屏时，即 [jumpTo(0)]
    /// 2、满屏时，当 [offset==0.0] 时，即向下 [touch_move] 时，回到 [1、] ，当向上 [touch_move] 时，正常滑动。
    /// [/ _initHeight] 是为了映射为 [0.0-1.0]
    if (_animation.value != _screenHeight) {
      _animationController.value -= event.delta.dy / _screenHeight;
      _scrollController.jumpTo(0);
    } else {
      if (_scrollController.offset == 0.0) {
        _animationController.value -= event.delta.dy / _screenHeight;
      }
    }

    /// 惯性动画
    _lastDelta = event.delta.dy;

    /// 已经在 [addListener] 中 [setState] 了
  }

  void _onPointerUp(event) {
    if (_isWillRemoveOnce) {
      return;
    }

    /// 同理 [onPointerMove]
    /// 这里 [animateTo] 值是 [0.0-1.0]
    if (_animation.value != _screenHeight) {
      _animationController.animateTo(
        _animationController.value - (_lastDelta / _screenHeight) * 20,
        curve: Curves.easeOutQuart,
        duration: Duration(milliseconds: 1000),
      );
    } else {
      if (_scrollController.offset == 0.0) {
        _animationController.animateTo(
          _animationController.value - (_lastDelta / _screenHeight) * 20,
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
