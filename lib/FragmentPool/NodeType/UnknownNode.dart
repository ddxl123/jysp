import 'package:flutter/material.dart';

///
///
///
/// 当 node 数量为0时，由于 [setLayout] 处理中有需要获取 [branch="0"] 的操作
/// 对此, 当 node 数量为0时, 由 [指示Node] 充当 [branch="0"]
/// 即, 当 node 数量为0时, [branch="0"] 为 [指示Node] ,
class UnknownNode extends StatefulWidget {
  @override
  _UnknownNodeState createState() => _UnknownNodeState();
}

class _UnknownNodeState extends State<UnknownNode> {
  @override
  Widget build(BuildContext context) {
    return TextButton(child: const Text('未知类型node'), onPressed: () {});
  }
}
