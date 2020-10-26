import 'dart:ui';

import 'package:flutter/material.dart';

class LoadingAnimation extends StatefulWidget {
  LoadingAnimation({@required this.loadingController});
  final LoadingController loadingController;

  @override
  _LoadingAnimationState createState() => _LoadingAnimationState();
}

class _LoadingAnimationState extends State<LoadingAnimation> with SingleTickerProviderStateMixin {
  AnimationController _animationController;
  Animation _animation;

  /// 0表示loading,1表示success,2表示fail
  int _stataus = 0;

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(vsync: this, duration: Duration(seconds: 1));
    _animation = CurvedAnimation(parent: _animationController, curve: Curves.linear);
    _animation = Tween(begin: 0.0, end: MediaQueryData.fromWindow(window).size.width).animate(_animation);
    widget.loadingController.toLoading = _toLoading;
    widget.loadingController.toSuccess = _toSuccess;
    widget.loadingController.toFail = _toFail;
  }

  void _toLoading() {
    if (_stataus == 0) {
      return;
    }
    _stataus = 0;
    _animationController.value = 0.0;
    _animationController.repeat(reverse: true);
    _animationController.addListener(() {
      setState(() {});
      if (_animationController.value == 1.0) {
        _animationController.reverse();
      }
    });
  }

  void _toSuccess() {
    if (_stataus == 1) {
      return;
    }
    _stataus = 1;
    _animationController.stop();
    setState(() {});
  }

  void _toFail() {
    if (_stataus == 2) {
      return;
    }
    _stataus = 2;
    _animationController.stop();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    switch (_stataus) {
      case 0:
        return Container(
          alignment: Alignment.center,
          child: Container(
            color: Colors.blue,
            width: _animation.value,
          ),
        );
        break;
      case 1:
        return Container(
          alignment: Alignment.center,
          child: Text("no more"),
        );
        break;
      case 2:
        return Container(
          alignment: Alignment.center,
          child: Text("fail"),
        );
        break;
      default:
        return Container(
          alignment: Alignment.center,
          child: Text("发生了异常"),
        );
    }
  }
}

class LoadingController {
  Function toLoading = () {};
  Function toSuccess = () {};
  Function toFail = () {};
}
