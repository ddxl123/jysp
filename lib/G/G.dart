import 'package:flutter/material.dart';
import 'package:jysp/G/GHttp.dart';
import 'package:jysp/G/GSqlite.dart';

class G {
  static final GlobalKey globalKey = GlobalKey();

  static final GHttp http = GHttp();

  static final GSqlite sqlite = GSqlite();
}
