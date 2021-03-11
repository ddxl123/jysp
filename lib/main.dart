import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:jysp/G/G.dart';
import 'package:jysp/WillToHome.dart';
import 'package:provider/provider.dart';

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
    return MaterialApp(
      home: Material(
        key: G.globalKey,
        child: WillToHome(),
      ),
    );
  }
}

// class Test extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       children: [
//         Text(context.watch<Name>().count.toString()),
//         TextButton(
//             onPressed: () {
//               context.read<Name>().add();
//             },
//             child: Text("ssssss"))
//       ],
//     );
//   }
// }

// class Name extends ChangeNotifier {
//   int count = 0;
//   void add() {
//     count++;
//     notifyListeners();
//   }
// }
