import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:jysp/FragmentPool/Nodes/BaseNodes/MainSingleNodeData.dart';
import 'package:jysp/FragmentPool/Nodes/ToolNodes/FreeBox.dart';
import 'package:jysp/Tools/CustomButton.dart';

class ShowNodeSheet extends StatefulWidget {
  ShowNodeSheet({
    @required this.relyContext,
    @required this.mainSingleNodeData,
    @required this.overlayEntry,
    this.sliver1Builder,
    this.sliver2Builder,
    this.sliver3Builder,
    this.sliver4Builder,
  });
  final BuildContext relyContext;
  final MainSingleNodeData mainSingleNodeData;
  final OverlayEntry overlayEntry;
  final Widget Function(BuildContext) sliver1Builder;
  final Widget Function(BuildContext) sliver2Builder;
  final Widget Function(BuildContext) sliver3Builder;
  final Widget Function(BuildContext) sliver4Builder;

  @override
  _ShowNodeSheetState createState() => _ShowNodeSheetState();
}

class _ShowNodeSheetState extends State<ShowNodeSheet> with SingleTickerProviderStateMixin {
  /// 成员

  /// 保证唯一性
  static _ShowNodeSheetState _lastShowNodeSheetState;

  /// 初始高度占满屏幕
  double _initHeight = MediaQueryData.fromWindow(window).size.height;

  /// 圆角半径
  double _circularRadius = 35.0;

  /// 内部滑动控制器
  ScrollController _scrollController = ScrollController();

  /// 是否达到 [加载区]
  bool _isEnterLoadingArea = false;

  /// 动画
  Animation _animation;
  AnimationController _animationController;

  /// 初始播放到一半时停止的单次事件
  bool _isOnceHalfDone = false;

  /// 惯性滑动，防止之后 [>=0.5] 并有另外动画时被持续 [stop()]，
  double _lastDelta = 0.0;

  /// 是否将被移除
  bool _isWillRemoveOnce = false;

  /// 是否把 [Mapping] 隐藏
  bool _isOffstageMapping = false;
  Function(Function()) _setStateMappingWidget;

  /// 监听返回键
  ModalRoute<dynamic> _modalRoute;

  @override
  void initState() {
    super.initState();

    /// 保证唯一性
    _lastShowNodeSheetState?._remove();
    _lastShowNodeSheetState = this;

    _animationController = AnimationController(vsync: this, duration: Duration(milliseconds: 300));

    _animation = CurvedAnimation(parent: _animationController, curve: Curves.linear);

    /// 当手指滑动时，最大限度是 [end],因此不能设置成 [_initHeight/2] ，而需设置为 [_initHeight]，且应触发 [once] 单次事件来监听当动画播放到 [_initHeight/2] 时另其 [stop()];
    _animation = Tween(begin: 0.0, end: _initHeight).animate(_animation);

    _animationController.forward();

    _animationController.addListener(() {
      /// 监听初始播放到一半时停止
      if (!_isOnceHalfDone && _animationController.value >= 0.5) {
        _isOnceHalfDone = true;
        _animationController.stop();
      }

      /// 下滑到一定范围内自动 [remove]
      if (_lastDelta > 0 && _animationController.value <= (_circularRadius / _initHeight) * 2) {
        _remove();
      }
    });

    /// 点击 [FreeBox] 区域后触发 [remove]
    widget.mainSingleNodeData.freeBoxController.addListener(() {
      if (widget.mainSingleNodeData.freeBoxController.freeBoxStatus == FreeBoxStatus.onScaleStart) {
        _remove();
      }
    });

    /// 是否达到加载区监听
    _scrollController.addListener(() {
      if (_scrollController.position.pixels >= (_scrollController.position.maxScrollExtent - MediaQueryData.fromWindow(window).size.height)) {
        _isEnterLoadingArea = true;
      } else {
        _isEnterLoadingArea = false;
      }
    });
  }

