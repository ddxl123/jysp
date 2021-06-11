import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:jysp/tools/Helper.dart';
import 'package:jysp/tools/TDebug.dart';
import 'package:jysp/tools/sheet_page/SheetLoadAreaController.dart';

/// 滚动、触摸方向枚举
enum Direction { idle, up, down }

/// 数据获取结果枚举
enum BodyDataFutureResult { success, fail }

class Mark<M> {
  M? value;
}

class SheetPageController<T, M> extends ChangeNotifier {
  ///

  /// 当前 [sheetRoute]。
  late final Route<void> sheetRoute;

  /// [sheet] 中的 [context]。
  late final BuildContext sheetContext;

  /// 整个 [sheet] 中的 [setState]。
  SetState? sheetSetState;

  /// [header] 中的 [setState]。直接调用 headerSetState() 即可。
  SetState? headerSetState;

  /// [body] 中的 [setState]。直接调用 bodySetState() 即可。
  SetState? bodySetState;

  /// [loadArea] 中的 [setState]。直接调用 loadAreaSetState() 即可。
  SetState? loadAreaSetState;

  late final Animation<double> animation;

  late final AnimationController animationController;

  /// 内部滑动控制器
  final ScrollController scrollController = ScrollController();

  /// 加载区控制器
  final SheetLoadAreaController sheetLoadAreaController = SheetLoadAreaController();

  /// 内部滑动的数据数组
  final List<T> bodyData = <T>[];

  /// 异步标记
  final Mark<M> mark = Mark<M>();

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

  /// 移除当前 route, 同时附带 animation
  void removeRouteWithAnimation() {
    if (!_isWillRemoveOnce) {
      _isWillRemoveOnce = true;

      animationController.animateTo(0).whenCompleteOrCancel(() {
        /// [removeRoute(currentRoute)] 后,会调用 [dispose] ,以及当中的 [controller.dispose()] [removeListener()]
        /// 不能使用 [pop] ,因为当 [sheet] 已被打开时，再打开新的 [sheet] 时， [pop] 的话会把新打开的 [sheet] [pop] 了,而并不会把旧 [sheet] 关闭
        Navigator.of(sheetContext).removeRoute(sheetRoute);
        dLog(() => 'removeRouteWithAnimation success');
      });
    }
  }

  void onPointerDown(PointerDownEvent event) {
    if (_isWillRemoveOnce || animationController.isAnimating) {
      return;
    }
  }

  void onPointerMove(PointerMoveEvent event) {
    if (_isWillRemoveOnce || animationController.isAnimating) {
      return;
    }

    // 监听触摸方向，给 [_onPointerUp] 使用。如果 [touchDirection>0.0] 则正在向上滚动,如果 [touchDirection<0.0] 则正在向下滚动。
    touchDirection = event.delta.dy > 0.0 ? Direction.down : (event.delta.dy < 0.0 ? Direction.up : Direction.idle);

    // 1、未满屏时，内部不滑动，外部滑动。
    if (animation.value < maxHeight) {
      animationController.value -= event.delta.dy / maxHeight;
      scrollController.jumpTo(0);
    }

    // 2、满屏时，内部滑动，外部不滑动。
    else if (animation.value >= maxHeight) {
      // 当 [offset <= 0.0] 时，可向下 [touch_move] ，回到 [步骤1] 。
      if (scrollController.offset <= 0.0) {
        animationController.value -= event.delta.dy / maxHeight;
      }
    }

    // 已经在 [addListener] 中 [setState] 了。
    // 不在这里进行 [setState] 的原因是惯性滑动需要 [addListener] ，若放到这里会同时触发多个 [setState]
  }

