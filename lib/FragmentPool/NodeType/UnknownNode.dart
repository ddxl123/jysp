import 'package:flutter/material.dart';

class UnknownNode extends StatefulWidget {
  @override
  _UnknownNodeState createState() => _UnknownNodeState();
}

class _UnknownNodeState extends State<UnknownNode> {
  @override
  Widget build(BuildContext context) {
    return TextButton(child: Text("未知类型node"), onPressed: () {});
  }
}
