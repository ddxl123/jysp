import 'package:flutter/material.dart';
import 'package:jysp/MVC/Views/HomePage/FragmentPool/FragmentPoolCommon/FreeBoxCommon.dart';
import 'package:jysp/MVC/Views/HomePage/FragmentPool/FragmentPools/MemoryPool/MemoryPoolNodes.dart';

class MemoryPoolFreeBox extends StatefulWidget {
  @override
  _MemoryPoolFreeBoxState createState() => _MemoryPoolFreeBoxState();
}

class _MemoryPoolFreeBoxState extends State<MemoryPoolFreeBox> {
  @override
  Widget build(BuildContext context) {
    return FreeBoxCommon(
      poolNodesCommon: MemoryPoolNodes(),
      onLongPressStart: (ScaleStartDetails details) {},
    );
  }
}
