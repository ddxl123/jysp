import 'dart:async';

import 'package:flutter/material.dart';
import 'package:jysp/Database/Models/MBase.dart';
import 'package:jysp/G/GNavigatorPush.dart';
import 'package:jysp/MVC/Controllers/FragmentPoolController/FragmentPoolController.dart';
import 'package:jysp/MVC/Views/HomePage/ToastRoutes/NodeLongPressMenuRoute.dart';
import 'package:jysp/Tools/TDebug.dart';
import 'package:jysp/Tools/Toast/ShowToast.dart';
import 'package:provider/provider.dart';

class SingleNode extends StatefulWidget {
  /// [baseModel] 当前 model，供调用 base 方法。其他参数 base 可能没有对应方法
  const SingleNode({required this.name, required this.position, required this.baseModel});
  final String name;
  final String position;
  final MBase baseModel;

  @override
  SingleNodeState createState() => SingleNodeState();
}

class SingleNodeState extends State<SingleNode> {
  ///

  final Offset _onLongPressMoveUpdateOffset = Offset.zero;

  double _left = 0;
  double _top = 0;
  Timer? _longPressTimer;
  bool _isLongPress = false;

  @override
  Widget build(BuildContext context) {
    _parsePosition();
    return _buildWidget();
  }

  void _parsePosition() {
    try {
      final List<String> sp = widget.position.split(',');
      _left = double.parse(sp[0]);
      _top = double.parse(sp[1]);
    } catch (e) {
      dLog(() => 'parse position err: ', () => e);
    }
  }

  Widget _buildWidget() {
    return Positioned(
      left: _left + _onLongPressMoveUpdateOffset.dx,
      top: _top + _onLongPressMoveUpdateOffset.dy,
      child: Listener(
        onPointerDown: (_) {
          if (_.device > 0) {
            return;
          }

          _longPressTimer = Timer(const Duration(milliseconds: 1000), () {
            _isLongPress = true;
            _longPressStart();
          });
        },
        onPointerMove: (_) {
          if (_.device > 0) {
            return;
          }

          _longPressTimer?.cancel();
          if (_isLongPress) {
            _longPressMove();
          }
        },
        onPointerUp: (_) {
          dLog(() => 'up');
          if (_.device > 0) {
            return;
          }

          _longPressTimer?.cancel();

          if (_isLongPress) {
            _isLongPress = false;
            _longPressUp();
          }
          context.read<FragmentPoolController>().freeBoxController.disableTouch(false);
        },
        onPointerCancel: (_) {
          dLog(() => 'cancel');
          if (_.device > 0) {
            return;
          }

          _longPressTimer?.cancel();

          if (_isLongPress) {
            _isLongPress = false;
            _longPressCancel();
          }
          context.read<FragmentPoolController>().freeBoxController.disableTouch(false);
        },
        child: _body(),
      ),
    );
  }

  void _longPressStart() {
    dLog(() => '_longPressStart');
    context.read<FragmentPoolController>().freeBoxController.disableTouch(true);
    showToastRoute(context, NodeLongPressMenuRoute(baseModel: widget.baseModel));
  }

  void _longPressMove() {
    dLog(() => '_longPressMove');
  }

  void _longPressUp() {
    dLog(() => '_longPressUp');
  }

  void _longPressCancel() {
    dLog(() => '_longPressCancel');
  }

  // Widget _buildWidget() {
  //   return Positioned(
  //     left:  context.read<FragmentPoolController>().freeBoxController.leftTopOffsetFilling.dx + left + _onLongPressMoveUpdateOffset.dx,
  //     top:  context.read<FragmentPoolController>().freeBoxController.leftTopOffsetFilling.dy + top + _onLongPressMoveUpdateOffset.dy,
  //     child: GestureDetector(
  //       onLongPressStart: (details) {
  //         dLog(() => "onLongPressStart");
  //         _lastOffset = details.globalPosition;
  //       },
  //       onLongPressMoveUpdate: (details) {
  //         _deltaOffset = details.globalPosition - _lastOffset;
  //         _onLongPressMoveUpdateOffset += _deltaOffset;
  //         _lastOffset = details.globalPosition;
  //         setState(() {});
  //       },
  //       onLongPressEnd: (details) {
  //         dLog(() => "onLongPressEnd");
  //       },
  //       child: _body(),
  //     ),
  //   );
  // }

  Widget _body() {
    return TextButton(
      child: Text(widget.name),
      onPressed: () {
        GNavigatorPush.pushSheetPage(context);
      },
      style: TextButton.styleFrom(
        primary: Colors.red,
        onSurface: Colors.orange,
        shadowColor: Colors.purple,
      ),
    );
  }
}
