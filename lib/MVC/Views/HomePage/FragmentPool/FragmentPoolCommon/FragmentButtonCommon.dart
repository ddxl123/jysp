import 'package:flutter/material.dart';
import 'package:jysp/Database/MergeModels/MMFragmentsAboutPoolNode.dart';
import 'package:jysp/MVC/Views/HomePage/FragmentPool/FragmentPoolCommon/FragmentPoolToastRouteCommons/FragmentButtonLongPressedCommon.dart';
import 'package:jysp/Tools/CustomButton.dart';
import 'package:jysp/Tools/TDebug.dart';

class FragmentButtonCommon extends StatefulWidget {
  const FragmentButtonCommon({required this.mmFragmentsAboutPoolNode});
  final MMFragmentsAboutPoolNode mmFragmentsAboutPoolNode;

  @override
  _FragmentButtonCommonState createState() => _FragmentButtonCommonState();
}

class _FragmentButtonCommonState extends State<FragmentButtonCommon> {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Expanded(
          child: CustomButton(
            child: Container(
              padding: const EdgeInsets.all(10),
              child: Text(widget.mmFragmentsAboutPoolNode.get_title ?? 'unknown'),
            ),
            onLongPressed: (PointerDownEvent event) {
              Navigator.push(context, FragmentButtonLongPressedCommon(context, mmFragmentsAboutPoolNode: widget.mmFragmentsAboutPoolNode));
            },
          ),
        ),
      ],
    );
  }
}
