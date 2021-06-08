import 'package:flutter/material.dart';
import 'package:jysp/database/merge_models/MMFragmentsAboutPoolNode.dart';
import 'package:jysp/mvc/views/home_page/fragment_pool/fragment_pool_common/fragment_pool_toast_route_commons/FragmentButtonLongPressedCommon.dart';
import 'package:jysp/tools/CustomButton.dart';

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
