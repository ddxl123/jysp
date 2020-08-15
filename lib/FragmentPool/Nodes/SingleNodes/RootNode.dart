import 'package:flutter/material.dart';
import 'package:jysp/FragmentPool/NodeMixin.dart';
import 'package:jysp/FragmentPool/Nodes/BaseNode.dart';
import 'package:jysp/FragmentPool/Nodes/MainNode.dart';

class RootNode extends BaseNode {
  RootNode(MainNode mainNode, MainNodeState mainNodeState) : super(mainNode, mainNodeState);

  @override
  State<StatefulWidget> createState() => _RootNodeState();
}

class _RootNodeState extends State<RootNode> with NodeMixin {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: FlatButton(
        onPressed: () {
          nodeShowBottomSheet(
            context: context,
            mainNode: widget.mainNode,
            sliverList: (circularRadius, uniformBottomWidget) => sliverList(circularRadius, uniformBottomWidget),
          );
        },
        child: Text("data"),
      ),
    );
  }

  bool _isMax = false;
  Function _rebuild = () {};
  @override
  List<Widget> sliverList(double circularRadius, Widget uniformBottomWidget) {
    return [
      SliverToBoxAdapter(
        child: Container(
          height: circularRadius,
        ),
      ),
      SliverPersistentHeader(
        pinned: true,
        delegate: AAA(
          minHeight: 50,
          maxHeight: 50,
          child: FlatButton(
            child: Text("data"),
            onPressed: () {
              _isMax = !_isMax;
              _rebuild(() {});
            },
          ),
        ),
      ),
      StatefulBuilder(
        builder: (_, rebuild) {
          _rebuild = rebuild;
          if (!_isMax) {
            return SliverPersistentHeader(
              pinned: true,
              delegate: AAA(
                minHeight: 200,
                maxHeight: 200,
                child: Container(
                  color: Colors.pink,
                  alignment: Alignment.center,
                  child: Text("data"),
                ),
              ),
            );
          } else {
            return SliverPersistentHeader(
              pinned: true,
              delegate: AAA(
                minHeight: 0,
                maxHeight: 200,
                child: Container(
                  color: Colors.pink,
                  alignment: Alignment.center,
                  child: Text("data"),
                ),
              ),
            );
          }
        },
      ),
      SliverList(
        delegate: SliverChildBuilderDelegate(
          (_, index) {
            return Container(
              alignment: Alignment.center,
              child: Text(index.toString()),
            );
          },
        ),
      ),
    ];
  }
}

class AAA extends SliverPersistentHeaderDelegate {
  AAA({@required this.child, @required this.minHeight, @required this.maxHeight});
  final double minHeight;
  final double maxHeight;
  final Widget child;

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    print(shrinkOffset);
    return SizedBox.expand(child: child);
  }

  @override
  double get maxExtent => maxHeight;

  @override
  double get minExtent => minHeight;

  @override
  bool shouldRebuild(AAA oldDelegate) {
    return maxHeight != oldDelegate.maxHeight || minHeight != oldDelegate.minHeight || child != oldDelegate.child;
  }
}
