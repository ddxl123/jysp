import 'package:flutter/material.dart';
import 'package:jysp/FragmentPool/Nodes/BaseNodes/MainSingleNodeData.dart';

abstract class BaseNode extends StatefulWidget {
  BaseNode(this.mainSingleNodeData);
  final MainSingleNodeData mainSingleNodeData;
}
