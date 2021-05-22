import 'package:flutter/material.dart';
import 'package:jysp/Tools/SheetPage/SheetLoadAreaController.dart';
import 'package:jysp/Tools/SheetPage/SheetPageController.dart';

class SheetLoadArea<T, M> extends StatefulWidget {
  const SheetLoadArea({required this.sheetPageController});
  final SheetPageController<T, M> sheetPageController;

  @override
  _SheetLoadAreaState<T, M> createState() => _SheetLoadAreaState<T, M>();
}

class _SheetLoadAreaState<T, M> extends State<SheetLoadArea<T, M>> {
  @override
  Widget build(BuildContext context) {
    return SliverFillRemaining(
      hasScrollBody: true,
      child: Container(
        alignment: Alignment.center,
        color: Colors.white,
        child: Text(widget.sheetPageController.sheetLoadAreaController.sheetLoadAreaStatus.text),
      ),
    );
  }
}
