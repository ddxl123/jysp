import 'package:flutter/material.dart';
import 'package:jysp/LWCR/Controller/FragmentPoolController.dart';
import 'package:jysp/LWCR/Controller/FreeBoxController.dart';
import 'package:jysp/LWCR/WidgetBuild/FragmentPoolWB.dart';

class FragmentPoolLC extends StatefulWidget {
  FragmentPoolLC({required this.fragmentPoolController, required this.freeBoxController});
  final FragmentPoolController fragmentPoolController;
  final FreeBoxController freeBoxController;

  @override
  _FragmentPoolLCState createState() => _FragmentPoolLCState();
}

class _FragmentPoolLCState extends State<FragmentPoolLC> {
  @override
  void initState() {
    super.initState();
    widget.fragmentPoolController.isIniting = true;
    widget.fragmentPoolController.rebuild = () {
      this.setState(() {});
    };
    WidgetsBinding.instance!.addPostFrameCallback(
      (timeStamp) {
        widget.fragmentPoolController.isIniting = false;
        widget.fragmentPoolController.toPool(
          freeBoxController: widget.freeBoxController,
          toPoolType: widget.fragmentPoolController.getCurrentPoolType,
          toPoolTypeResult: (resultCode) {},
        );
      },
    );
  }

  @override
  void dispose() {
    widget.fragmentPoolController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => FragmentPoolWB(widget);
}
