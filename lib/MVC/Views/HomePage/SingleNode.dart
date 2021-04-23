import 'dart:async';

import 'package:flutter/material.dart';
import 'package:jysp/G/GNavigatorPush.dart';
import 'package:jysp/Tools/FreeBox/FreeBoxController.dart';
import 'package:jysp/Tools/TDebug.dart';
import 'package:provider/provider.dart';

class SingleNode extends StatefulWidget {
  const SingleNode({required this.name, required this.position});
  final String name;
  final String position;

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
      left: context.read<FreeBoxController>().leftTopOffsetFilling.dx + _left + _onLongPressMoveUpdateOffset.dx,
      top: context.read<FreeBoxController>().leftTopOffsetFilling.dy + _top + _onLongPressMoveUpdateOffset.dy,
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
          context.read<FreeBoxController>().disableTouch(false);
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
          context.read<FreeBoxController>().disableTouch(false);
        },
        child: _body(),
      ),
    );
  }

  void _longPressStart() {
    dLog(() => '_longPressStart');
    context.read<FreeBoxController>().disableTouch(true);
    GNavigatorPush.pushNodeLongPressMenu(context: context);
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
  //     left: context.read<FreeBoxController>().leftTopOffsetFilling.dx + left + _onLongPressMoveUpdateOffset.dx,
  //     top: context.read<FreeBoxController>().leftTopOffsetFilling.dy + top + _onLongPressMoveUpdateOffset.dy,
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
