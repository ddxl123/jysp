import 'dart:async';

import 'package:flutter/material.dart';
import 'package:jysp/Tools/TDebug.dart';

class _Init extends ChangeNotifier {}

mixin _Root on _Init {
  ///

  /// 缩放值,默认必须1
  double scale = 1;

  /// 偏移值,默认必须(0,0)
  Offset offset = const Offset(0, 0) - const Offset(100, 100);

  /// 左上角偏移填充
  Offset leftTopOffsetFilling = const Offset(100, 100);

  bool doRebuild = false;

  ///
}

mixin _TouchEvent on _Root {
  ///

  late final AnimationController inertialSlideAnimationController;
  late final AnimationController targetSlideAnimationController;
  late Animation<Offset> _offsetAnimation;
  late Animation<double> _scaleAnimation;

  double _lastTempScale = 1;
  Offset _lastTempTouchPosition = const Offset(0, 0);

  /// 是否禁用触摸事件
  bool _isDisableTouch = false;

  /// 是否禁用 end 触摸事件
  bool _isDisableEndTouch = false;

  /// 长按开始的回调
  Function(ScaleStartDetails)? onLongPressStart;

  /// 触发长按的时长的 Timer
  Timer? _onLongPressStartTimer;

  /// touch 事件
  void onScaleStart(ScaleStartDetails details) {
    if (_isDisableTouch) {
      return;
    }
    _onLongPressStartTimer = Timer(const Duration(milliseconds: 1000), () {
      dLog(() => '123');
      if (onLongPressStart != null) {
        dLog(() => '345');
        onLongPressStart!(details);
        dLog(() => '456');
      }
    });

    /// 停止所有滑动动画
    inertialSlideAnimationController.stop();
    targetSlideAnimationController.stop();

    /// 重置上一次 [临时缩放] 和 [临时触摸位置]
    _lastTempScale = 1;
    _lastTempTouchPosition = details.localFocalPoint;
    notifyListeners();
  }

  void onScaleUpdate(ScaleUpdateDetails details) {
    if (_isDisableTouch) {
      return;
    }
    _onLongPressStartTimer?.cancel();

    /// 进行缩放
    final double deltaScale = details.scale - _lastTempScale;
    scale *= 1 + deltaScale;

    /// 缩放后的位置偏移
    final Offset pivotDeltaOffset = (offset - details.localFocalPoint) * deltaScale;
    offset += pivotDeltaOffset;

    /// 非缩放的位置偏移
    final Offset deltaOffset = details.localFocalPoint - _lastTempTouchPosition;
    offset += deltaOffset;

    /// 变换上一次 [临时缩放] 和 [临时触摸位置]
    _lastTempScale = details.scale;
    _lastTempTouchPosition = details.localFocalPoint;

    // dLog(() => "onScaleUpdate:" + offset.toString());
    notifyListeners();
  }

  void onScaleEnd(ScaleEndDetails details) {
    if (_isDisableTouch || _isDisableEndTouch) {
      _isDisableEndTouch = false;
      return;
    }

    if (_onLongPressStartTimer?.isActive ?? false) {
      _onLongPressStartTimer?.cancel();
    }

    /// 开始惯性滑动
    inertialSlideAnimationController.duration = const Duration(milliseconds: 500);
    _offsetAnimation = inertialSlideAnimationController.drive(CurveTween(curve: Curves.easeOutCubic)).drive(Tween<Offset>(
          begin: offset,
          end: offset + Offset(details.velocity.pixelsPerSecond.dx / 10, details.velocity.pixelsPerSecond.dy / 10),
        ));

    inertialSlideAnimationController.forward(from: 0.0);
    inertialSlideAnimationController.addListener(_inertialSlideListener);
  }

  // 惯性滑动监听
  void _inertialSlideListener() {
    offset = _offsetAnimation.value;

    /// 被 stop() 或 动画播放完成 时, removeListener()
    if (inertialSlideAnimationController.isDismissed || inertialSlideAnimationController.isCompleted) {
      inertialSlideAnimationController.removeListener(_inertialSlideListener);
    }
    // dLog(() => "_inertialSlideListener:" + offset.toString());
    notifyListeners();
  }

  ///
}

mixin _CommonTool on _TouchEvent {
  ///

  /// 禁用触摸事件。
  /// [_isDisableEndTouch] 的目的是为了防止接触禁用后，end 函数体内任务仍然被触发
  void disableTouch(bool isDisable) {
    if (isDisable) {
      _isDisableTouch = true;
      _isDisableEndTouch = true;
    } else {
      _isDisableTouch = false;
    }
  }

  /// 屏幕坐标转盒子坐标
  Offset screenToBoxTransform(Offset screenPosition) {
    return (screenPosition - offset) / scale - const Offset(100, 100);
  }

  /// 滑动至目标位置
  void targetSlide({required Offset targetOffset, required double targetScale}) {
    targetSlideAnimationController.duration = const Duration(seconds: 1);
    _offsetAnimation = targetSlideAnimationController.drive(CurveTween(curve: Curves.easeInOutBack)).drive(Tween<Offset>(
          begin: offset,
          end: targetOffset,
        ));
    _scaleAnimation = targetSlideAnimationController.drive(CurveTween(curve: Curves.easeInOutBack)).drive(Tween<double>(
          begin: scale,
          end: targetScale,
        ));
    targetSlideAnimationController.forward(from: 0.4);
    targetSlideAnimationController.addListener(_targetSlideListener);
  }

  /// 滑动至目标位置监听
  void _targetSlideListener() {
    offset = _offsetAnimation.value;
    scale = _scaleAnimation.value;

    /// 被 stop() 或 动画播放完成 时, removeListener()
    if (targetSlideAnimationController.isDismissed || targetSlideAnimationController.isCompleted) {
      targetSlideAnimationController.removeListener(_targetSlideListener);
    }
    notifyListeners();
  }

  ///
}

class FreeBoxController extends _Init with _Root, _TouchEvent, _CommonTool {}
