import 'package:flutter/material.dart';
import 'package:jysp/G/GDb.dart';
import 'package:jysp/G/GFragmentPool.dart';
import 'package:jysp/G/GHttp.dart';

class G {
  // // 工厂模式
  // factory GlobalData() => _getInstance();
  // static GlobalData get instance => _getInstance();
  // static GlobalData _instance;
  // GlobalData._internal() {
  //   // 初始化
  // }
  // static GlobalData _getInstance() {
  //   if (_instance == null) {
  //     _instance = GlobalData._internal();
  //   }
  //   return _instance;
  // }

  static final GlobalKey globalKey = GlobalKey();

  static final GHttp http = GHttp();

  static final GDb db = GDb();

  static final GFragmentPool fragmentPool = GFragmentPool();
}
