import 'dart:async';

import 'package:flutter/material.dart';
import 'package:jysp/g/G.dart';
import 'package:jysp/tools/Helper.dart';

enum OnStatus { none, up, down, moving }

/// 当 [CustomButton] 被触发 setState，并不会 setState child，因为 child 是一个对象
///
/// [isAlwaysOnDown]\[isAlwaysOnUp]\[isAlwaysOnLongPressed]：是否总是触发该 Listener，若为 false，则只会触发底层 widget 的 Listener
///
/// [backgroundColor]：正常情况下的背景颜色。
///
/// [downBackgroundColor]：触发 down 时的背景颜色。
class CustomButton extends StatefulWidget {
  const CustomButton({
    required this.child,
    this.onDown,
    this.onUp,
    this.onLongPressed,
    this.isAlwaysOnDown = false,
    this.isAlwaysOnUp = false,
    this.isAlwaysOnLongPressed = false,
    this.backgroundColor = Colors.pink,
    this.downBackgroundColor = Colors.grey,
  });
  final Widget child;
  final Function(PointerDownEvent details)? onDown;
  final Function(PointerUpEvent details)? onUp;
  final Function(PointerDownEvent details)? onLongPressed;
  final bool isAlwaysOnDown;
  final bool isAlwaysOnUp;
  final bool isAlwaysOnLongPressed;
  final Color backgroundColor;
  final Color downBackgroundColor;

  @override
  State<StatefulWidget> createState() {
    return _CustomButton();
  }
}

class _CustomButton extends State<CustomButton> {
  Color? _currentColor;
  Offset _onDownPosition = Offset.zero;
  OnStatus _onStatus = OnStatus.none;
  Timer? _timer;

  final int _longPressedTime = 1000;
  final double _moveRange = 5.0;

  @override
  Widget build(BuildContext context) {
    return Listener(
      child: Container(
        color: _currentColor ?? widget.backgroundColor,
        child: widget.child,
      ),
      onPointerDown: (PointerDownEvent details) {
        _onDownPosition = details.position;
        _timer = Timer(Duration(milliseconds: _longPressedTime), () {
          setLongPressedStatus(details);
        });
        _onStatus = OnStatus.down;
        setDownStatus(details);
      },
      onPointerUp: (PointerUpEvent details) {
        // 若长按被触发后触发了 up
        if (!(_timer?.isActive ?? true)) {
          runSetState(setState);
          return;
        }

        // 当被移动到触发区外时，
        if (_onStatus == OnStatus.none) {
          return;
        }

        // 当按下未移动，或按下后移动且仍处在 [moving 区] 内时，
        else if (_onStatus == OnStatus.down || _onStatus == OnStatus.moving) {
          _timer?.cancel();
          setUpStatus(details);
        }
      },
      onPointerMove: (PointerMoveEvent event) {
        // 若长按被触发后触发了 move
        if (!(_timer?.isActive ?? true)) {
          return;
        }

        // 处在 [moving 区] 外时，
        final Offset delta = event.position - _onDownPosition;
        if (delta.dx > _moveRange || delta.dy > _moveRange || delta.dx < -_moveRange || delta.dy < -_moveRange) {
          _onStatus = OnStatus.none;
          _timer?.cancel();
          setNoneStatus();
        }

        // 处在 [moving 区] 内时，
        // 移动出 [moving 区] 后又回来还是会被触发 up
        else {
          _onStatus = OnStatus.moving;
          setMovingStatus();
        }
      },
    );
  }

  void setNoneStatus() {
    _currentColor = widget.backgroundColor;
    runSetState(setState);
  }

  void setMovingStatus() {
    _currentColor = widget.backgroundColor;
    runSetState(setState);
  }

  void setDownStatus(PointerDownEvent details) {
    final Function event = () {
      _currentColor = widget.downBackgroundColor;
      widget.onDown?.call(details);
      runSetState(setState);
    };
    if (widget.isAlwaysOnDown) {
      event();
    } else {
      onDownEvents.add(event);
    }
  }

  void setUpStatus(PointerUpEvent details) {
    final Function event = () {
      _currentColor = widget.backgroundColor;
      widget.onUp?.call(details);
      runSetState(setState);
    };
    if (widget.isAlwaysOnUp) {
      event();
    } else {
      onUpEvents.add(event);
    }
  }

  void setLongPressedStatus(PointerDownEvent details) {
    final Function event = () {
      _currentColor = widget.backgroundColor;
      widget.onLongPressed?.call(details);
      runSetState(setState);
    };
    if (widget.isAlwaysOnLongPressed) {
      event();
    } else {
      onLongPressedEvents.add(event);
    }
  }
}
