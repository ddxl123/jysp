import 'package:flutter/material.dart';
import 'package:jysp/MVC/Controllers/HomePageController.dart';
import 'package:jysp/MVC/Views/HomePage/FragmentPool/FragmentPools/CompletePool/CompletePoolFreeBox.dart';
import 'package:jysp/MVC/Views/HomePage/FragmentPool/FragmentPools/MemoryPool/MemoryPoolFreeBox.dart';
import 'package:jysp/MVC/Views/HomePage/FragmentPool/FragmentPools/PendingPool/PendingPoolFreeBox.dart';
import 'package:jysp/MVC/Views/HomePage/FragmentPool/FragmentPools/RulePool/RulePoolFreeBox.dart';
import 'package:jysp/Tools/Helper.dart';
import 'package:provider/provider.dart';

class FragmentPoolIndex extends StatefulWidget {
  @override
  _FragmentPoolIndexState createState() => _FragmentPoolIndexState();
}

class _FragmentPoolIndexState extends State<FragmentPoolIndex> {
  @override
  void initState() {
    super.initState();
    context.read<HomePageController>().fragmentPoolIndexSetState = putSetState(setState);
    WidgetsBinding.instance!.addPostFrameCallback(
      (Duration timeStamp) async {
        await context.read<HomePageController>().toPool(toPoolType: PoolType.pendingPool);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return IndexedStack(
      index: context.read<HomePageController>().getCurrentPoolType.index,
      children: <Widget>[
        PendingPoolFreeBox(),
        MemoryPoolFreeBox(),
        CompletePoolFreeBox(),
        RulePoolFreeBox(),
      ],
    );
  }
}
