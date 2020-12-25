import 'package:flutter/material.dart';
import 'package:jysp/FragmentPool/FragmentPoolController.dart';

abstract class BaseNode extends StatefulWidget {
  BaseNode(
    this.currentIndex,
    this.thisRouteName,
    this.fragmentPoolController,
  );
  final int currentIndex;
  final String thisRouteName;
  final FragmentPoolController fragmentPoolController;
}
