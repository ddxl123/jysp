import 'package:flutter/material.dart';
import 'package:jysp/global_floating_ball/sqlite_data_floating_ball/SqliteDataFloatingBall.dart';
import 'package:jysp/global_floating_ball/upload_floating_ball/UploadFloatingBall.dart';

class EnableGlobalFloatingBall {
  EnableGlobalFloatingBall(BuildContext context) {
    final OverlayState overlayState = Overlay.of(context)!;
    overlayState.insertAll(overlayEntrys);
  }

  /// 把所有要启动的悬浮球放在这里面
  final List<OverlayEntry> overlayEntrys = <OverlayEntry>[
    SqliteDataFloatingBall().overlayEntry,
    UploadFloatingBall().overlayEntry,
  ];
}
