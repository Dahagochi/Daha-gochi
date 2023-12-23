import 'package:flutter/material.dart';

class AppInfo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
        height: 70,
        width: 400,
        child: ElevatedButton(
          onPressed: () {
            showDialog(
              //팝업창을 띄우는 위젯
              context: context,
              builder: (BuildContext cxt) {
                //dialog widget
                return AlertDialog(
                  backgroundColor: Colors.lightGreen,
                  title: Text(
                    "App. info",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                    ),
                  ),
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "앱 이름: 다하고치",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 15,
                        ),
                      ),
                      Text(
                        "앱 버전: 1.0.0",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 15,
                        ),
                      ),
                    ],
                  ),
                  actions: [
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
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
                borderRadius:
                    BorderRadius.vertical(bottom: Radius.circular(30))),
            backgroundColor: Colors.lightGreen,
            foregroundColor: Colors.white,
          ),
          child: Text("App Info"),
        ));
  }
}
