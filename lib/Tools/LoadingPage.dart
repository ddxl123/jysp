import 'package:flutter/material.dart';

class LoadingPage extends StatefulWidget {
  @override
  _LoadingPageState createState() => _LoadingPageState();
}

class _LoadingPageState extends State<LoadingPage> {
  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      child: Material(
        child: Container(
          width: 100,
          height: 100,
          color: Colors.red,
          child: Text("loading..."),
        ),
      ),
    );
  }
}
