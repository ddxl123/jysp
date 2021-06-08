import 'package:flutter/material.dart';
import 'package:jysp/database/merge_models/MMPoolNode.dart';
import 'package:jysp/mvc/controllers/HomePageController.dart';
import 'package:jysp/mvc/controllers/fragment_pool_controller/FragmentPoolController.dart';
import 'package:jysp/mvc/views/home_page/fragment_pool/fragment_pool_common/fragment_pool_toast_route_commons/NodeLongPressedCommon.dart';
import 'package:jysp/tools/CustomButton.dart';
import 'package:jysp/tools/sheet_page/SheetPage.dart';
import 'package:provider/provider.dart';

class PoolNodeCommon extends StatefulWidget {
  /// [baseModel] 当前 model，供调用 base 方法。其他参数 base 可能没有对应方法
  const PoolNodeCommon({
    required this.poolType,
    required this.poolNodeMModel,
    required this.sheetPageBuilder,
  });
  final PoolType poolType;
  final MMPoolNode poolNodeMModel;

  /// 这里不能 [SheetPage<dynamic, dynamic> sheetPageBuilder] 这样，
  /// 因为这样 pop 后 SheetPage 对象并没有被销毁，当重新 push 时，使用的还是该对象，
  /// 因此需要用 [SheetPage<dynamic, dynamic> Function() sheetPageBuilder] 函数的形式，pop 时便都使用的新生成的 SheetPage。
  final SheetPage<dynamic, dynamic> Function() sheetPageBuilder;

  @override
  PoolNodeCommonState createState() => PoolNodeCommonState();
}

class PoolNodeCommonState extends State<PoolNodeCommon> {
  ///

  // Timer? _longPressTimer;
  // bool _isLongPress = false;

  late final FragmentPoolController _thisFragmentPoolController;

  @override
  void initState() {
    super.initState();
    _thisFragmentPoolController = context.read<HomePageController>().getFragmentPoolController(widget.poolType);
  }

  @override
  Widget build(BuildContext context) {
    return _body();
  }

  // Widget _buildWidget() {
  //   return Listener(
  //     onPointerDown: (_) {
  //       if (_.device > 0) {
  //         return;
  //       }

  //       _longPressTimer = Timer(const Duration(milliseconds: 1000), () {
  //         _isLongPress = true;
  //         _longPressStart();
  //       });
  //     },
  //     onPointerMove: (_) {
  //       if (_.device > 0) {
  //         return;
  //       }

  //       _longPressTimer?.cancel();
  //       if (_isLongPress) {
  //         _longPressMove();
  //       }
  //     },
  //     onPointerUp: (_) {
  //       dLog(() => 'up');
  //       if (_.device > 0) {
  //         return;
  //       }

  //       _longPressTimer?.cancel();

  //       if (_isLongPress) {
  //         _isLongPress = false;
  //         _longPressUp();
  //       }
  //       _thisFragmentPoolController.freeBoxController.disableTouch(false);
  //     },
  //     onPointerCancel: (_) {
  //       dLog(() => 'cancel');
  //       if (_.device > 0) {
  //         return;
  //       }

  //       _longPressTimer?.cancel();

  //       if (_isLongPress) {
  //         _isLongPress = false;
  //         _longPressCancel();
  //       }
  //       _thisFragmentPoolController.freeBoxController.disableTouch(false);
  //     },
  //     child: _body(),
  //   );
  // }

  // void _longPressStart() {
  //   dLog(() => '_longPressStart');
  //   _thisFragmentPoolController.freeBoxController.disableTouch(true);
  //   // showToastRoute(context, NodeLongPressMenuRoute(context, poolNodeMModel: widget.poolNodeMModel));
  // }

  // void _longPressMove() {
  //   dLog(() => '_longPressMove');
  // }

  // void _longPressUp() {
  //   dLog(() => '_longPressUp');
  // }

  // void _longPressCancel() {
  //   dLog(() => '_longPressCancel');
  // }

  Widget _body() {
    return CustomButton(
      child: Text(widget.poolNodeMModel.get_name ?? 'unknown'),
      onUp: (PointerUpEvent event) {
        Navigator.push(context, widget.sheetPageBuilder());
      },
      onDown: (PointerDownEvent downEvent) {},
      onLongPressed: (PointerDownEvent downEvent) {
        Navigator.push(context, NodeLongPressedCommon(context, mmPoolNode: widget.poolNodeMModel));
      },
      // style: TextButton.styleFrom(
      //   primary: Colors.black,
      //   onSurface: Colors.orange,
      //   shadowColor: Colors.purple,
      // ),
    );
  }
}
