import 'package:flutter/material.dart';
import 'package:jysp/FragmentPool/FragmentPool.dart';

abstract class BaseNode extends StatefulWidget {
  BaseNode(
    this.currentIndex,
    this.thisRouteName,
    this.nodeLayoutMap,
  );
  final int currentIndex;
  final String thisRouteName;
  final Map nodeLayoutMap;
}
