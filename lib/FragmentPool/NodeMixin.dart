import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:jysp/Buttons.dart';
import 'package:jysp/FragmentPool/Nodes/MainNode.dart';

mixin NodeMixin {
  double _circularRadius = 35.0;
  MainNode _mainNode;
  MainNodeState _mainNodeState;
  PersistentBottomSheetController sbs;

  void nodeAddFragment(MainNode mainNode, MainNodeState mainNodeState) {
    mainNode.fragmentPoolDateList.add({
      "route": () {
        int childCount = 0;
        for (int i = 0; i < mainNode.fragmentPoolDateList.length; i++) {
          if (mainNode.fragmentPoolDateMapClone.containsKey(mainNodeState.thisRouteName + "-$i")) {
            childCount++;
          } else {
            break;
          }
        }
        return mainNodeState.thisRouteName + "-$childCount";
      }(),
      "type": 1,
      "out_display_name": "${mainNodeState.thisRouteName},hhhhh",
    });
    mainNode.doChange();
  }

  ///
  ///
  ///
  ///
  ///
  PersistentBottomSheetController nodeShowBottomSheet({
    @required BuildContext context,
    @required MainNode mainNode,
    @required MainNodeState mainNodeState,
    Widget sliver1 = const SliverToBoxAdapter(),
    Widget sliver2 = const SliverToBoxAdapter(),
    Widget sliver3 = const SliverToBoxAdapter(),
    Widget sliver4 = const SliverToBoxAdapter(),
  }) {
    _mainNode = mainNode;
    _mainNodeState = mainNodeState;

    sbs = showBottomSheet(
      /// 必须让 [showBottomSheet] 的背景透明，才能对下面的组件进行圆角切割
      backgroundColor: Colors.transparent,
      context: context,
      builder: (_) {
        return

            ///
            Container(
          decoration: BoxDecoration(
            // 整体背景颜色
            color: Colors.white,
            // 进行圆角切割
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(_circularRadius),
              topRight: Radius.circular(_circularRadius),
            ),
            // 阴影
            boxShadow: [
              BoxShadow(blurRadius: 15, spreadRadius: -5),
            ],
          ),

          ///
          child: DraggableScrollableSheet(
            initialChildSize: 0.5,
            minChildSize: 0,
            maxChildSize: (MediaQueryData.fromWindow(window).size.height - MediaQueryData.fromWindow(window).padding.top) / MediaQueryData.fromWindow(window).size.height,
            expand: false,
            builder: (context, scrollController) {
              scrollController.addListener(() {
                print(scrollController.offset);
              });
              return CustomScrollView(
                controller: scrollController,
                slivers: [
                  _uniformTopWidget(),
                  _unifromFixedWidget(),
                  _uniformMappingWidget(),
                  sliver1,
                  sliver2,
                  sliver3,
                  sliver4,
                  _uniformBottomWidget(),
                ],
              );
            },
          ),
        );
      },
    );

    mainNode.freeBoxController.eventBindOnce(
      updateBindOnce: () {
        //// 这里要 [try] ,因为 [sbs] 实在没找到监听是否已经被 [close] 的函数
        try {
          sbs.close();
        } catch (e) {}
      },
      endBindOnce: () {
        //// 这里要 [try] ,因为 [sbs] 实在没找到监听是否已经被 [close] 的函数
        try {
          sbs.close();
        } catch (e) {}
      },
    );
    return sbs;
  }

  Widget _unifromFixedWidget() {
    return SliverPersistentHeader(
      pinned: true,
      delegate: NodePersistentDelegate(
        minHeight: 50,
        maxHeight: 50,
        child: Container(
          color: Colors.pink,
          child: Row(
            children: [
              SizedBox(width: _circularRadius / 2),
              Expanded(
                child: Text(
                  "池显名称:  " + _mainNode.fragmentPoolDateList[_mainNode.index]["pool_display_name"].toString(),
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
  }

  Widget _uniformMappingWidget() {
    double layoutWidth = _mainNode.fragmentPoolDateMapClone[_mainNodeState.thisRouteName]["layout_width"];
    double layoutHeight = _mainNode.fragmentPoolDateMapClone[_mainNodeState.thisRouteName]["layout_height"];
    String poolDisplayName = _mainNode.fragmentPoolDateList[_mainNode.index]["pool_display_name"].toString();

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

  Widget _uniformTopWidget() {
    return SliverToBoxAdapter(
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(_circularRadius),
            topRight: Radius.circular(_circularRadius),
          ),
        ),
        alignment: Alignment.center,
        height: _circularRadius,
        child: Container(
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

  Widget _uniformBottomWidget() {
    return SliverFillRemaining(
      hasScrollBody: true,
      child: Container(
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
