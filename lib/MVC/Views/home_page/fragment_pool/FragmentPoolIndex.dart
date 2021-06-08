import 'package:flutter/material.dart';
import 'package:jysp/mvc/controllers/HomePageController.dart';
import 'package:jysp/mvc/views/home_page/fragment_pool/fragment_pools/complete_pool/CompletePoolFreeBox.dart';
import 'package:jysp/mvc/views/home_page/fragment_pool/fragment_pools/memory_pool/MemoryPoolFreeBox.dart';
import 'package:jysp/mvc/views/home_page/fragment_pool/fragment_pools/pending_pool/PendingPoolFreeBox.dart';
import 'package:jysp/mvc/views/home_page/fragment_pool/fragment_pools/rule_pool/RulePoolFreeBox.dart';
import 'package:jysp/tools/Helper.dart';
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
