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
                backgroundColor: Colors.amberAccent,
                title: Text(
                  "App. info",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                  ),
                ),
                content: Text(
                  "app info contents",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                  ),
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
              borderRadius: BorderRadius.vertical(bottom: Radius.circular(30))),
          backgroundColor: Colors.amber,
          foregroundColor: Colors.white,
        ),
        child: Text("App info"),
      ),
    );
  }
}
