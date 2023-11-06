import 'package:flutter/material.dart';

class Calender extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.amber[100],
      body: Center(
        child: Text("캘린더", textScaleFactor: 3.0),
      ),
    );
  }
}