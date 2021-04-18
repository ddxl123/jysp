import 'dart:async';

import 'package:flutter/material.dart';
import 'package:jysp/MVC/Controllers/FragmentPoolController/Enums.dart';
import 'package:jysp/Tools/TDebug.dart';

class G {
  static final GlobalKey globalKey = GlobalKey();

  static Future<T> poolTypeSwitchFuture<T>({
    required PoolType toPoolType,
    required Future<T> Function() pendingPoolCB,
    required Future<T> Function() memoryPoolCB,
    required Future<T> Function() completePoolCB,
    required Future<T> Function() rulePoolCB,
    required Future<T> Function() unknownCB,
  }) async {
    switch (toPoolType) {
      case PoolType.pendingPool:
        return await pendingPoolCB();
      case PoolType.memoryPool:
        return await memoryPoolCB();
      case PoolType.completePool:
        return await completePoolCB();
      case PoolType.rulePool:
        return await rulePoolCB();
      default:
        dLog(() => "unknown poolType: $toPoolType");
        return await unknownCB();
    }
  }

  static T poolTypeSwitch<T>({
    required PoolType toPoolType,
    required T Function() pendingPoolCB,
    required T Function() memoryPoolCB,
    required T Function() completePoolCB,
    required T Function() rulePoolCB,
    required T Function() unknownCB,
  }) {
    switch (toPoolType) {
      case PoolType.pendingPool:
        return pendingPoolCB();
      case PoolType.memoryPool:
        return memoryPoolCB();
      case PoolType.completePool:
        return completePoolCB();
      case PoolType.rulePool:
        return rulePoolCB();
      default:
        dLog(() => "unknown poolType: $toPoolType");
        return unknownCB();
    }
  }
}
