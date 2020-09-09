import 'package:flutter/material.dart';

class CustomButton extends StatefulWidget {
  CustomButton({@required this.child, @required this.onPressed});
  final Widget child;
  final Function() onPressed;
  @override
  State<StatefulWidget> createState() {
    return _CustomButton();
  }
}

class _CustomButton extends State<CustomButton> {
  Color _color = Colors.yellow;
  bool _isOnMove = false;
  @override
  Widget build(BuildContext context) {
    return Listener(
      child: Material(
        child: Container(
          alignment: Alignment.center,
          color: _color,
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
    _color = Colors.yellow;
    setState(() {});
  }

  void toOnDownStatus() {
    _color = Colors.grey;
    setState(() {});
  }
}
