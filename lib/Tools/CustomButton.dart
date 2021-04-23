import 'package:flutter/material.dart';

class CustomButton extends StatefulWidget {
  const CustomButton({
    required this.child,
    required this.onPressed,
    this.upBackgroundColor = Colors.transparent,
    this.downBackgroundColor = Colors.grey,
  });
  final Widget child;
  final Function() onPressed;
  final Color upBackgroundColor;
  final Color downBackgroundColor;
  @override
  State<StatefulWidget> createState() {
    return _CustomButton();
  }
}

class _CustomButton extends State<CustomButton> {
  Color? _currentColor;
  bool _isOnMove = false;

  @override
  Widget build(BuildContext context) {
    return Listener(
      child: Material(
        type: MaterialType.transparency,
        child: Container(
          alignment: Alignment.center,
          color: _currentColor ?? widget.upBackgroundColor,
          child: widget.child,
        ),
      ),
      onPointerDown: (PointerDownEvent details) {
        _isOnMove = false;
        toOnDownStatus();
      },
      onPointerUp: (PointerUpEvent details) {
        if (_isOnMove == false) {
          widget.onPressed();
        }
        toNormalStatus();
      },
      onPointerMove: (PointerMoveEvent event) {
        if (_isOnMove == false && (event.delta.dx > 0.5 || event.delta.dy > 0.5 || event.delta.dx < -0.5 || event.delta.dy < -0.5)) {
          _isOnMove = true;
          toNormalStatus();
        }
      },
    );
  }

  void toNormalStatus() {
    _currentColor = widget.upBackgroundColor;
    setState(() {});
  }

  void toOnDownStatus() {
    _currentColor = widget.downBackgroundColor;
    setState(() {});
  }
}
