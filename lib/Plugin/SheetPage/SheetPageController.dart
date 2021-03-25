import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:jysp/Plugin/SheetPage/SheetLoadAreaController.dart';
import 'package:jysp/Plugin/SheetPage/SheetLoadingArea.dart';
import 'package:jysp/Tools/TDebug.dart';

/// 滚动、触摸方向枚举
enum Direction { idle, up, down }

/// 数据获取结果枚举
enum BodyDataFutureResult { success, fail }

/// [header]：header 位置的 widget
///
/// [body]：body 位置的 widget
///
/// [loadArea]：loadArea 位置的 widget
typedef Slivers = List<Widget> Function({
  required SheetPageController sheetPageController,
  required Widget Function(Widget content) header,
  required Widget Function(Widget content) body,
  required Widget Function() loadArea,
});

typedef BodyDataFuture = Future<BodyDataFutureResult> Function(List<Map> bodyData);

/// 控制器
class SheetPageController extends ChangeNotifier {
  ///

  /// 内部滑动的 Widget 数据回调
  late final Slivers slivers;

  /// 内部滑动的数据数组回调
  late final BodyDataFuture bodyDataFuture;

  /// 内部滑动的数据数组
  final List<Map> bodyData = [
    {},
    {},
    {},
    {},
    {},
    {},
    {},
    {},
    {},
    {},
  ];

  /// 当前 [sheetRoute]。
  late final Route sheetRoute;

  /// [sheet] 中的 [context]。
  late final BuildContext sheetContext;

  /// [sheet] 中的 [setState]。直接 sheetSetState() 即可。
  late final Function(void Function() fn) sheetSetState;

  /// [header] 中的 [setState]。直接调用 headerSetState() 即可。
  Function(void Function() fn) headerSetState = (_) {};

  /// [body] 中的 [setState]。直接调用 bodySetState() 即可。
  Function(void Function() fn) bodySetState = (_) {};

  /// [loadArea] 中的 [setState]。直接调用 loadAreaSetState() 即可。
  Function(void Function() fn) loadAreaSetState = (_) {};

  late final Animation<double> animation;
  late final AnimationController animationController;

  /// 内部滑动控制器
  final ScrollController scrollController = ScrollController();

  /// 加载区控制器
  final SheetLoadAreaController sheetLoadAreaController = SheetLoadAreaController();

  /// 最大高度：屏幕高度-下拉栏高度。
  final double maxHeight = MediaQueryData.fromWindow(window).size.height - MediaQueryData.fromWindow(window).padding.top;

  /// 初始化高度比。范围：0 ~ 1，映射于 0 ~ [maxHeight]。
  final double initHeightRatio = 0.4;

  /// 反弹距离比。
  final double reboundRatio = 3 / 4;

  /// 整个 sheet 的透明度。范围：0 ~ 1，0 为全透明，1为不透明。
  double sheetOpacity = 1;

  /// 触摸方向。
  Direction touchDirection = Direction.idle;

  /// 滚动方向。
  Direction scrollDirection = Direction.idle;

  /// route 的圆角半径
  final double circular = 10.0;

  /// 是否将被移除，防止 [removeRouteWithAnimation] 被同时触发多次
  bool _isWillRemoveOnce = false;

  /// 是否正处于获取数据状态，防止 [dataLoad] 被同时触发多次
  bool _isDataLoading = false;

  /// [header] 位置的 widget
  Widget header(Widget content) {
    return StatefulBuilder(
      builder: (_, rebuild) {
        if (this.headerSetState != rebuild) {
          this.headerSetState = rebuild;
        }
        return content;
      },
    );
  }

  /// [body] 位置的 widget
  Widget body(Widget content) {
    return StatefulBuilder(
      builder: (_, rebuild) {
        if (this.bodySetState != rebuild) {
          this.bodySetState = rebuild;
        }
        return content;
      },
    );
  }

  /// [loadArea] 位置的 widget
  Widget loadArea() {
    return StatefulBuilder(
      builder: (_, rebuild) {
        if (this.loadAreaSetState != rebuild) {
          this.loadAreaSetState = rebuild;
        }
        return SheetLoadArea(sheetPageController: this);
      },
    );
  }

  /// 移除当前 route, 同时附带 animation
  void removeRouteWithAnimation() {
    if (!this._isWillRemoveOnce) {
      this._isWillRemoveOnce = true;

      this.animationController.animateTo(0).whenCompleteOrCancel(() {
        /// [removeRoute(currentRoute)] 后,会调用 [dispose] ,以及当中的 [controller.dispose()] [removeListener()]
        /// 不能使用 [pop] ,因为当 [sheet] 已被打开时，再打开新的 [sheet] 时， [pop] 的话会把新打开的 [sheet] [pop] 了,而并不会把旧 [sheet] 关闭
        Navigator.of(this.sheetContext).removeRoute(this.sheetRoute);
        dLog(() => "removeRouteWithAnimation success");
      });
    }
  }

  void onPointerDown(PointerDownEvent event) {
    if (this._isWillRemoveOnce || this.animationController.isAnimating) {
      return;
    }
  }

