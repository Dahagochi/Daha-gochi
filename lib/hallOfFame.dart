import 'package:flutter/material.dart';

class HallOfFame extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.amber[100],
      body: Center(
        child: Text("명예의 전당", textScaleFactor: 3.0),
      ),
    );
  }
}