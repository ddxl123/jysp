import 'package:flutter/material.dart';
import 'package:jysp/mvc/controllers/HomePageController.dart';
import 'package:jysp/tools/RoundedBox..dart';
import 'package:jysp/tools/TDebug.dart';
import 'package:jysp/tools/toast/ShowToast.dart';
import 'package:jysp/tools/toast/ToastRoute.dart';
import 'package:provider/provider.dart';

class FragmentPoolChoiceRoute extends ToastRoute {
  FragmentPoolChoiceRoute(BuildContext fatherContext) : super(fatherContext);

  @override
  Color get backgroundColor => Colors.white;

  @override
  double get backgroundOpacity => 0.0;

  @override
  List<Positioned> body() {
    return <Positioned>[
      _toButtonArea(),
    ];
  }

  Positioned _toButtonArea() {
    return Positioned(
      bottom: MediaQuery.of(context).size.height - fatherWidgetRect.top,
      left: 0,
      right: 0,
      child: RoundedBox(
        children: <Widget>[
          _toButton(toPoolType: PoolType.pendingPool),
          _toButton(toPoolType: PoolType.memoryPool),
          _toButton(toPoolType: PoolType.completePool),
          _toButton(toPoolType: PoolType.rulePool),
        ],
      ),
    );
  }

  Widget _toButton({required PoolType toPoolType}) {
    return TextButton(
      style: TextButton.styleFrom(primary: Colors.red, padding: const EdgeInsets.fromLTRB(20, 0, 20, 0)),
      child: Text(toPoolType.text),
      onPressed: () {
        Navigator.pop<PopResult>(context, PopResult(popResultSelect: PopResultSelect.one, value: toPoolType));
      },
    );
  }

  @override
  void init() {}

  @override
  void rebuild() {}

  @override
  Future<Toast<bool>> whenPop(PopResult? popResult) async {
    try {
      if (popResult == null || popResult.popResultSelect == PopResultSelect.clickBackground) {
        return showToast<bool>(text: '未选择', returnValue: true);
      }
      //
      else if (popResult.popResultSelect == PopResultSelect.one) {
        if (popResult.value == null) {
          throw 'result value is null';
        }
        final ToPoolResult toPoolResult = await fatherContext.read<HomePageController>().toPool(toPoolType: popResult.value! as PoolType);
        if (toPoolResult == ToPoolResult.success) {
          return showToast<bool>(text: 'to pool success', returnValue: true);
        } else if (toPoolResult == ToPoolResult.fail) {
          return showToast<bool>(text: 'to pool fail', returnValue: false);
        } else {
          throw 'unknown toPoolResult: $toPoolResult';
        }
      }
      //
      else {
        throw 'result err: ${popResult.popResultSelect}';
      }
    } catch (e, r) {
      dLog(() => e.toString() + '---' + r.toString());
      return showToast(text: 'result err', returnValue: false);
    }
  }
}