  void onPointerMove(PointerMoveEvent event) {
    if (this._isWillRemoveOnce || this.animationController.isAnimating) {
      return;
    }

    // 监听触摸方向，给 [_onPointerUp] 使用。如果 [touchDirection>0.0] 则正在向上滚动,如果 [touchDirection<0.0] 则正在向下滚动。
    this.touchDirection = event.delta.dy > 0.0 ? Direction.down : (event.delta.dy < 0.0 ? Direction.up : Direction.idle);

    // 1、未满屏时，内部不滑动，外部滑动。
    if (this.animation.value < this.maxHeight) {
      this.animationController.value -= event.delta.dy / this.maxHeight;
      this.scrollController.jumpTo(0);
    }

    // 2、满屏时，内部滑动，外部不滑动。
    else if (this.animation.value >= this.maxHeight) {
      // 当 [offset <= 0.0] 时，可向下 [touch_move] ，回到 [步骤1] 。
      if (this.scrollController.offset <= 0.0) {
        this.animationController.value -= event.delta.dy / this.maxHeight;
      }
    }

    // 已经在 [addListener] 中 [setState] 了。
    // 不在这里进行 [setState] 的原因是惯性滑动需要 [addListener] ，若放到这里会同时触发多个 [setState]
  }

  void onPointerUp(PointerUpEvent event) {
    if (this._isWillRemoveOnce || this.animationController.isAnimating) {
      return;
    }

    // (-∞ , _reboundRatio) 范围：
    if (this.animationController.value < this.initHeightRatio * this.reboundRatio) {
      if (this.touchDirection == Direction.up) {
        this.animationController.animateTo(this.initHeightRatio, curve: Curves.easeInOutCirc);
      } else {
        this.removeRouteWithAnimation();
      }
    }

    // [_reboundRatio , _initHeightRatio) 范围：
    if (this.animationController.value >= this.initHeightRatio * this.reboundRatio && this.animationController.value < this.initHeightRatio) {
      this.animationController.animateTo(this.initHeightRatio, duration: Duration(milliseconds: 100), curve: Curves.easeInOutCirc);
    }

    // (_initHeightRatio , 1) 范围：
    if (this.animationController.value > this.initHeightRatio && this.animationController.value != 1) {
      if (this.touchDirection == Direction.up) {
        this.animationController.animateTo(1, duration: Duration(milliseconds: 100), curve: Curves.easeInOutCirc);
      } else {
        this.animationController.animateTo(this.initHeightRatio, curve: Curves.easeInOutCirc);
      }
    }
  }

  void animationControllerAddListener() {
    // 上一次 animationController.value。范围：0 ~ 1。
    double lastAnimationControllerValue = 0.0;

    this.animationController.addListener(() {
      //
      // 当前滚动方向。非手势滑动方向。
      if (this.animationController.value > lastAnimationControllerValue) {
        this.scrollDirection = Direction.up;
      } else if (this.animationController.value < lastAnimationControllerValue) {
        this.scrollDirection = Direction.down;
      } else {
        this.scrollDirection = Direction.idle;
      }
      lastAnimationControllerValue = this.animationController.value;

      //
      // 低于 initHeightRatio 时，往下滑动透明度变化
      if (this.animationController.value <= this.initHeightRatio) {
        this.sheetOpacity = this.animationController.value * (1 / this.initHeightRatio);
      }

      //
      // 处在 [LoadingArea] 且向上滚动时，会触发 loading 操作
      if (this.animation.value >= this.scrollController.position.maxScrollExtent && this.scrollDirection == Direction.up) {
        dataLoad();
      }

      this.sheetSetState(() {});
    });
  }

  void scrollControllerAddListener() {
    this.scrollController.addListener(() {
      //
      // 当前滚动方向。非手势滑动方向。
      if (this.scrollController.position.userScrollDirection == ScrollDirection.forward) {
        this.scrollDirection = Direction.down;
      } else if (this.scrollController.position.userScrollDirection == ScrollDirection.reverse) {
        this.scrollDirection = Direction.up;
      } else {
        this.scrollDirection = Direction.idle;
      }

      //
      // 处在 [LoadingArea] 且向上滚动时，会触发 loading 操作
      if (this.maxHeight + this.scrollController.position.pixels >= this.scrollController.position.maxScrollExtent && this.scrollDirection == Direction.up) {
        dataLoad();
      }
    });
  }

  /// 异步加载数据
  void dataLoad() async {
    if (_isDataLoading) {
      return;
    }
    _isDataLoading = true;

    dLog(() => "loading...");

    // 处于正在加载中
    this.loadAreaSetState(() {
      this.sheetLoadAreaController.sheetLoadAreaStatus = SheetLoadAreaStatus.loading;
    });

    BodyDataFutureResult bodyDataFutureResult = await this.bodyDataFuture(this.bodyData);

    switch (bodyDataFutureResult) {
      case BodyDataFutureResult.success:
        this.sheetSetState(() {});
        this.loadAreaSetState(() {
          this.sheetLoadAreaController.sheetLoadAreaStatus = SheetLoadAreaStatus.noMore;
        });
        break;
      case BodyDataFutureResult.fail:
        this.loadAreaSetState(() {
          this.sheetLoadAreaController.sheetLoadAreaStatus = SheetLoadAreaStatus.fail;
        });
        break;
      default:
        throw "BodyDataFutureResult err";
    }

    _isDataLoading = false;
  }

  @override
  void dispose() {
    animationController.dispose();
    scrollController.dispose();
    super.dispose();
  }

  ///
}
