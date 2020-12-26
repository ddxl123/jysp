import 'package:flutter/material.dart';
import 'package:jysp/FragmentPool/FragmentPool/FragmentPoolController.dart';
import 'package:jysp/FragmentPool/FragmentPoolEnum.dart';

///
///
///
/// 选项按钮
///
class FragmentPoolChoice extends StatefulWidget {
  FragmentPoolChoice({@required this.fragmentPoolController});
  final FragmentPoolController fragmentPoolController;

  @override
  _FragmentPoolChoiceState createState() => _FragmentPoolChoiceState();
}

class _FragmentPoolChoiceState extends State<FragmentPoolChoice> {
  ///

  String _buttonName = "待定池";

  @override
  Widget build(BuildContext context) {
    _changeButtonName();
    return _choiceButton();
  }

  void _changeButtonName() {
    switch (widget.fragmentPoolController.fragmentPoolSelectedType) {
      case FragmentPoolSelectedType.pendingPool:
        _buttonName = "待定池";
        break;
      case FragmentPoolSelectedType.memoryPool:
        _buttonName = "记忆池";
        break;
      case FragmentPoolSelectedType.completePool:
        _buttonName = "完成池";
        break;
      case FragmentPoolSelectedType.wikiPool:
        _buttonName = "百科池";
        break;
      default:
        _buttonName = "unknown";
    }
  }

  Widget _choiceButton() {
    return FlatButton(
      color: Colors.white,
      child: Text(_buttonName),
      onPressed: () {
        Navigator.push(
          context,
          FragmentPoolChoicePage(
            ctx: context,
            rebuild: () {
              setState(() {});
            },
            fragmentPoolController: widget.fragmentPoolController,
          ),
        );
      },
    );
  }
}

///
///
///
/// 弹出的选项页
///
class FragmentPoolChoicePage extends OverlayRoute {
  FragmentPoolChoicePage({@required this.ctx, @required this.rebuild, @required this.fragmentPoolController});
  final BuildContext ctx;
  final Function rebuild;
  final FragmentPoolController fragmentPoolController;
  Size size;

  @override
  Iterable<OverlayEntry> createOverlayEntries() {
    size = (ctx.findRenderObject() as RenderBox).size;
    return [
      OverlayEntry(
        builder: (_) {
          return Stack(
            alignment: AlignmentDirectional.center,
            children: [
              /// 背景
              _background(_),
              _choiceArea(_),
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

  Widget _choiceArea(BuildContext _) {
    return Positioned(
      bottom: size.height,
      child: Column(
        children: [
          _choiceButton(_, FragmentPoolSelectedType.pendingPool, "待定池"),
          _choiceButton(_, FragmentPoolSelectedType.memoryPool, "记忆池"),
          _choiceButton(_, FragmentPoolSelectedType.completePool, "完成池"),
          _choiceButton(_, FragmentPoolSelectedType.wikiPool, "百科池"),
        ],
      ),
    );
  }

  Widget _choiceButton(BuildContext _, FragmentPoolSelectedType currentButtonType, String currentButtonName) {
    return Offstage(
      offstage: fragmentPoolController.fragmentPoolSelectedType == currentButtonType ? true : false,
      child: FlatButton(
        color: Colors.white,
        child: Text(currentButtonName),
        onPressed: () {
          fragmentPoolController.fragmentPoolSelectedType = currentButtonType;
          rebuild();
          Navigator.removeRoute(_, this);
        },
      ),
    );
  }
}
