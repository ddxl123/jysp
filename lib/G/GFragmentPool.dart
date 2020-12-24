import 'package:jysp/FragmentPool/FragmentPoolEnum.dart';

class GFragmentPool {
  final List<dynamic> fragmentPoolPendingNodes = [];

  Function(Function callback) startResetLayout = (callback) {};

  SelectedFragmentPool selectedFragmentPool = SelectedFragmentPool.pendingPool;
}
