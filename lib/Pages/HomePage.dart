import 'package:flutter/material.dart';
import 'package:jysp/FragmentPool/FragmentPool.dart';
import 'package:jysp/FragmentPool/Nodes/ToolNodes/FreeBox.dart';

class HomePage extends StatefulWidget {
  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  FreeBoxController _freeBoxController = FreeBoxController();

  @override
  void dispose() {
    _freeBoxController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Stack(
        children: <Widget>[
          _freeBoxWidget(),
          _toZeroWidget(),
        ],
      ),
    );
  }

  Widget _freeBoxWidget() {
    return FreeBox(
      boxWidth: double.maxFinite,
      boxHeight: double.maxFinite,
      eventWidth: double.maxFinite,
      eventHeight: double.maxFinite,
      backgroundColor: Colors.green,
      freeBoxController: _freeBoxController,
      child: FragmentPool(freeBoxController: _freeBoxController),
    );
  }

  /// 将镜头移至Zero的按钮
  Widget _toZeroWidget() {
    return Positioned(
      bottom: 50,
      left: 0,
      child: FlatButton(
        onPressed: () {
          _freeBoxController.startZeroSliding();
        },
        child: Icon(Icons.adjust),
      ),
    );
  }
}
