import 'package:flutter/material.dart';
import 'package:jysp/Database/MergeModels/MMPoolNode.dart';
import 'package:jysp/Database/Models/MBase.dart';
import 'package:jysp/Database/Models/MPnCompletePoolNode.dart';
import 'package:jysp/Database/Models/MPnMemoryPoolNode.dart';
import 'package:jysp/Database/Models/MPnPendingPoolNode.dart';
import 'package:jysp/Database/Models/MPnRulePoolNode.dart';
import 'package:jysp/MVC/Controllers/FragmentPoolController/FragmentPoolController.dart';
import 'package:jysp/Tools/TDebug.dart';

/// 1. 当 [PoolType.index] 时，获取的是 [int]。
/// 2. 当 [PoolType.value] 时，获取的是 [string]。
enum PoolType {
  pendingPool, // 0
  memoryPool, // 1
  completePool, // 2
  rulePool, // 3
}

extension PoolSelectedTypeExt on PoolType {
  String get text {
    switch (index) {
      case 0:
        return '待定池';
      case 1:
        return '记忆池';
      case 2:
        return '完成池';
      case 3:
        return '规则池';
      case 4:
      default:
        throw Exception('Index is unknown!');
    }
  }
}

/// [fail]：获取数据失败，不跳转到对应的 type；
///
/// [success]：获取数据成功，自动跳转到对应的 type；
///
/// [invalid]：toPool 并发,，不跳转到对应的 type。
enum ToPoolResult {
  fail,
  success,
  invalid,
}

class HomePageController extends ChangeNotifier {
  ///

  /// 当前展现的碎片池类型
  PoolType _currentPoolType = PoolType.pendingPool;
  PoolType get getCurrentPoolType => _currentPoolType;
  void setCurrentPoolType(PoolType value) {
    _currentPoolType = value;
    notifyListeners();
  }

  /// 碎片池控制器
  FragmentPoolController pendingFragmentPoolController = FragmentPoolController(poolNodesTableName: MPnPendingPoolNode.tableName);
  FragmentPoolController memoryFragmentPoolController = FragmentPoolController(poolNodesTableName: MPnMemoryPoolNode.tableName);
  FragmentPoolController completeFragmentPoolController = FragmentPoolController(poolNodesTableName: MPnCompletePoolNode.tableName);
  FragmentPoolController ruleFragmentPoolController = FragmentPoolController(poolNodesTableName: MPnRulePoolNode.tableName);

  /// 获取当前碎片池控制器
  FragmentPoolController getCurrentFragmentPoolController() {
    switch (_currentPoolType) {
      case PoolType.pendingPool:
        return pendingFragmentPoolController;
      case PoolType.memoryPool:
        return memoryFragmentPoolController;
      case PoolType.completePool:
        return completeFragmentPoolController;
      case PoolType.rulePool:
        return ruleFragmentPoolController;
      default:
        throw 'unknown _currentPoolType: $_currentPoolType';
    }
  }

  /// [FragmentPoolIndex] 的 setState
  void Function(Function()) fragmentPoolIndexSetState = (_) {};

  /// 是否处于 toPooling
  bool _isToPooling = false;

  ///
  ///
  ///
  /// 将进入指定碎片池
  ///
  /// - [toPoolType]：将要进入池的类型。
  ///
  /// 先获取数据后，才会调用 [toPoolTypeResult] 回调，最后才刷新碎片池
  ///
  Future<ToPoolResult> toPool({
    required PoolType toPoolType,
  }) async {
    if (_isToPooling) {
      dLog(() => 'toPool 并发');
      return ToPoolResult.invalid;
    }
    _isToPooling = true;

    dLog(() => '正在获取 fragmentPoolNodes 数据，并进入${toPoolType.text}中...');

    // 获取数据：[toPoolType] 的数据
    final bool result = await retrievePoolNodes();

    if (result == true) {
      dLog(() => '获取 fragmentPoolNodes 数据成功。');
      setCurrentPoolType(toPoolType);
      fragmentPoolIndexSetState(() {});
      _isToPooling = false;
      return ToPoolResult.success;
    }
    //
    else {
      dLog(() => '获取 fragmentPoolNodes 数据失败。');
      _isToPooling = false;
      return ToPoolResult.fail;
    }
  }

  /// 读取当前池的全部节点
  Future<bool> retrievePoolNodes() async {
    try {
      getCurrentFragmentPoolController().poolNodes.clear();
      final List<MMPoolNode> mmodels = await MBase.queryRowsAsModels<MBase, MMPoolNode, MMPoolNode>(
        tableName: getCurrentFragmentPoolController().poolNodesTableName,
        returnMWhere: null,
        returnMMWhere: (MBase model) => MMPoolNode(model: model),
        connectTransaction: null,
      );
      getCurrentFragmentPoolController().poolNodes.addAll(mmodels);
      return true;
    } catch (e) {
      dLog(() => 'retrievePoolNodes err: ', () => e);
      return false;
    }
  }

  ///
}
