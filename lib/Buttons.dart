import 'package:flutter/material.dart';

class MyButton extends StatefulWidget {
  MyButton({@required this.child});
  final Widget child;
  @override
  State<StatefulWidget> createState() {
    return _MyButton();
  }
}

class _MyButton extends State<MyButton> {
  Color _color = Colors.yellow;
  @override
  Widget build(BuildContext context) {
    return Listener(
      child: Container(
        width: 100,
        height: 100,
        color: _color,
        child: widget.child,
      ),
      onPointerDown: (event) {
        _color = Colors.grey;
        setState(() {});
      },
      onPointerCancel: (event) {
        _color = Colors.yellow;
        setState(() {});
      },
      onPointerUp: (event) {
        _color = Colors.yellow;
        setState(() {});
      },
    );
  }
}
