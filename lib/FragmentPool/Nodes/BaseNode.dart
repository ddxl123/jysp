import 'package:flutter/material.dart';
import 'package:jysp/FragmentPool/Nodes/MainNode.dart';

abstract class BaseNode extends StatefulWidget {
  BaseNode(
    this.mainNode,
    this.mainNodeState,
  );

  final MainNode mainNode;
  final MainNodeState mainNodeState;
}
