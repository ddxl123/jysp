import 'package:flutter/material.dart';

class RoundedBox extends StatelessWidget {
  /// column 类型的圆角框。
  ///
  /// 应用于简单弹出框，或简单的非弹出框。
  const RoundedBox({
    this.width,
    this.height,
    this.pidding,
    required this.children,
    this.crossAxisAlignment = CrossAxisAlignment.center,
    this.isScrollale = true,
  });

  /// [width] 和 [height] 最大值为屏幕宽\高度值，为 null 时按照子 widget 的宽\高值。
  final double? width;

  /// [width] 和 [height] 最大值为屏幕宽\高度值，为 null 时按照子 widget 的宽\高值。
  final double? height;

  final EdgeInsetsGeometry? pidding;

  /// [crossAxisAlignment]：[children] 整体的横轴对齐。
  final CrossAxisAlignment crossAxisAlignment;

  /// 是否可滚动
  final bool isScrollale;

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Container(
      // 如果不 alignment，SingleChildScrollView/Column 宽度默认是展开到父容器那么大，alignment 后会以 children 最大的宽度为准
      alignment: Alignment.center,
      child: Container(
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
        child: () {
          if (isScrollale) {
            return SingleChildScrollView(
              padding: EdgeInsets.zero,
              physics: const AlwaysScrollableScrollPhysics(parent: BouncingScrollPhysics()),
              child: Column(
                crossAxisAlignment: crossAxisAlignment,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[...children],
              ),
            );
          } else {
            return Column(
              crossAxisAlignment: crossAxisAlignment,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[...children],
            );
          }
        }(),
      ),
    );
  }
}
