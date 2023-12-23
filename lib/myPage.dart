import 'package:dahagochi/buttons/button_AppInfo.dart';
import 'package:dahagochi/buttons/button_AppManual.dart';
import 'package:dahagochi/buttons/button_DevInfo.dart';
import 'package:dahagochi/buttons/button_PushAlarmSetting.dart';
import 'package:flutter/material.dart';

class MyPage extends StatefulWidget {

  @override
  _MyPageState createState() => _MyPageState();

}

class _MyPageState extends State<MyPage> {

  final double ButtonHeight = 70;
  final double ButtonWidth = 400;
  //각각 버튼 높이와 너비
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                AppManual(),
                SizedBox(
                  height: ButtonHeight / 2,
                  width: ButtonWidth,
                ),
                PushAlarmSetting(),
                DevInfo(),
                AppInfo(),
              ],
            ),
          ],
        ));
  }
}
