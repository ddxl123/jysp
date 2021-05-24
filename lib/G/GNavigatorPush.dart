import 'package:flutter/material.dart';
import 'package:jysp/Database/MergeModels/MMFragmentsAboutPoolNode.dart';
import 'package:jysp/Database/MergeModels/MMPoolNode.dart';
import 'package:jysp/Database/Models/MBase.dart';
import 'package:jysp/Database/Models/MFragmentsAboutCompletePoolNode.dart';
import 'package:jysp/Database/Models/MFragmentsAboutMemoryPoolNode.dart';
import 'package:jysp/Database/Models/MFragmentsAboutPendingPoolNode.dart';
import 'package:jysp/Database/Models/MFragmentsAboutRulePoolNode.dart';
import 'package:jysp/MVC/Controllers/FragmentPoolController/FragmentPoolController.dart';
import 'package:jysp/MVC/Controllers/InitDownloadController/InitDownloadController.dart';
import 'package:jysp/MVC/Controllers/LoginPageController.dart';
import 'package:jysp/MVC/Views/HomePage/HomePage.dart';
import 'package:jysp/MVC/Views/InitDownloadPage/InitDownloadPage.dart';
import 'package:jysp/MVC/Views/LoginPage.dart';
import 'package:jysp/Tools/SheetPage/SheetPage.dart';
import 'package:jysp/Tools/SheetPage/SheetPageController.dart';
import 'package:jysp/Tools/TDebug.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

class GNavigatorPush {
  ///

