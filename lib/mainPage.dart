import 'package:flutter/material.dart';
//승원이 메인 페이지
class MainPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.amber[100],
      body: Center(
        child: Text("메인페이지", textScaleFactor: 3.0),
      ),
    );
  }
}