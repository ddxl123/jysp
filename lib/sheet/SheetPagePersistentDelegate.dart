import 'package:flutter/material.dart';

class SheetPagePersistentDelegate extends SliverPersistentHeaderDelegate {
  SheetPagePersistentDelegate({@required this.child, @required this.minHeight, @required this.maxHeight});
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
  bool shouldRebuild(SheetPagePersistentDelegate oldDelegate) {
    return maxHeight != oldDelegate.maxHeight || minHeight != oldDelegate.minHeight || child != oldDelegate.child;
  }
}
