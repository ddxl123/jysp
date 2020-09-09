import 'dart:ui';

import 'package:flutter/material.dart';

class FreeBox extends StatefulWidget {
  FreeBox({
    @required this.child,
    @required this.backgroundColor,
    this.boxWidth = double.maxFinite,
    this.boxHeight = double.maxFinite,
    this.eventWidth = double.maxFinite,
    this.eventHeight = double.maxFinite,
    this.freeBoxController,
  });
  final Widget child;
  final Color backgroundColor;
  final double boxWidth;
  final double boxHeight;
  final double eventWidth;
  final double eventHeight;
  final FreeBoxController freeBoxController;

  @override
  State<StatefulWidget> createState() {
    return _FreeBox();
  }
}

class _FreeBox extends State<FreeBox> with SingleTickerProviderStateMixin {
  double _lastTempScale = 1;
  Offset _lastTempTouchPosition = Offset(0, 0);

  AnimationController _slidingAnimationController;
  Animation _slidingAnimation;
  Animation _scaleAnimation;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onScaleStart: onScaleStart,
      onScaleUpdate: onScaleUpdate,
      onScaleEnd: onScaleEnd,
      child: containerBody(),
    );
  }

  Widget containerBody() {
    return Container(
      alignment: Alignment.center,
      color: widget.backgroundColor,

      ///视觉区域、触摸区域
      width: widget.boxWidth,
      height: widget.boxHeight,
      child:

          /// [AnimatedBuilder] 会自动监听并调用 [setState]
          AnimatedBuilder(
        builder: (context, child) {
          return Stack(
            children: <Widget>[
              Positioned(
                /// 内部事件区域
                width: widget.eventWidth,
                height: widget.eventHeight,
                child: Transform.translate(
                  offset: widget.freeBoxController.offset,
                  child: Transform.scale(
                    alignment: Alignment.topLeft,
                    scale: widget.freeBoxController.scale,
                    child: child,
                  ),
                ),
              ),
            ],
          );
        },

        /// 最好用 [AnimationController]
        /// 第一,它继承自是 [Animation]
        /// 第二, [animation] 并未初始化,而 [AnimationController] 初始化了
        /// 第三, [animation] 的地址会发生变化,而 [AnimationController] 是唯一的
        animation: _slidingAnimationController,
        child: widget.child,
      ),
    );
  }

  void onScaleStart(details) {
    widget.freeBoxController._changeDate(
      freeBoxStatus: FreeBoxStatus.onScaleStart,
      callback: () {
        /// 停止所有滑动动画
        _slidingAnimationController.stop();

        /// 重置上一次 [临时缩放] 和 [临时触摸位置]
        _lastTempScale = 1;
        _lastTempTouchPosition = details.localFocalPoint;
      },
    );
  }

  void onScaleUpdate(details) {
    widget.freeBoxController._changeDate(
      freeBoxStatus: FreeBoxStatus.onScaleUpdate,
      callback: () {
        /// 进行缩放
        double deltaScale = details.scale - _lastTempScale;
        widget.freeBoxController.scale *= 1 + deltaScale;

        /// 缩放后的位置偏移
        Offset pivotDeltaOffset = (widget.freeBoxController.offset - details.localFocalPoint) * deltaScale;
        widget.freeBoxController.offset += pivotDeltaOffset;

        /// 非缩放的位置偏移
        Offset deltaOffset = details.localFocalPoint - _lastTempTouchPosition;
        widget.freeBoxController.offset += deltaOffset;

        /// 变换上一次 [临时缩放] 和 [临时触摸位置]
        _lastTempScale = details.scale;
        _lastTempTouchPosition = details.localFocalPoint;

        setState(() {});
      },
    );
  }

  void onScaleEnd(ScaleEndDetails details) {
    /// 添加改变监听
    widget.freeBoxController._changeDate(
      freeBoxStatus: FreeBoxStatus.onScaleEnd,
      callback: () {
        /// 开始惯性滑动
        startInertialSliding(details);
      },
    );
  }

  @override
  void initState() {
    super.initState();

    initInertialSliding();
    widget.freeBoxController.startZeroSliding = this.startZeroSliding;
  }

  @override
  void dispose() {
    /// 必须放在 [super.dispose()] 前执行
    _slidingAnimationController.dispose();
    super.dispose();
  }

  /// 初始化惯性滑动
  void initInertialSliding() {
    _slidingAnimationController = AnimationController(vsync: this);

    /// [AnimatedBuilder] 自带 触发 [addListener] 会自动 [setState] ,而 [_changeDate] 并不会触发 [setState] , 只会响应 [freeBoxController.addListener]（不会触发 [setState]）
    _slidingAnimationController.addListener(() {
      if (widget.freeBoxController.freeBoxStatus == FreeBoxStatus.inertialSliding) {
        widget.freeBoxController.offset = _slidingAnimation.value;
      }
      if (widget.freeBoxController.freeBoxStatus == FreeBoxStatus.zeroSliding) {
        widget.freeBoxController.offset = _slidingAnimation.value;
        widget.freeBoxController.scale = _scaleAnimation.value;
      }
    });
  }

  /// 开始惯性滑动
  void startInertialSliding(ScaleEndDetails details) {
    widget.freeBoxController._changeDate(
      freeBoxStatus: FreeBoxStatus.inertialSliding,
      callback: () {
        /// 设置动画片段
        _slidingAnimationController.duration = Duration(milliseconds: 500);
        _slidingAnimation = _slidingAnimationController.drive(CurveTween(curve: Curves.easeOutCubic)).drive(Tween(
              begin: widget.freeBoxController.offset,
              end: widget.freeBoxController.offset + Offset(details.velocity.pixelsPerSecond.dx / 10, details.velocity.pixelsPerSecond.dy / 10),
            ));

        _slidingAnimationController.forward(from: 0.0);
      },
    );
  }

  /// 恢复到初始位置、初始缩放
  void startZeroSliding() {
    widget.freeBoxController._changeDate(
      freeBoxStatus: FreeBoxStatus.zeroSliding,
      callback: () {
        _slidingAnimationController.duration = Duration(seconds: 1);
        _slidingAnimation = _slidingAnimationController.drive(CurveTween(curve: Curves.easeInOutBack)).drive(Tween(
              begin: widget.freeBoxController.offset,
              end: widget.freeBoxController.zeroPosition,
            ));
        _scaleAnimation = _slidingAnimationController.drive(CurveTween(curve: Curves.easeInOutBack)).drive(Tween(begin: widget.freeBoxController.scale, end: 1.0));

        _slidingAnimationController.forward(from: 0.4);
      },
    );
  }
}

enum FreeBoxStatus { none, onScaleStart, onScaleUpdate, onScaleEnd, inertialSliding, zeroSliding }

class FreeBoxController extends ChangeNotifier {
  /// 缩放值,默认必须1;偏移值,默认必须0
  double scale = 1;
  Offset offset = Offset(0, 0);

  /// 事件状态
  FreeBoxStatus freeBoxStatus = FreeBoxStatus.none;

  /// 原点位置
  Offset zeroPosition = Offset.zero;

  /// 将缩放和位置移至原点
  Function startZeroSliding = () {};

  /// 有变动数据则调用
  void _changeDate({@required FreeBoxStatus freeBoxStatus, @required Function callback}) {
    this.freeBoxStatus = freeBoxStatus ?? FreeBoxStatus.none;
    callback();

    /// 不能直接让 [widget] [rebuild]，而只会触发 [addListener]
    notifyListeners();
  }
}
