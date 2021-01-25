import 'package:flutter/material.dart';

class RebuildHandler {
  /// 处理码
  int handleCode = 0;
  Function() rebuild = () {};
  Map<dynamic, dynamic> state = {};

  void rebuildHandle(int handleCode) {
    this.handleCode = handleCode;
    rebuild();
  }

  void reset(bool isRebuild) {
    handleCode = 0;
    state.clear();
    if (isRebuild) {
      rebuild();
    }
  }
}

class RebuildHandleWidget extends StatefulWidget {
  RebuildHandleWidget({@required this.rebuildHandler, @required this.builder});
  final RebuildHandler rebuildHandler;
  final Widget Function(RebuildHandler) builder;
  @override
  _RebuildHandleWidgetState createState() => _RebuildHandleWidgetState();
}

class _RebuildHandleWidgetState extends State<RebuildHandleWidget> {
  @override
  void initState() {
    super.initState();
    widget.rebuildHandler.rebuild = () {
      setState(() {});
    };
  }

  @override
  Widget build(BuildContext context) {
    return widget.builder(widget.rebuildHandler);
  }
}