  /// 当 [_modalRoute] 关联的 [relyContext] 发生变化时会调用 [didChangeDependencies] , [initState] 时也会被调用
  /// 因为 [addScopedWillPopCallback] 会把 [willPopCallback对象] 添加到 [List] 中,因此需要赋予同一个 [willPopCallback对象]
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _modalRoute?.removeScopedWillPopCallback(willPopCallback);
    _modalRoute = ModalRoute.of(widget.relyContext);
    _modalRoute?.addScopedWillPopCallback(willPopCallback);
  }

  /// 当第一次点击返回时,调用 [_remove()] ,而调用 [_remove()] 则会调用 [this.dispose()]
  /// 即第一次点击返回时, [sheet] 会被下降并移除,移除后第二次点击返回时,会返回到上一个 [route]
  Future<bool> willPopCallback() {
    _remove();
    return Future.value(false);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _animationController.dispose();

    _modalRoute?.removeScopedWillPopCallback(willPopCallback);
    _modalRoute = null;

    super.dispose();
    print("dispose");
  }

  @override
  Widget build(BuildContext context) {
    /// 使用 [AnimatedBuilder] 可以让他维持在屏幕空间范围内
    return AnimatedBuilder(
      animation: _animation,
      builder: (_, animatedBuilderChild) {
        return Positioned(
          bottom: 0,
          height: _animation.value,
          width: MediaQueryData.fromWindow(window).size.width,
          child: Listener(
            onPointerDown: _onPointerDown,
            onPointerMove: _onPointerMove,
            onPointerUp: _onPointerUp,

            ///如果不把 [child] 提出去会特别卡
            child: animatedBuilderChild,
          ),
        );
      },
      child: _contentChild(),
    );
  }

  void _remove() {
    /// 禁止触发 [_onPointerXXX] 事件,并防止被多次触发 [remove]
    if (!_isWillRemoveOnce) {
      _isWillRemoveOnce = true;

      /// 这里不能把 [Curves.easeInQuart] 放到 [init] 中,需求是从慢到非常快，而放 [init] 里曲线是会是反向的先快后慢。
      _animationController.animateTo(0, duration: Duration(milliseconds: 300), curve: Curves.easeInQuart).whenCompleteOrCancel(() {
        /// [remove] 后,会调用 [dispose] ,以及当中的 [controller.dispose()]
        widget.overlayEntry.remove();
      });
    }
  }

  /// 事件
  void _onPointerDown(event) {
    if (_isWillRemoveOnce) {
      return;
    }

    /// 按下时所有的动画停止
    _animationController.stop();
  }

  void _onPointerMove(event) {
    if (_isWillRemoveOnce) {
      return;
    }

    /// 1、当 [!=1.0] 时，意味着未满屏，即 [jumpTo(0)]
    /// 2、当 [==1.0] 时，意味着满屏，当 [offset==0.0] 时，即向下 [touch_move] 时，回到 [1、] ，当向上 [touch_move] 时，正常滑动。
    /// [/ _initHeight] 是为了映射为 [0.0-1.0]
    if (_animationController.value != 1.0) {
      _animationController.value -= event.delta.dy / _initHeight;
      _scrollController.jumpTo(0);
    } else {
      if (_scrollController.offset == 0.0) {
        _animationController.value -= event.delta.dy / _initHeight;
      }
    }

    /// 惯性动画
    _lastDelta = event.delta.dy;
  }

  void _onPointerUp(event) {
    if (_isWillRemoveOnce) {
      return;
    }

    /// 同理 [onPointerMove]
    /// 这里 [animateTo] 值是 [0.0-1.0]
    if (_animationController.value != 1.0) {
      _animationController.animateTo(
        _animationController.value - (_lastDelta / _initHeight) * 20,
        curve: Curves.easeOutQuart,
        duration: Duration(milliseconds: 1000),
      );
    } else {
      if (_scrollController.offset == 0.0) {
        _animationController.animateTo(
          _animationController.value - (_lastDelta / _initHeight) * 20,
          curve: Curves.easeOutQuart,
          duration: Duration(milliseconds: 1000),
        );
      }
    }
  }

  /// 具体内容 body
  Widget _contentChild() {
    return Material(
      type: MaterialType.transparency,
      child: Container(
        alignment: Alignment.center,
        child: CustomScrollView(
          controller: _scrollController,
          slivers: [
            _uniformTopWidget(),
            _uniformTopPaddingWidget(),
            _unifromFixedWidget(),
            _uniformMappingWidget(),
            widget.sliver1Builder(this.context),
            widget.sliver2Builder(this.context),
            widget.sliver3Builder(this.context),
            widget.sliver4Builder(this.context),
            _uniformBottomWidget(),
          ],
        ),
      ),
    );
  }

  /// 具体内容

  /// 顶部
  Widget _uniformTopWidget() {
    return SliverToBoxAdapter(
      child: Container(
        margin: EdgeInsets.fromLTRB(0, 10, 0, 0),
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(_circularRadius),
              topRight: Radius.circular(_circularRadius),
            ),
            boxShadow: [
              BoxShadow(blurRadius: 10, offset: Offset(0, -10), spreadRadius: -20),
            ]),
        alignment: Alignment.center,
        height: _circularRadius,
        child:

            /// 横杠
            Container(
          decoration: BoxDecoration(
            color: Colors.black12,
            borderRadius: BorderRadius.all(Radius.circular(50)),
          ),
          alignment: Alignment.center,
          width: 50,
          height: 5,
        ),
      ),
    );
  }

  /// 顶部下拉栏占位
  Widget _uniformTopPaddingWidget() {
    double paddingHeight = 0;
    return StatefulBuilder(
      builder: (_, rebuild) {
        _scrollController.addListener(() {
          paddingHeight = _scrollController.offset;
          if (paddingHeight >= MediaQueryData.fromWindow(window).padding.top) {
            paddingHeight = MediaQueryData.fromWindow(window).padding.top;
          }
          rebuild(() {});
        });
        return SliverPersistentHeader(
          pinned: true,
          delegate: NodePersistentDelegate(
            minHeight: paddingHeight,
            maxHeight: paddingHeight,
            child: Container(color: Colors.pink),
          ),
        );
      },
    );
  }

  /// 标题栏
  Widget _unifromFixedWidget() {
    return StatefulBuilder(
      builder: (_, rebuild) {
        return SliverPersistentHeader(
          pinned: true,
          delegate: NodePersistentDelegate(
            minHeight: 50.0,
            maxHeight: 50.0,
            child: Container(
              color: Colors.pink,
              child: Row(
                children: [
                  Expanded(
                    child: CustomButton(
                      child: Row(
                        children: [
                          SizedBox(width: 5),
                          Icon(Icons.remove_red_eye),
                          SizedBox(width: 5),
                          Expanded(
                            child: Text(
                              "池显样式:  " + widget.mainSingleNodeData.fragmentPoolDataList[widget.mainSingleNodeData.thisIndex]["pool_display_name"].toString(),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                      onPressed: () {
                        _setStateMappingWidget(() {
                          _isOffstageMapping = !_isOffstageMapping;
                        });
                      },
                    ),
                  ),
                  CustomButton(
                    child: Container(
                      padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
                      child: Icon(Icons.more_horiz),
                    ),
                    onPressed: () {},
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  /// [Node] 映射栏
  Widget _uniformMappingWidget() {
    double layoutWidth = widget.mainSingleNodeData.fragmentPoolLayoutDataMap[widget.mainSingleNodeData.thisRouteName]["layout_width"];
    double layoutHeight = widget.mainSingleNodeData.fragmentPoolLayoutDataMap[widget.mainSingleNodeData.thisRouteName]["layout_height"];
    String poolDisplayName = widget.mainSingleNodeData.fragmentPoolDataList[widget.mainSingleNodeData.thisIndex]["pool_display_name"].toString();

    return StatefulBuilder(
      builder: (_, rebuild) {
        _setStateMappingWidget = rebuild;
        if (_isOffstageMapping) {
          return SliverToBoxAdapter();
        }
        if (layoutHeight >= MediaQueryData.fromWindow(window).size.height / 2) {
          /// 不会被固定在顶部
          return SliverToBoxAdapter(
            child:
                // 设置高度
                Container(
              height: layoutHeight + 40,
              child: _uniformMappingMain(layoutWidth, layoutHeight, poolDisplayName),
            ),
          );
        } else {
          /// 会被固定在顶部
          return SliverPersistentHeader(
            //// 加上 [pinned==true] 会有折叠/吸顶效果
            pinned: true, // 滑到顶时会固定
            floating: true, // 到顶的位置在屏幕的下拉栏下方紧贴
            delegate:
                // 设置高度伸缩范围
                NodePersistentDelegate(
              minHeight: 0.0,
              maxHeight: layoutHeight + 40.0,
              child: _uniformMappingMain(layoutWidth, layoutHeight, poolDisplayName),
            ),
          );
        }
      },
    );
  }

  Widget _uniformMappingMain(double layoutWidth, double layoutHeight, String poolDisplayName) {
    return
        //// 横向滚动区后面的背景，因为滚动是 [BouncingScrollPhysics] 的
        Container(
      color: Colors.pink,
      child:
          // 横向滚动区
          ListView(
        physics: BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
        reverse: true,
        scrollDirection: Axis.horizontal,
        children: [
          /// 需要设置最小宽度，因为这样的话才能：当[主体]宽度小于屏宽时，让[主体]居中，不然的话会居右，因为 [reverse==true]
          Container(
            constraints: BoxConstraints(minWidth: MediaQueryData.fromWindow(window).size.width),
            padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
            alignment: Alignment.center,
            child:
                //// 映射 [Node] 主体
                Container(
              alignment: Alignment.center,
              color: Colors.yellow,
              width: layoutWidth,
              height: layoutHeight,
              child: Text(poolDisplayName),
            ),
          ),
        ],
      ),
    );
  }

  /// 底部
  Widget _uniformBottomWidget() {
    return SliverFillRemaining(
      hasScrollBody: true,
      child: Container(
        color: Colors.white,
        child: FlatButton(onPressed: () {}, child: Text("no more")),
      ),
    );
  }
}

///
///
///
///
///
class NodePersistentDelegate extends SliverPersistentHeaderDelegate {
  NodePersistentDelegate({@required this.child, @required this.minHeight, @required this.maxHeight});
  final double minHeight;
  final double maxHeight;
  final Widget child;

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return SizedBox.expand(child: child);
  }

  @override
  double get maxExtent => maxHeight;

  @override
  double get minExtent => minHeight;

  @override
  bool shouldRebuild(NodePersistentDelegate oldDelegate) {
    return maxHeight != oldDelegate.maxHeight || minHeight != oldDelegate.minHeight || child != oldDelegate.child;
  }
}
