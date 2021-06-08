import 'package:flutter/material.dart';
import 'package:jysp/database/merge_models/MMPoolNode.dart';
import 'package:jysp/database/models/MFragmentsAboutPendingPoolNode.dart';
import 'package:jysp/mvc/request/offline/RSqliteCurd.dart';
import 'package:jysp/tools/Helper.dart';
import 'package:jysp/tools/RoundedBox..dart';
import 'package:jysp/tools/TDebug.dart';

class CreateFragmentPage extends StatefulWidget {
  const CreateFragmentPage({required this.mmodel});
  final MMPoolNode mmodel;

  @override
  _CreateFragmentPageState createState() => _CreateFragmentPageState();
}

class _CreateFragmentPageState extends State<CreateFragmentPage> {
  final TextEditingController _textEditingController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Center(
        child: RoundedBox(
          children: <Widget>[
            Text('给 ${widget.mmodel.get_name} 节点添加新碎片：'),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                const Text('title：'),
                Container(
                  width: 100,
                  child: TextField(
                    controller: _textEditingController,
                  ),
                ),
              ],
            ),
            TextButton(
              child: const Text('添加'),
              onPressed: () async {
                final MFragmentsAboutPendingPoolNode newModel = MFragmentsAboutPendingPoolNode.createModel(
                  aiid_v: null,
                  uuid_v: createUUID(),
                  raw_fragment_aiid_v: null,
                  raw_fragment_uuid_v: null,
                  pn_pending_pool_node_aiid_v: widget.mmodel.get_aiid,
                  pn_pending_pool_node_uuid_v: widget.mmodel.get_uuid,
                  recommend_rule_aiid_v: null,
                  recommend_rule_uuid_v: null,
                  title_v: _textEditingController.text,
                  created_at_v: createCurrentTimestamp(),
                  updated_at_v: createCurrentTimestamp(),
                );
                final MFragmentsAboutPendingPoolNode? result = await RSqliteCurd<MFragmentsAboutPendingPoolNode>.byModel(newModel).toInsertRow(transactionMark: null);
                if (result == null) {
                  dLog(() => '插入失败');
                } else {
                  dLog(() => '插入成功');
                  Navigator.pop(context);
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
