import 'package:flutter/material.dart';
import 'package:jysp/Tools/TDebug.dart';

class _Init extends ChangeNotifier {}

mixin _Root on _Init {
  ///

  /// 缩放值,默认必须1
  double scale = 1;

  /// 偏移值,默认必须(0,0)
  Offset offset = Offset(0, 0);

  /// 左上角偏移填充
  Offset leftTopOffsetFilling = Offset(5000, 5000);

  bool doRebuild = false;

  ///
}

mixin _TouchEvent on _Root {
  ///

  late final AnimationController inertialSlideAnimationController;
  late final AnimationController targetSlideAnimationController;
  late Animation _offsetAnimation;
  late Animation _scaleAnimation;

  double _lastTempScale = 1;
  Offset _lastTempTouchPosition = Offset(0, 0);

  /// 是否禁用触摸
  bool _isDisableTouch = false;

  /// touch 事件
  void onScaleStart(details) {
    if (_isDisableTouch) {
      return;
    }

    /// 停止所有滑动动画
    inertialSlideAnimationController.stop();
    targetSlideAnimationController.stop();

    /// 重置上一次 [临时缩放] 和 [临时触摸位置]
    _lastTempScale = 1;
    _lastTempTouchPosition = details.localFocalPoint;
    dLog(() => "onScaleStart:" + offset.toString());
    notifyListeners();
  }

  void onScaleUpdate(details) {
    if (_isDisableTouch) {
      return;
    }

    /// 进行缩放
    double deltaScale = details.scale - _lastTempScale;
    this.scale *= 1 + deltaScale;

    /// 缩放后的位置偏移
    Offset pivotDeltaOffset = (this.offset - details.localFocalPoint) * deltaScale;
    this.offset += pivotDeltaOffset;

    /// 非缩放的位置偏移
    Offset deltaOffset = details.localFocalPoint - _lastTempTouchPosition;
    this.offset += deltaOffset;

    /// 变换上一次 [临时缩放] 和 [临时触摸位置]
    _lastTempScale = details.scale;
    _lastTempTouchPosition = details.localFocalPoint;

    dLog(() => "onScaleUpdate:" + offset.toString());
    notifyListeners();
  }

  void onScaleEnd(ScaleEndDetails details) {
    if (_isDisableTouch) {
      return;
    }

    /// 开始惯性滑动
    inertialSlideAnimationController.duration = Duration(milliseconds: 500);
    _offsetAnimation = inertialSlideAnimationController.drive(CurveTween(curve: Curves.easeOutCubic)).drive(Tween(
          begin: this.offset,
          end: this.offset + Offset(details.velocity.pixelsPerSecond.dx / 10, details.velocity.pixelsPerSecond.dy / 10),
        ));

    inertialSlideAnimationController.forward(from: 0.0);
    inertialSlideAnimationController.addListener(_inertialSlideListener);
    dLog(() => "onScaleEnd:" + offset.toString());
  }

  // 惯性滑动监听
  void _inertialSlideListener() {
    this.offset = _offsetAnimation.value;

    /// 被 stop() 或 动画播放完成 时, removeListener()
    if (inertialSlideAnimationController.isDismissed || inertialSlideAnimationController.isCompleted) {
      inertialSlideAnimationController.removeListener(_inertialSlideListener);
    }
    dLog(() => "_inertialSlideListener:" + offset.toString());
    notifyListeners();
  }

  ///
}

mixin _CommonTool on _TouchEvent {
  ///

  /// 禁用触摸事件
  void isDisableTouch(bool isDisable) {
    _isDisableTouch = isDisable;
  }

  /// 滑动至目标位置
  void targetSlide({required Offset targetOffset, required double targetScale}) {
    targetSlideAnimationController.duration = Duration(seconds: 1);
    _offsetAnimation = targetSlideAnimationController.drive(CurveTween(curve: Curves.easeInOutBack)).drive(Tween(
          begin: this.offset,
          end: targetOffset,
        ));
    _scaleAnimation = targetSlideAnimationController.drive(CurveTween(curve: Curves.easeInOutBack)).drive(Tween(
          begin: this.scale,
          end: targetScale,
        ));
    targetSlideAnimationController.forward(from: 0.4);
    targetSlideAnimationController.addListener(_targetSlideListener);
  }

  /// 滑动至目标位置监听
  void _targetSlideListener() {
    this.offset = _offsetAnimation.value;
    this.scale = _scaleAnimation.value;

    /// 被 stop() 或 动画播放完成 时, removeListener()
    if (targetSlideAnimationController.isDismissed || targetSlideAnimationController.isCompleted) {
      targetSlideAnimationController.removeListener(_targetSlideListener);
    }
    notifyListeners();
  }

  ///
}

class FreeBoxController extends _Init with _Root, _TouchEvent, _CommonTool {}