  void onPointerUp(PointerUpEvent event) {
    if (_isWillRemoveOnce || animationController.isAnimating) {
      return;
    }

    // (-∞ , _reboundRatio) 范围：
    if (animationController.value < initHeightRatio * reboundRatio) {
      if (touchDirection == Direction.up) {
        animationController.animateTo(initHeightRatio, curve: Curves.easeInOutCirc);
      } else {
        removeRouteWithAnimation();
      }
    }

    // [_reboundRatio , _initHeightRatio) 范围：
    if (animationController.value >= initHeightRatio * reboundRatio && animationController.value < initHeightRatio) {
      animationController.animateTo(initHeightRatio, duration: const Duration(milliseconds: 100), curve: Curves.easeInOutCirc);
    }

    // (_initHeightRatio , 1) 范围：
    if (animationController.value > initHeightRatio && animationController.value != 1) {
      if (touchDirection == Direction.up) {
        animationController.animateTo(1, duration: const Duration(milliseconds: 100), curve: Curves.easeInOutCirc);
      } else {
        animationController.animateTo(initHeightRatio, curve: Curves.easeInOutCirc);
      }
    }
  }

  void animationControllerAddListener(Future<BodyDataFutureResult> Function(List<T> bodyData, Mark<M> mark) bodyDataFuture) {
    // 上一次 animationController.value。范围：0 ~ 1。
    double lastAnimationControllerValue = 0.0;

    animationController.addListener(() {
      //
      // 当前滚动方向。非手势滑动方向。
      if (animationController.value > lastAnimationControllerValue) {
        scrollDirection = Direction.up;
      } else if (animationController.value < lastAnimationControllerValue) {
        scrollDirection = Direction.down;
      } else {
        scrollDirection = Direction.idle;
      }
      lastAnimationControllerValue = animationController.value;

      //
      // 低于 initHeightRatio 时，往下滑动透明度变化
      if (animationController.value <= initHeightRatio) {
        sheetOpacity = animationController.value * (1 / initHeightRatio);
      }

      //
      // 处在 [LoadingArea] 且向上滚动时，会触发 loading 操作
      if (animation.value >= scrollController.position.maxScrollExtent && scrollDirection == Direction.up) {
        dataLoad(bodyDataFuture);
      }

      runSetState(sheetSetState!);
    });
  }

  void scrollControllerAddListener(Future<BodyDataFutureResult> Function(List<T> bodyData, Mark<M> mark) bodyDataFuture) {
    scrollController.addListener(() {
      //
      // 当前滚动方向。非手势滑动方向。
      if (scrollController.position.userScrollDirection == ScrollDirection.forward) {
        scrollDirection = Direction.down;
      } else if (scrollController.position.userScrollDirection == ScrollDirection.reverse) {
        scrollDirection = Direction.up;
      } else {
        scrollDirection = Direction.idle;
      }

      //
      // 处在 [LoadingArea] 且向上滚动时，会触发 loading 操作
      if (maxHeight + scrollController.position.pixels >= scrollController.position.maxScrollExtent && scrollDirection == Direction.up) {
        dataLoad(bodyDataFuture);
      }
    });
  }

  /// 异步加载数据
  ///
  /// [T]：元素类型
  Future<void> dataLoad(Future<BodyDataFutureResult> Function(List<T> bodyData, Mark<M> mark) bodyDataFuture) async {
    if (_isDataLoading) {
      return;
    }
    _isDataLoading = true;

    dLog(() => 'loading...');

    // 处于正在加载中
    sheetLoadAreaController.sheetLoadAreaStatus = SheetLoadAreaStatus.loading;
    runSetState(loadAreaSetState!);
    final BodyDataFutureResult bodyDataFutureResult = await bodyDataFuture(bodyData, mark);

    switch (bodyDataFutureResult) {
      case BodyDataFutureResult.success:
        sheetLoadAreaController.sheetLoadAreaStatus = SheetLoadAreaStatus.noMore;
        runSetState(bodySetState!);
        runSetState(loadAreaSetState!);
        break;
      case BodyDataFutureResult.fail:
        sheetLoadAreaController.sheetLoadAreaStatus = SheetLoadAreaStatus.fail;
        runSetState(loadAreaSetState!);
        break;
      default:
        throw 'BodyDataFutureResult err';
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
