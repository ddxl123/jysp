import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:jysp/Tools/Helper.dart';
import 'package:jysp/Tools/SheetPage/SheetLoadArea.dart';
import 'package:jysp/Tools/SheetPage/SheetPageController.dart';
import 'package:jysp/Tools/TDebug.dart';

/// [T]：[bodyData] 的元素类型
///
/// [M]：标记类型
abstract class SheetPage<T, M> extends OverlayRoute<void> {
  ///

  SheetPage() {
    sheetPageController.sheetRoute = this;
  }

  final SheetPageController<T, M> sheetPageController = SheetPageController<T, M>();

  /// [bodyDataFuture]：内部滑动的数据数组。每次触发加载区都会触发该异步，并自动 setState。
  ///   - [bodyData]：可改变该数组元素（不能改变地址）来改变 bodyData。
  Future<BodyDataFutureResult> bodyDataFuture(List<T> bodyData, Mark<M> mark);

  /// [header]：返回值必须是一个 sliver
  Widget header();

  /// [body]：返回值必须是一个 sliver
  Widget body();

  @override
  Iterable<OverlayEntry> createOverlayEntries() {
    return <OverlayEntry>[
      OverlayEntry(
        maintainState: true,
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
    return Sheet<T, M>(sheetPage: this);
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
    dLog(() => 'dispose');
    super.dispose();
  }

  ///
}

///
///
///
///
///
class Sheet<T, M> extends StatefulWidget {
  const Sheet({required this.sheetPage});

  final SheetPage<T, M> sheetPage;

  @override
  _SheetState<T, M> createState() => _SheetState<T, M>();
}

class _SheetState<T, M> extends State<Sheet<T, M>> with SingleTickerProviderStateMixin {
  @override
  void initState() {
    super.initState();

    dLog(() => 'init');
    // 为了绑定返回键
    widget.sheetPage.sheetPageController.sheetContext = context;

    // 绑定该 [Sheet] Widget 的 [setState]
    widget.sheetPage.sheetPageController.sheetSetState ??= putSetState(setState);

    widget.sheetPage.sheetPageController.animationController = AnimationController(duration: const Duration(milliseconds: 300), vsync: this);

    // 设置整个 sheet 的高度，并关联控制器
    widget.sheetPage.sheetPageController.animation = Tween<double>(begin: 0.0, end: widget.sheetPage.sheetPageController.maxHeight).animate(
      CurvedAnimation(parent: widget.sheetPage.sheetPageController.animationController, curve: Curves.linear),
    );

    // 初始化上升
    widget.sheetPage.sheetPageController.animationController.animateTo(widget.sheetPage.sheetPageController.initHeightRatio);

    widget.sheetPage.sheetPageController.animationControllerAddListener(widget.sheetPage.bodyDataFuture);
    widget.sheetPage.sheetPageController.scrollControllerAddListener(widget.sheetPage.bodyDataFuture);
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 0,
      height: widget.sheetPage.sheetPageController.animation.value,
      width: MediaQueryData.fromWindow(window).size.width,
      child: Listener(
        onPointerDown: widget.sheetPage.sheetPageController.onPointerDown,
        onPointerMove: widget.sheetPage.sheetPageController.onPointerMove,
        onPointerUp: widget.sheetPage.sheetPageController.onPointerUp,

        //
        child: Material(
          type: MaterialType.transparency, // 使得圆角处透明显示
          child: Opacity(
            opacity: widget.sheetPage.sheetPageController.sheetOpacity,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(widget.sheetPage.sheetPageController.circular), // 圆角
              child: CustomScrollView(
                physics: const BouncingScrollPhysics(),
                controller: widget.sheetPage.sheetPageController.scrollController,
                slivers: <Widget>[
                  headerStateful(),
                  bodyStateful(),
                  loadArea(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  /// [header] 位置的 widget
  Widget headerStateful() {
    return StatefulBuilder(
      builder: (_, SetState rebuild) {
        widget.sheetPage.sheetPageController.headerSetState ??= putSetState(rebuild);
        return widget.sheetPage.header();
      },
    );
  }

  /// [body] 位置的 widget
  Widget bodyStateful() {
    return StatefulBuilder(
      builder: (_, SetState rebuild) {
        widget.sheetPage.sheetPageController.bodySetState ??= putSetState(rebuild);
        return widget.sheetPage.body();
      },
    );
  }

  /// [loadArea] 位置的 widget
  Widget loadArea() {
    return StatefulBuilder(
      builder: (_, SetState rebuild) {
        widget.sheetPage.sheetPageController.loadAreaSetState ??= putSetState(rebuild);
        return SheetLoadArea<T, M>(sheetPageController: widget.sheetPage.sheetPageController);
      },
    );
  }
}
