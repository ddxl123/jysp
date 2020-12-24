import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:jysp/G/G.dart';

void showToast(String text) {
  OverlayState overlayState = Overlay.of(G.globalKey.currentContext);
  OverlayEntry entry = OverlayEntry(
    builder: (context) {
      return Toast(text: text);
    },
  );
  overlayState.insert(entry);
  Future.delayed(Duration(seconds: 2), () {
    entry.remove();
  });
}

class Toast extends StatefulWidget {
  Toast({this.text});
  final String text;

  @override
  _ToastState createState() => _ToastState();
}

class _ToastState extends State<Toast> {
  @override
  Widget build(BuildContext context) {
    List colors = [Colors.red, Colors.green, Colors.yellow, Colors.amber, Colors.blue, Colors.cyan, Colors.indigo];
    Random random = Random();
    return Container(
      padding: EdgeInsets.fromLTRB(0, MediaQueryData.fromWindow(window).padding.top, 0, 0),
      alignment: Alignment.topCenter,
      child: Material(
        child: Container(
          color: colors[random.nextInt(7)],
          child: Text(
            widget.text,
            style: TextStyle(fontSize: 18),
          ),
        ),
      ),
    );
  }
}
