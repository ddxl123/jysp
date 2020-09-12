import 'dart:ui';

import 'package:flutter/material.dart';

class LoadingPage extends PageRoute {
  @override
  Color get barrierColor => null;

  @override
  String get barrierLabel => null;

  @override
  bool get opaque => false;

  @override
  Widget buildPage(BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation) {
    return _loadingBody();
  }

  @override
  bool get maintainState => false;

  @override
  Duration get transitionDuration => Duration(seconds: 0);

  Widget _loadingBody() {
    return Material(
      type: MaterialType.transparency,
      child: Stack(
        children: [
          BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 2, sigmaY: 2),
            child: Opacity(
              opacity: 0.1,
              child: Container(color: Colors.white),
            ),
          ),
          Positioned(
            child: Container(
              alignment: Alignment.center,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("loading..."),
                  Text("长按取消"),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
