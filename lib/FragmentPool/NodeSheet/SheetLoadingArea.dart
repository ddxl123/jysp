import 'package:flutter/material.dart';
import 'package:jysp/Tools/LoadingAnimation.dart';
import 'package:jysp/Pages/SheetPage.dart';

class SheetLoadingArea extends StatefulWidget {
  SheetLoadingArea({
    @required this.sheetPageController,
    @required this.wait,
    @required this.startFuture,
    @required this.isOnce,
  });
  final SheetPageController sheetPageController;
  final Duration wait;
  final Function(LoadingController) startFuture;
  final bool isOnce;

  @override
  _SheetLoadingAreaState createState() => _SheetLoadingAreaState();
}

class _SheetLoadingAreaState extends State<SheetLoadingArea> {
  bool _onceDone = false;
  @override
  void initState() {
    super.initState();
    widget.sheetPageController.addListener(() {
      /// TODO: 进入加载区、滚动方向向上滚、手指放开时触发 [Loading] 条件
      if (widget.sheetPageController.isInLoadingArea && !_onceDone) {
        if (widget.isOnce) {
          _onceDone = true;
        }
        widget.sheetPageController.loadingController.toLoading(widget.wait, widget.startFuture);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: SliverFillRemaining(
        hasScrollBody: true,
        child: Container(
          color: Colors.white,
          child: LoadingAnimation(loadingController: widget.sheetPageController.loadingController),
        ),
      ),
    );
  }
}
