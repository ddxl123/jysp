import 'package:flutter/material.dart';
import 'package:jysp/Plugin/SheetPage/SheetLoadAreaController.dart';
import 'package:jysp/Plugin/SheetPage/SheetPageController.dart';

class SheetLoadArea extends StatefulWidget {
  SheetLoadArea({required this.sheetPageController});
  final SheetPageController sheetPageController;

  @override
  _SheetLoadAreaState createState() => _SheetLoadAreaState();
}

class _SheetLoadAreaState extends State<SheetLoadArea> {
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
