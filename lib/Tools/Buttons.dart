import 'package:flutter/material.dart';

class MyButton extends StatefulWidget {
  MyButton({@required this.child, @required this.onPressed});
  final Widget child;
  final Function() onPressed;
  @override
  State<StatefulWidget> createState() {
    return _MyButton();
  }
}

class _MyButton extends State<MyButton> {
  Color _color = Colors.yellow;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Container(
        alignment: Alignment.center,
        color: _color,
        child: widget.child,
      ),
      onPanDown: (details) {
        _color = Colors.grey;
        setState(() {});
      },
      onPanEnd: (details) {
        _color = Colors.yellow;
        widget.onPressed();
        setState(() {});
      },
      onPanCancel: () {
        _color = Colors.yellow;
        widget.onPressed();
        setState(() {});
      },
      // onPanDown: (details) {
      //   _color = Colors.grey;
      //   setState(() {});
      //   return false;
      // },
      // onPanEnd: (details) {
      //   _color = Colors.yellow;
      //   widget.onPressed();
      //   setState(() {});
      //   return false;
      // },
      // onPanCancel: () {
      //   _color = Colors.yellow;
      //   setState(() {});
      //   return false;
      // },
    );
  }
}
