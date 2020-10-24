import 'package:flutter/material.dart';
import 'package:jysp/FragmentPool/FragmentPool.dart';

abstract class BaseNode extends StatefulWidget {
  BaseNode(
    this.currentIndex,
    this.thisRouteName,
    this.childCount,
  );
  final int currentIndex;
  final String thisRouteName;
  final int childCount;
}
