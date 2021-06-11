import 'package:flutter/material.dart';
import 'package:jysp/tools/CustomButton.dart';
import 'package:jysp/tools/Helper.dart';
import 'package:jysp/tools/TDebug.dart';

class FlutterTest extends StatefulWidget {
  @override
  _FlutterTestState createState() => _FlutterTestState();
}

class _FlutterTestState extends State<FlutterTest> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: CustomButton(
        child: StatefulBuilder(
          builder: (BuildContext context, SetState sfbSetState) {
            dLog(() => 'ccccccccc');
            return const Text('data');
          },
        ),
        onDown: (PointerDownEvent event) {},
        onUp: (PointerUpEvent event) {},
        onLongPressed: (PointerDownEvent event) {},
      ),
    );
  }

  Widget w = StatefulBuilder(
    builder: (BuildContext context, SetState wSetState) {
      dLog(() => 'ssssss');
      return const Text('data');
    },
  );
}

class Two extends OverlayRoute<void> {
  @override
  Iterable<OverlayEntry> createOverlayEntries() {
    return <OverlayEntry>[
      OverlayEntry(
        maintainState: true,
        opaque: true,
        builder: (_) {
          return TwoWidget();
        },
      ),
    ];
  }
}

class TwoWidget extends StatefulWidget {
  @override
  _TwoWidgetState createState() => _TwoWidgetState();
}

class _TwoWidgetState extends State<TwoWidget> {
  @override
  void initState() {
    super.initState();
    dLog(() => 'TwoWidget init');
  }

  @override
  Widget build(BuildContext context) {
    dLog(() => 'TwoWidget build');
    return Center(
      child: TextButton(
          onPressed: () {
            Navigator.push(context, MaterialPageRoute<void>(builder: (BuildContext context) => Three()));
          },
          child: const Text('to three')),
    );
  }
}

// class Two extends ToastRoute {
//   Two(BuildContext fatherContext) : super(fatherContext);

//   @override
//   Color get backgroundColor => Colors.green;

//   @override
//   double get backgroundOpacity => 0.5;

//   @override
//   List<Positioned> body() {
//     dLog(() => 'body');
//     return <Positioned>[
//       Positioned(
//         top: 200,
//         left: 100,
//         child: TextButton(
//           child: const Text('to three'),
//           onPressed: () {
//             Navigator.of(context).push(
//               MaterialPageRoute<void>(builder: (_) => Three(), maintainState: false),
//             );
//           },
//         ),
//       ),
//     ];
//   }

//   @override
//   void init() {}

//   @override
//   void rebuild() {}

//   @override
//   Future<Toast<bool>> Function(PopResult? result) get whenPop {
//     return (PopResult? result) async {
//       return showToast<bool>(text: 'ddd', returnValue: true);
//     };
//   }
// }

class Three extends StatefulWidget {
  @override
  _ThreeState createState() => _ThreeState();
}

class _ThreeState extends State<Three> {
  @override
  void initState() {
    super.initState();
    print('three init');
  }

  @override
  Widget build(BuildContext context) {
    print('three build');
    return Center(
      child: TextButton(
        child: const Text('three'),
        onPressed: () {
          // Navigator.of(context).push(MaterialPageRoute<void>(builder: (_) => Four()));
        },
      ),
    );
  }
}

class Four extends StatefulWidget {
  @override
  _FourState createState() => _FourState();
}

class _FourState extends State<Four> {
  @override
  void initState() {
    super.initState();
    print('four init');
  }

  @override
  Widget build(BuildContext context) {
    print('four build');
    return Center(
      child: TextButton(
        child: const Text('four'),
        onPressed: () {},
      ),
    );
  }
}
