import 'package:flutter/material.dart';

class WidgetBuildBase<T> extends StatelessWidget {
  WidgetBuildBase(this.widget);
  final T widget;

  @override
  Widget build(BuildContext context) {
    throw UnimplementedError();
  }
}
