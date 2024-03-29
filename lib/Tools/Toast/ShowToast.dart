import 'package:flutter/material.dart';
import 'package:jysp/g/G.dart';
import 'package:jysp/tools/toast/ToastRoute.dart';

Toast<T> showToast<T>({required String text, required T returnValue}) {
  final OverlayState? overlayState = Overlay.of(globalKey.currentContext!);
  final OverlayEntry entry = OverlayEntry(
    maintainState: true,
    builder: (BuildContext context) {
      return ToastWidget(text: text);
    },
  );
  if (overlayState == null) {
    throw "overlayState is null. 'text value':$text";
  }
  overlayState.insert(entry);
  Future<void>.delayed(const Duration(seconds: 1), () {
    entry.remove();
  });
  return Toast<T>(returnValue);
}

void showToastRoute(BuildContext context, ToastRoute toastRoute) {
  Navigator.push(context, toastRoute);
}
