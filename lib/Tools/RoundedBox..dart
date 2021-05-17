import 'package:flutter/material.dart';

/// 圆角框
class RoundedBox extends StatelessWidget {
  /// [width]\[height] 最大值为屏幕宽\高度值，为 null 时按照子 widget 的宽\高值。
  const RoundedBox({required this.width, required this.height, required this.pidding, required this.children});

  final double? width;
  final double? height;
  final EdgeInsetsGeometry? pidding;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      constraints: BoxConstraints(minWidth: 0, maxWidth: MediaQuery.of(context).size.width, minHeight: 0, maxHeight: MediaQuery.of(context).size.height),
      padding: pidding,
      decoration: BoxDecoration(
        color: Colors.yellow,
        borderRadius: BorderRadius.circular(10),
        boxShadow: const <BoxShadow>[
          BoxShadow(offset: Offset(10, 10), blurRadius: 10, spreadRadius: -10),
        ],
      ),
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(parent: BouncingScrollPhysics()),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[...children],
        ),
      ),
    );
  }
}
