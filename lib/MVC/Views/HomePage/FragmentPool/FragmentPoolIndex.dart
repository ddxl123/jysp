import 'package:flutter/material.dart';
import 'package:jysp/MVC/Controllers/HomePageController.dart';
import 'package:jysp/MVC/Views/HomePage/FragmentPool/FragmentPools/CompletePool/CompletePoolFreeBox.dart';
import 'package:jysp/MVC/Views/HomePage/FragmentPool/FragmentPools/MemoryPool/MemoryPoolFreeBox.dart';
import 'package:jysp/MVC/Views/HomePage/FragmentPool/FragmentPools/PendingPool/PendingPoolFreeBox.dart';
import 'package:jysp/MVC/Views/HomePage/FragmentPool/FragmentPools/RulePool/RulePoolFreeBox.dart';
import 'package:provider/provider.dart';

class FragmentPoolIndex extends StatefulWidget {
  @override
  _FragmentPoolIndexState createState() => _FragmentPoolIndexState();
}

class _FragmentPoolIndexState extends State<FragmentPoolIndex> {
  @override
  void initState() {
    super.initState();
    context.read<HomePageController>().fragmentPoolIndexSetState = setState;
  }

  @override
  Widget build(BuildContext context) {
    // 因为每个碎片池的 freeBox 都不一样，因此要分开
    switch (context.select<HomePageController, PoolType>((HomePageController value) => value.getCurrentPoolType)) {
      case PoolType.pendingPool:
        return PendingPoolFreeBox();
      case PoolType.memoryPool:
        return MemoryPoolFreeBox();
      case PoolType.completePool:
        return CompletePoolFreeBox();
      case PoolType.rulePool:
        return RulePoolFreeBox();
      default:
        return Center(child: Text('unknown pool type: ${context.select<HomePageController, PoolType>((HomePageController value) => value.getCurrentPoolType)}'));
    }
  }
}
