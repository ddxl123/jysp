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
      child: _containerBody(),
    );
  }

  Widget _containerBody() {
    return Container(
      color: widget.backgroundColor,

      ///视觉区域、触摸区域
      width: widget.boxWidth,
      height: widget.boxHeight,
      child: Stack(
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
                child: widget.child,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void onScaleStart(details) {
    if (widget.freeBoxController.freeBoxTouchStatus == FreeBoxTouchStatus.disableTouch) {
      return;
    }

    widget.freeBoxController.freeBoxTouchStatus = FreeBoxTouchStatus.onScaleStart;

    /// 停止所有滑动动画
    _slidingAnimationController.stop();

    /// 重置上一次 [临时缩放] 和 [临时触摸位置]
    _lastTempScale = 1;
    _lastTempTouchPosition = details.localFocalPoint;
  }

  void onScaleUpdate(details) {
    if (widget.freeBoxController.freeBoxTouchStatus == FreeBoxTouchStatus.disableTouch) {
      return;
    }

    widget.freeBoxController..freeBoxTouchStatus = FreeBoxTouchStatus.onScaleUpdate;

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
  }

  void onScaleEnd(ScaleEndDetails details) {
    if (widget.freeBoxController.freeBoxTouchStatus == FreeBoxTouchStatus.disableTouch) {
      return;
    }

    widget.freeBoxController.freeBoxTouchStatus = FreeBoxTouchStatus.onScaleEnd;

    /// 开始惯性滑动
    startInertialSliding(details);
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

    /// 把 [offset] [scale] 的改变放在 [_slidingAnimationController.addListener] 里的原因：
    /// [Animation.value] 的变化只能用 [_slidingAnimationController.addListener] 来监听获取变化
    /// 注意这里是 [惯性滑动] 的值变化监听,并非 [onScale]
    _slidingAnimationController.addListener(() {
      if (widget.freeBoxController.freeBoxSlidingStatus == FreeBoxSlidingStatus.inertialSliding) {
        widget.freeBoxController.offset = _slidingAnimation.value;
        setState(() {});
      }
      if (widget.freeBoxController.freeBoxSlidingStatus == FreeBoxSlidingStatus.zeroSliding) {
        widget.freeBoxController.offset = _slidingAnimation.value;
        widget.freeBoxController.scale = _scaleAnimation.value;
        setState(() {});
      }
      if (_slidingAnimationController.status == AnimationStatus.completed) {
        widget.freeBoxController.freeBoxSlidingStatus = FreeBoxSlidingStatus.none;
      }
    });
  }

  /// 开始惯性滑动
  void startInertialSliding(ScaleEndDetails details) {
    widget.freeBoxController.freeBoxSlidingStatus = FreeBoxSlidingStatus.inertialSliding;

    /// 设置动画片段
    _slidingAnimationController.duration = Duration(milliseconds: 500);
    _slidingAnimation = _slidingAnimationController.drive(CurveTween(curve: Curves.easeOutCubic)).drive(Tween(
          begin: widget.freeBoxController.offset,
          end: widget.freeBoxController.offset + Offset(details.velocity.pixelsPerSecond.dx / 10, details.velocity.pixelsPerSecond.dy / 10),
        ));

    _slidingAnimationController.forward(from: 0.0);
  }

  /// 恢复到初始位置、初始缩放
  void startZeroSliding() {
    widget.freeBoxController.freeBoxSlidingStatus = FreeBoxSlidingStatus.zeroSliding;

    _slidingAnimationController.duration = Duration(seconds: 1);
    _slidingAnimation = _slidingAnimationController.drive(CurveTween(curve: Curves.easeInOutBack)).drive(Tween(
          begin: widget.freeBoxController.offset,
          end: widget.freeBoxController.zeroPosition,
        ));
    _scaleAnimation = _slidingAnimationController.drive(CurveTween(curve: Curves.easeInOutBack)).drive(Tween(begin: widget.freeBoxController.scale, end: 1.0));

    _slidingAnimationController.forward(from: 0.4);
  }
}

enum FreeBoxTouchStatus { none, onScaleStart, onScaleUpdate, onScaleEnd, disableTouch }
enum FreeBoxSlidingStatus { none, inertialSliding, zeroSliding }

///
/// 不能直接让 [widget] [rebuild]，而只会触发 [addListener]
class FreeBoxController extends ChangeNotifier {
  /// 缩放值,默认必须1;偏移值,默认必须0
  double _scale = 1;
  double get scale => _scale;
  set scale(value) {
    _scale = value;
    notifyListeners();
  }

  Offset _offset = Offset(0, 0);
  Offset get offset => _offset;
  set offset(value) {
    _offset = value;
    notifyListeners();
  }

  /// 原点位置
  Offset zeroPosition = Offset.zero;

  /// 将缩放和位置移至原点
  Function startZeroSliding = () {};

  /// 禁用触摸事件
  void isDisableTouch(isDisable) {
    if (isDisable) {
      this.freeBoxTouchStatus = FreeBoxTouchStatus.disableTouch;
      notifyListeners();
    } else {
      this.freeBoxTouchStatus = FreeBoxTouchStatus.none;
      notifyListeners();
    }
  }

  /// 自动滑动状态
  FreeBoxSlidingStatus _freeBoxSlidingStatus = FreeBoxSlidingStatus.none;
  FreeBoxSlidingStatus get freeBoxSlidingStatus => _freeBoxSlidingStatus;
  set freeBoxSlidingStatus(value) {
    _freeBoxSlidingStatus = value;
    notifyListeners();
  }

  /// 触摸事件状态
  FreeBoxTouchStatus _freeBoxTouchStatus = FreeBoxTouchStatus.none;
  FreeBoxTouchStatus get freeBoxTouchStatus => _freeBoxTouchStatus;
  set freeBoxTouchStatus(value) {
    _freeBoxTouchStatus = value;
    notifyListeners();
  }
}
