//작성자:장이건
import 'package:flutter/material.dart';

class DevInfo extends StatelessWidget {
  Widget build(BuildContext ctx) {
    return Container(
      height: 70,
      width: 400,
      child: ElevatedButton(
        onPressed: () {
          showDialog(
            //팝업창을 띄우는 위젯
            context: ctx,
            builder: (BuildContext cxt) {
              //dialog widget
              return AlertDialog(
                backgroundColor: Colors.lightGreen,
                title: Text(
                  "Dev info",
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                  "중앙대학교 컴퓨터예술학과 20204656김지혜",
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
                Text(
                  "중앙대학교 수학과 20193711정승원",
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
                Text(
                  "중앙대학교 AI학과 20222020장이건",
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 30,),
                Text(
                  "For 모바일프로그래밍",
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
                  ],
                ),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(ctx).pop();
                    },
                    child: Text(
                      "close",
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              );
            },
          );
        },
        style: ElevatedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.zero,
          ),
          backgroundColor: Colors.lightGreen,
          foregroundColor: Colors.white,
        ),
        child: Text("Dev. info"),
      ),
    );
  }
}
