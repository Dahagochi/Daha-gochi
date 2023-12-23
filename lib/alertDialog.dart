// alertDialog.dart

import 'package:flutter/material.dart';

class AlertDialogUtils {
  static void showFlutterDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          title: Column(
            children: <Widget>[
              Text("주의!"),
            ],
          ),
          content: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Icon(
                Icons.warning, // 원하는 아이콘으로 변경
                size: 48.0, // 아이콘 크기 조절
                color: Colors.lightGreen, // 아이콘 색상 조절
              ),
              SizedBox(height: 16.0), // 아이콘과 텍스트 사이의 간격 조절
              Text("계획은 적당히!\n 하루 최대 5개까지만 세울 수 있어요.",textAlign: TextAlign.center,),
            ],
          ),
          actions: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.lightGreen,),
                  child: Center(child: Text("알겠어요")),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              ],
            ),
          ],
        );
      },
    );
  }
}