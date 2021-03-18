import 'package:flutter/material.dart';
import 'package:jysp/MVC/Controllers/FragmentPoolController.dart';
import 'package:jysp/Plugin/FreeBox/FreeBoxController.dart';
import 'package:jysp/Database/both/TFragmentPoolNode.dart';

///
///
///
/// 选项按钮
///
class FragmentPoolChoice extends StatefulWidget {
  FragmentPoolChoice({required this.fragmentPoolController, required this.freeBoxController});
  final FragmentPoolController fragmentPoolController;
  final FreeBoxController freeBoxController;

  @override
  _FragmentPoolChoiceState createState() => _FragmentPoolChoiceState();
}

class _FragmentPoolChoiceState extends State<FragmentPoolChoice> {
  @override
  Widget build(BuildContext context) {
    return TextButton(
      style: TextButton.styleFrom(primary: Colors.green),

      /// 该文本默认匹配 [currentFragmentPoolType] 的默认值
      child: Text(widget.fragmentPoolController.getCurrentPoolType.text),
      onPressed: () {
        Navigator.push(
          context,
          FragmentPoolChoicePage(
            ctx: context,
            mainButtonRebuild: _mainButtonRebuild,
            fragmentPoolController: widget.fragmentPoolController,
            freeBoxController: widget.freeBoxController,
          ),
        );
      },
    );
  }

  void _mainButtonRebuild() {
    setState(() {});
  }
}

///
///
///
/// 弹出的选项页
///
class FragmentPoolChoicePage extends OverlayRoute {
  FragmentPoolChoicePage({
    required this.ctx,
    required this.mainButtonRebuild,
    required this.fragmentPoolController,
    required this.freeBoxController,
  });
  final BuildContext ctx;
  final Function mainButtonRebuild;
  final FragmentPoolController fragmentPoolController;
  final FreeBoxController freeBoxController;
  late Size size;

  @override
  Iterable<OverlayEntry> createOverlayEntries() {
    /// 获取 mainButton 的尺寸
    size = (ctx.findRenderObject() as RenderBox).size;
    return [
      OverlayEntry(
        builder: (_) {
          return Stack(
            alignment: AlignmentDirectional.center,
            children: [
              /// 背景
              _background(_),

              /// 子按钮区域
              _toButtonArea(_),
            ],
          );
        },
      ),
    ];
  }

  Widget _background(BuildContext _) {
    return Positioned(
      child: Listener(
        child: Container(color: Colors.black12),
        onPointerUp: (event) {
          Navigator.removeRoute(_, this);
        },
      ),
    );
  }

  Widget _toButtonArea(BuildContext _) {
    return Positioned(
      bottom: size.height,
      child: Column(
        children: [
          _toButton(ctx: _, toButtonType: PoolType.pendingPool),
          _toButton(ctx: _, toButtonType: PoolType.memoryPool),
          _toButton(ctx: _, toButtonType: PoolType.completePool),
          _toButton(ctx: _, toButtonType: PoolType.wikiPool),
        ],
      ),
    );
  }

  Widget _toButton({required BuildContext ctx, required PoolType toButtonType}) {
    return TextButton(
      style: TextButton.styleFrom(primary: Colors.white),
      child: Text(toButtonType.text),
      onPressed: () async {
        /// 关闭当前路由窗口
        Navigator.removeRoute(ctx, this);

        fragmentPoolController.toPool(
          freeBoxController: freeBoxController,
          toPoolType: toButtonType,
          toPoolTypeResult: (resultCode) {
            if (resultCode == 1) {
              mainButtonRebuild();
            }
          },
        );
      },
    );
  }
}
