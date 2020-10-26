import 'package:flutter/material.dart';

class CustomButton extends StatefulWidget {
  CustomButton({
    @required this.child,
    @required this.onPressed,
    @required this.color,
  });
  final Widget child;
  final Function() onPressed;
  final Color color;
  @override
  State<StatefulWidget> createState() {
    return _CustomButton();
  }
}

class _CustomButton extends State<CustomButton> {
  Color _color;
  bool _isOnMove = false;
  @override
  Widget build(BuildContext context) {
    return Listener(
      child: Material(
        type: MaterialType.transparency,
        child: Container(
          alignment: Alignment.center,
          color: _color ?? widget.color,
          child: widget.child,
        ),
      ),
      onPointerDown: (details) {
        _isOnMove = false;
        toOnDownStatus();
      },
      onPointerUp: (details) {
        if (_isOnMove == false) {
          widget.onPressed();
        }
        toNormalStatus();
      },
      onPointerMove: (event) {
        if (_isOnMove == false && (event.delta.dx > 0.5 || event.delta.dy > 0.5 || event.delta.dx < -0.5 || event.delta.dy < -0.5)) {
          _isOnMove = true;
          toNormalStatus();
        }
      },
    );
  }

  void toNormalStatus() {
    _color = widget.color;
    setState(() {});
  }

  void toOnDownStatus() {
    _color = Colors.grey;
    setState(() {});
  }
}
