import 'package:flutter/material.dart';
import 'package:jysp/Database/Models/MBase.dart';
import 'package:jysp/MVC/Request/Sqlite/RSqliteCurd.dart';
import 'package:jysp/MVC/Views/HomePage/SmallPage/SmallRoute.dart';
import 'package:jysp/Tools/TDebug.dart';

class NodeLongPressMenu extends SmallRoute<void> {
  NodeLongPressMenu({required this.baseModel});
  final MBase baseModel;

  @override
  Color get backgroundColor => Colors.transparent;

  @override
  double get backgroundOpacity => 1.0;

  @override
  bool get isUpPop => true;

  @override
  bool get isBodyCenter => true;

  @override
  void init() {}

  @override
  void rebuild() {}

  @override
  List<Positioned> body() {
    return <Positioned>[
      Positioned(
        child: Container(
          color: Colors.white,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              TextButton(
                child: const Text('删除节点'),
                onPressed: () async {
                  await RSqliteCurd.byModel(baseModel).toDeleteRow(connectTransaction: null);
                  Navigator.pop(context!);
                },
              ),
              TextButton(
                child: const Text('其他1'),
                onPressed: () {},
              ),
              TextButton(
                child: const Text('其他2'),
                onPressed: () {},
              ),
            ],
          ),
        ),
      ),
    ];
  }
}
