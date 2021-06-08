import 'package:flutter/material.dart';
import 'package:jysp/WillToHomePage.dart';
import 'package:jysp/g/G.dart';
import 'package:jysp/tools/CustomButton.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _MyApp();
  }
}

class _MyApp extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return CustomButton(
      child: MaterialApp(
        home: Material(
          key: globalKey,
          child: WillToHomePage(),
        ),
      ),
      isAlwaysOnDown: true,
      onDown: (PointerDownEvent downEvent) {
        touchPosition = downEvent.localPosition;
        if (onDownEvents.isNotEmpty) {
          onDownEvents.first.call();
          onDownEvents.clear();
        }
      },
      isAlwaysOnUp: true,
      onUp: (PointerUpEvent upEvent) {
        touchPosition = upEvent.localPosition;
        if (onUpEvents.isNotEmpty) {
          onUpEvents.first.call();
          onUpEvents.clear();
        }
      },
      isAlwaysOnLongPressed: true,
      onLongPressed: (PointerDownEvent downEvent) {
        touchPosition = downEvent.localPosition;
        if (onLongPressedEvents.isNotEmpty) {
          onLongPressedEvents.first.call();
          onLongPressedEvents.clear();
        }
      },
    );
  }
}
