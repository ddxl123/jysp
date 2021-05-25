import 'package:flutter/material.dart';
import 'package:jysp/MVC/Views/HomePage/FragmentPool/FragmentPoolCommon/FreeBoxCommon.dart';
import 'package:jysp/MVC/Views/HomePage/FragmentPool/FragmentPools/CompletePool/CompletePoolNodes.dart';

class CompletePoolFreeBox extends StatefulWidget {
  @override
  _CompletePoolFreeBoxState createState() => _CompletePoolFreeBoxState();
}

class _CompletePoolFreeBoxState extends State<CompletePoolFreeBox> {
  @override
  Widget build(BuildContext context) {
    return FreeBoxCommon(
      poolNodesCommon: CompletePoolNodes(),
      onLongPressStart: (ScaleStartDetails details) {},
    );
  }
}
