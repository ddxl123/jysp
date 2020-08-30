import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:jysp/Buttons.dart';
import 'package:jysp/FragmentPool/Nodes/MainNode.dart';

class ShowNodeSheet extends StatefulWidget {
  ShowNodeSheet({
    @required this.mainNode,
    @required this.mainNodeState,
    @required this.overlayEntry,
    this.sliver1,
    this.sliver2,
    this.sliver3,
    this.sliver4,
  });
  final MainNode mainNode;
  final MainNodeState mainNodeState;
  final OverlayEntry overlayEntry;
  final Widget sliver1;
  final Widget sliver2;
  final Widget sliver3;
  final Widget sliver4;

  @override
  _ShowNodeSheetState createState() => _ShowNodeSheetState();
}

class _ShowNodeSheetState extends State<ShowNodeSheet> with SingleTickerProviderStateMixin {
  ///
  ///
  ///
  ///
  ///
  /// 成员

  /// 保证唯一性
  static _ShowNodeSheetState _lastShowNodeSheetState;

  /// 初始高度占满屏幕
  double _initHeight = MediaQueryData.fromWindow(window).size.height;

  /// 圆角半径
  double _circularRadius = 35.0;

  /// 内部滑动控制器
  ScrollController _scrollController = ScrollController();

  /// 动画
  Animation _animation;
  AnimationController _animationController;

  /// 初始播放到一半时停止的单次事件
  bool _isOnceHalfDone = false;

  /// 惯性滑动，防止之后 [>=0.5] 并有另外动画时被持续 [stop()]，
  double _lastDelta = 0.0;

  /// 是否将被移除
  bool _isWillRemoveOnce = false;

  ///
  ///
  ///
  ///
  /// 函数

  @override
  void initState() {
    super.initState();

    /// 保证唯一性
    print(_lastShowNodeSheetState == this);
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

      if (_lastDelta > 0 && _animationController.value <= (_circularRadius / _initHeight) * 2) {
        _remove();
      }
    });

    /// 绑定单次事件
    widget.mainNode.freeBoxController.eventBindOnce(
      updateBindOnce: () {
        _remove();
      },
      endBindOnce: () {
        _remove();
      },
    );
  }

  @override
  void dispose() {
    super.dispose();
    _scrollController.dispose();
    _animationController.dispose();
    print("dispose");
  }

  @override
  Widget build(BuildContext context) {
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
    /// 禁止触发 [_onPointerXXX] 事件
    if (!_isWillRemoveOnce) {
      _isWillRemoveOnce = true;

      /// 这里不能把 [Curves.easeInQuart] 放到 [init] 中,需求是从慢到非常快，而放 [init] 里曲线是会是反向的先快后慢。
      _animationController.animateTo(0, duration: Duration(milliseconds: 300), curve: Curves.easeInQuart).whenCompleteOrCancel(() {
        widget.overlayEntry.remove();
      });
    }
  }

  ///
  ///
  ///
  ///
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
    if (_animationController.value != 1.0) {
      _animationController.animateTo(
        _animationController.value - (_lastDelta / _initHeight) * 10,
        curve: Curves.easeOutExpo,
        duration: Duration(milliseconds: 500),
      );
    } else {
      if (_scrollController.offset == 0.0) {
        _animationController.animateTo(
          _animationController.value - (_lastDelta / _initHeight) * 10,
          curve: Curves.easeOutExpo,
          duration: Duration(milliseconds: 500),
        );
      }
    }
  }

  ///
  ///
  ///
  ///
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
            widget.sliver1,
            widget.sliver2,
            widget.sliver3,
            widget.sliver4,
            _uniformBottomWidget(),
          ],
        ),
      ),
    );
  }

  ///
  ///
  ///
  ///
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
                  SizedBox(width: _circularRadius / 2),
                  Expanded(
                    child: Text(
                      "池显名称:  " + widget.mainNode.fragmentPoolDateList[widget.mainNode.index]["pool_display_name"].toString(),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  SizedBox(width: 10),
                  MyButton(
                    child: Container(
                      padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
                      child: Icon(Icons.remove_red_eye),
                    ),
                    onPressed: () {},
                  ),
                  MyButton(
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
    double layoutWidth = widget.mainNode.fragmentPoolDateMapClone[widget.mainNodeState.thisRouteName]["layout_width"];
    double layoutHeight = widget.mainNode.fragmentPoolDateMapClone[widget.mainNodeState.thisRouteName]["layout_height"];
    String poolDisplayName = widget.mainNode.fragmentPoolDateList[widget.mainNode.index]["pool_display_name"].toString();

    return StatefulBuilder(
      builder: (_, rebuild) {
        if (layoutHeight >= MediaQueryData.fromWindow(window).size.height / 2) {
          return SliverToBoxAdapter(
            child:
                // 设置高度
                Container(
              height: layoutHeight + 40,
              child: _uniformMappingMain(layoutWidth, layoutHeight, poolDisplayName),
            ),
          );
        } else {
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
