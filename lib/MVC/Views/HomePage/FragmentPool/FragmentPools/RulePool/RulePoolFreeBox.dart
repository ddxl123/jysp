import 'package:flutter/material.dart';
import 'package:jysp/MVC/Views/HomePage/FragmentPool/FragmentPoolCommon/FreeBoxCommon.dart';
import 'package:jysp/MVC/Views/HomePage/FragmentPool/FragmentPools/RulePool/RulePoolNodes.dart';

class RulePoolFreeBox extends StatefulWidget {
  @override
  _RulePoolFreeBoxState createState() => _RulePoolFreeBoxState();
}

class _RulePoolFreeBoxState extends State<RulePoolFreeBox> {
  @override
  Widget build(BuildContext context) {
    return FreeBoxCommon(
      poolNodesCommon: RulePoolNodes(),
      onLongPressStart: (ScaleStartDetails details) {},
    );
  }
}