  GNavigatorPush.pushLoginPage(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute<void>(
        builder: (_) => ChangeNotifierProvider<LoginPageController>(
          create: (_) => LoginPageController(),
          child: Builder(builder: (_) => LoginPage()),
        ),
      ),
    );
  }

  GNavigatorPush.pushInitDownloadPage(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute<void>(
        builder: (_) => ChangeNotifierProvider<InitDownloadController>(
          create: (_) => InitDownloadController(),
          child: Builder(builder: (_) => InitDownloadPage()),
        ),
      ),
    );
  }

  GNavigatorPush.pushHomePage(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute<void>(
        builder: (_) => MultiProvider(
          providers: <SingleChildWidget>[
            ChangeNotifierProvider<FragmentPoolController>(create: (_) => FragmentPoolController()),
          ],
          child: HomePage(),
        ),
      ),
    );
  }

  GNavigatorPush.pushSheetPage(BuildContext context) {
    Navigator.push(
      context,
      SheetPage<String, int>(
        sheetPageController: SheetPageController<String, int>(),
        bodyDataFuture: (List<String> bodyData, Mark<int> mark) async {
          try {
            await Future<void>.delayed(const Duration(seconds: 2));
            const int readCount = 10;
            mark.value ??= 0;
            await context.read<FragmentPoolController>().poolTypeSwitchFuture<List<MMFragmentsAboutPoolNode>>(
              pendingPoolCB: () async {
                return await MBase.queryRowsAsModels<MFragmentsAboutPendingPoolNode, MMFragmentsAboutPoolNode, MMFragmentsAboutPoolNode>(
                  connectTransaction: null,
                  tableName: MFragmentsAboutPendingPoolNode.tableName,
                  columns: <String>[MFragmentsAboutPendingPoolNode.title], // 只获取该列
                  limit: readCount,
                  offset: mark.value,
                  returnMWhere: null,
                  returnMMWhere: (MFragmentsAboutPendingPoolNode model) {
                    final MMFragmentsAboutPoolNode mmFragmentsAboutPoolNode = MMFragmentsAboutPoolNode(model: model);
                    bodyData.add(mmFragmentsAboutPoolNode.get_title ?? 'unknown');
                    return mmFragmentsAboutPoolNode;
                  }, // 会从 mark.value + 1 的 index 开始
                );
              },
              memoryPoolCB: () async {
                return await MBase.queryRowsAsModels<MFragmentsAboutMemoryPoolNode, MMFragmentsAboutPoolNode, MMFragmentsAboutPoolNode>(
                  connectTransaction: null,
                  tableName: MFragmentsAboutMemoryPoolNode.tableName,
                  columns: <String>[MFragmentsAboutMemoryPoolNode.title], // 只获取该列
                  limit: readCount,
                  offset: mark.value,
                  returnMWhere: null,
                  returnMMWhere: (MFragmentsAboutMemoryPoolNode model) {
                    final MMFragmentsAboutPoolNode mmFragmentsAboutPoolNode = MMFragmentsAboutPoolNode(model: model);
                    bodyData.add(mmFragmentsAboutPoolNode.get_title ?? 'unknown');
                    return mmFragmentsAboutPoolNode;
                  }, // 会从 mark.value + 1 的 index 开始
                );
              },
              completePoolCB: () async {
                return await MBase.queryRowsAsModels<MFragmentsAboutCompletePoolNode, MMFragmentsAboutPoolNode, MMFragmentsAboutPoolNode>(
                  connectTransaction: null,
                  tableName: MFragmentsAboutCompletePoolNode.tableName,
                  columns: <String>[MFragmentsAboutCompletePoolNode.title], // 只获取该列
                  limit: readCount,
                  offset: mark.value,
                  returnMWhere: null,
                  returnMMWhere: (MFragmentsAboutCompletePoolNode model) {
                    final MMFragmentsAboutPoolNode mmFragmentsAboutPoolNode = MMFragmentsAboutPoolNode(model: model);
                    bodyData.add(mmFragmentsAboutPoolNode.get_title ?? 'unknown');
                    return mmFragmentsAboutPoolNode;
                  }, // 会从 mark.value + 1 的 index 开始
                );
              },
              rulePoolCB: () async {
                return await MBase.queryRowsAsModels<MFragmentsAboutRulePoolNode, MMFragmentsAboutPoolNode, MMFragmentsAboutPoolNode>(
                  connectTransaction: null,
                  tableName: MFragmentsAboutRulePoolNode.tableName,
                  columns: <String>[MFragmentsAboutRulePoolNode.title], // 只获取该列
                  limit: readCount,
                  offset: mark.value,
                  returnMWhere: null,
                  returnMMWhere: (MFragmentsAboutRulePoolNode model) {
                    final MMFragmentsAboutPoolNode mmFragmentsAboutPoolNode = MMFragmentsAboutPoolNode(model: model);
                    bodyData.add(mmFragmentsAboutPoolNode.get_title ?? 'unknown');
                    return mmFragmentsAboutPoolNode;
                  }, // 会从 mark.value + 1 的 index 开始
                );
              },
            );

            // 全部成功后才能对其增值
            // 当第一次取 0-10 个时, 下一次取 11-20 个、
            mark.value = mark.value! + readCount;
            return BodyDataFutureResult.success;
          } catch (e, r) {
            dLog(() => e.toString() + '----' + r.toString());
            return BodyDataFutureResult.fail;
          }
        },
        header: (SheetPageController<String, int> sheetPageController) {
          return SliverToBoxAdapter(
            child: Container(
              height: 50,
              color: Colors.orange,
              child: const Text('data'),
            ),
          );
        },
        body: (SheetPageController<String, int> sheetPageController) {
          return SliverList(
            delegate: SliverChildBuilderDelegate(
              (_, int index) {
                bool isCheck = false;
                return Row(
                  children: <Widget>[
                    Expanded(
                      child: TextButton(
                        style: TextButton.styleFrom(
                          padding: const EdgeInsets.all(0),
                          backgroundColor: Colors.purple,
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        ),
                        onPressed: () {},
                        child: Text(sheetPageController.bodyData[index].toString()),
                      ),
                    ),
                    StatefulBuilder(
                      builder: (BuildContext context, void Function(void Function()) rebuild) {
                        return Checkbox(
                          value: isCheck,
                          onChanged: (bool? check) {
                            isCheck = !isCheck;
                            rebuild(() {});
                          },
                        );
                      },
                    ),
                  ],
                );
              },
              childCount: sheetPageController.bodyData.length,
            ),
          );
        },
      ),
    );
  }

  ///
}
