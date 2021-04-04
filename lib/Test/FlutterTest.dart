// import 'package:dio/dio.dart';
// import 'package:flutter/material.dart';
// import 'package:jysp/G/G.dart';
// import 'package:jysp/G/GHttp.dart';
// import 'package:jysp/Tools/TDebug.dart';

// class FlutterTest extends StatefulWidget {
//   @override
//   _FlutterTestState createState() => _FlutterTestState();
// }

// class _FlutterTestState extends State<FlutterTest> {
//   @override
//   Widget build(BuildContext context) {
//     return Center(
//       child: TextButton(
//         child: Text("data"),
//         onPressed: () {
//           GHttp.dio = Dio(BaseOptions(baseUrl: "http://jysp.free.idcfengye.com/"));
//           dLog(() => G.http.dio.options.headers);
//           G.http.dio.request(
//             "api/test",
//             options: Options(method: "GET"),
//             onReceiveProgress: (a, b) {
//               print("a:$a,b:$b");
//             },
//           ).then(
//             (value) {
//               dLog(() => "value:", () => value);
//               dLog(() => "headers:", () => value.headers.map);
//             },
//           ).catchError(
//             (onErr) {
//               dLog(() => "onErr:", () => onErr);
//             },
//           );
//         },
//       ),
//     );
//   }
// }
