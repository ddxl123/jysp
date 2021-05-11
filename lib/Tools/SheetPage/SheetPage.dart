import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:jysp/Tools/SheetPage/SheetPageController.dart';
import 'package:jysp/Tools/TDebug.dart';

class SheetPage extends OverlayRoute<void> {
  ///

  /// [slivers]：内部滑动的 Widget 数据。
  ///
  /// [dataFuture]：内部滑动的数据数组。
  ///
  /// [sliverFillRemaining]：若为 false，则多余部分为透明；若为 false，则多余部分为 [LoadingArea]。
  SheetPage({required Slivers slivers, required BodyDataFuture bodyDataFuture}) {
    sheetPageController.sheetRoute = this;
    sheetPageController.slivers = slivers;
    sheetPageController.bodyDataFuture = bodyDataFuture;
  }

  final SheetPageController sheetPageController = SheetPageController();

  @override
  Iterable<OverlayEntry> createOverlayEntries() {
    return <OverlayEntry>[
      OverlayEntry(
        builder: (_) {
          return Stack(
            children: <Widget>[
              _backgroundHitTest(),
              _sheet(),
            ],
          );
        },
      )
    ];
  }

  Widget _backgroundHitTest() {
    return Positioned(
      top: 0,
      child: Listener(
        behavior: HitTestBehavior.deferToChild,
        onPointerMove: (PointerMoveEvent event) {
          dLog(() => event);
        },
        child: Container(
          color: null,
          height: double.maxFinite,
          width: double.maxFinite,
        ),
      ),
    );
  }

  Widget _sheet() {
    return Sheet(sheetPageController: sheetPageController);
  }

  /// 返回监听:
  /// 当调用 [Navigator.pop] 时，会调用 [didpop] ,该函数中会调用 [NavigatorState] 的 [finalizeRoute] 函数来释放资源(如等待动画完成)。然后再调用route的 [dispose] 函数。
  /// 当调用 [Navigator.removeRoute] 时,会立即调用route的 [dispose] 。
  /// 当前路线是：被 [Navigator.pop] 后不进行任何操作，而是调用了 [removePageWithAnimation] 中的 [Navigator.removeRoute] 。
  /// 若在 [_removeAnimation] 中调用 [Navigator.pop] 则会循环的调用 [removePageWithAnimation] ,当然 [removePageWithAnimation] 中有仅执行一次的判断。
  @override
  // ignore: must_call_super
  bool didPop(Object? result) {
    sheetPageController.removeRouteWithAnimation();
    return false;
  }

  @override
  void dispose() {
    sheetPageController.dispose();
    super.dispose();
  }

  ///
}

///
///
///
///
///
class Sheet extends StatefulWidget {
  const Sheet({required this.sheetPageController});

  final SheetPageController sheetPageController;

  @override
  _SheetState createState() => _SheetState();
}

class _SheetState extends State<Sheet> with SingleTickerProviderStateMixin {
  @override
  void initState() {
    super.initState();

    // 为了绑定返回键
    widget.sheetPageController.sheetContext = context;

    // 绑定该 [Sheet] Widget 的 [setState]
    widget.sheetPageController.sheetSetState = setState;

    widget.sheetPageController.animationController = AnimationController(duration: const Duration(milliseconds: 300), vsync: this);

    // 设置整个 sheet 的高度，并关联控制器
    widget.sheetPageController.animation =
        Tween<double>(begin: 0.0, end: widget.sheetPageController.maxHeight).animate(CurvedAnimation(parent: widget.sheetPageController.animationController, curve: Curves.linear));

    // 初始化上升
    widget.sheetPageController.animationController.animateTo(widget.sheetPageController.initHeightRatio);

    widget.sheetPageController.animationControllerAddListener();
    widget.sheetPageController.scrollControllerAddListener();
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 0,
      height: widget.sheetPageController.animation.value,
      width: MediaQueryData.fromWindow(window).size.width,
      child: Listener(
        onPointerDown: widget.sheetPageController.onPointerDown,
        onPointerMove: widget.sheetPageController.onPointerMove,
        onPointerUp: widget.sheetPageController.onPointerUp,

        //
        child: Material(
          type: MaterialType.transparency, // 使得圆角处透明显示
          child: Opacity(
            opacity: widget.sheetPageController.sheetOpacity,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(widget.sheetPageController.circular), // 圆角
              child: CustomScrollView(
                physics: const BouncingScrollPhysics(),
                controller: widget.sheetPageController.scrollController,
                slivers: widget.sheetPageController.slivers(
                  sheetPageController: widget.sheetPageController,
                  header: widget.sheetPageController.header,
                  body: widget.sheetPageController.body,
                  loadArea: widget.sheetPageController.loadArea,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
