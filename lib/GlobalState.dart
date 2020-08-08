class GlobalState {
  factory GlobalState() => _getInstance();
  static GlobalState get instance => _getInstance();
  static GlobalState _instance;
  static GlobalState _getInstance() {
    if (_instance == null) {
      _instance = GlobalState._internal();
    }
    return _instance;
  }

  GlobalState._internal() {
    // 初始化
  }
}
