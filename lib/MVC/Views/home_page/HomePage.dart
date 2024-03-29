import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:jysp/mvc/controllers/HomePageController.dart';
import 'package:jysp/mvc/views/home_page/fragment_pool/FragmentPoolIndex.dart';
import 'package:jysp/mvc/views/home_page/home_page_toast_routes/FragmentPoolChoice.dart';
import 'package:jysp/tools/Helper.dart';
import 'package:jysp/tools/toast/ShowToast.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Material(
      child: Stack(
        children: <Widget>[
          Positioned(
            top: 0,
            child: FragmentPoolIndex(),
          ),
          _bottomWidgets(),
        ],
      ),
    );
  }

  Widget _bottomWidgets() {
    return Positioned(
      bottom: 0,
      child: Container(
        /// Row在Stack中默认不是撑满宽度
        width: MediaQueryData.fromWindow(window).size.width,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Expanded(child: TextButton(onPressed: () {}, child: const Text('发现'))),
            Expanded(
              child: StatefulBuilder(
                builder: (BuildContext btCtx, SetState setState) {
                  return TextButton(
                    onPressed: () {
                      showToastRoute(context, FragmentPoolChoiceRoute(btCtx));
                    },
                    child: Text(context.read<HomePageController>().getCurrentPoolType.text),
                  );
                },
              ),
            ),
            Expanded(child: TextButton(onPressed: () {}, child: const Text('我'))),
          ],
        ),
      ),
    );
  }
}
