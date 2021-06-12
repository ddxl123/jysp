import 'package:flutter/material.dart';
import 'package:jysp/database/models/MBase.dart';
import 'package:jysp/mvc/request/offline/RSqliteCurd.dart';
import 'package:jysp/tools/RoundedBox..dart';
import 'package:jysp/tools/TDebug.dart';
import 'package:jysp/tools/toast/ShowToast.dart';

import 'package:jysp/tools/toast/ToastRoute.dart';

class RenameCommon extends ToastRoute {
  RenameCommon(
    BuildContext fatherContext, {
    required this.oldName,
    required this.model,
    required this.nameKey,
    required this.updatedAtKey,
  }) : super(fatherContext);

  final String oldName;

  final MBase model;

  final String nameKey;

  final String updatedAtKey;

  final TextEditingController _textEditingController = TextEditingController();

  @override
  Color get backgroundColor => Colors.transparent;

  @override
  double get backgroundOpacity => 0;

  @override
  void dispose() {
    _textEditingController.dispose();
    super.dispose();
  }

  @override
  List<Widget> body() {
    return <Positioned>[
      Positioned(
        child: Center(
          child: RoundedBox(
            width: MediaQuery.of(context).size.width * 2 / 3,
            children: <Widget>[
              Row(children: <Widget>[Text('原名称：$oldName')]),
              Row(children: <Widget>[const Text('新名称：'), Expanded(child: Container(child: TextField(controller: _textEditingController)))]),
              Row(
                children: <Widget>[
                  Expanded(
                    child: TextButton(
                      child: const Text('确认'),
                      onPressed: () {
                        Navigator.pop(context, PopResult(popResultSelect: PopResultSelect.two, value: null));
                      },
                    ),
                  ),
                  Expanded(
                    child: TextButton(
                      child: const Text('取消'),
                      onPressed: () {
                        Navigator.pop(context, PopResult(popResultSelect: PopResultSelect.one, value: null));
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    ];
  }

  @override
  Future<Toast<bool>> whenPop(PopResult? popResult) async {
    try {
      if (popResult == null || popResult.popResultSelect == PopResultSelect.clickBackground || popResult.popResultSelect == PopResultSelect.one) {
        return showToast<bool>(text: '已取消', returnValue: true);
      }
      //
      else if (popResult.popResultSelect == PopResultSelect.two) {
        if (_textEditingController.text == '') {
          return showToast<bool>(text: '已取消', returnValue: true);
        } else {
          await RSqliteCurd<MBase>.byModel(model).updateRow(
            updateContent: <String, Object>{nameKey: _textEditingController.text, updatedAtKey: DateTime.now().millisecondsSinceEpoch},
            isReturnNewModel: false,
            transactionMark: null,
          );
          return showToast<bool>(text: '修改成功', returnValue: true);
        }
      }

      //
      else {
        throw 'unknown';
      }
    } catch (e, r) {
      dLog(() => '$e---$r');
      return showToast<bool>(text: 'err', returnValue: false);
    }
  }
}
