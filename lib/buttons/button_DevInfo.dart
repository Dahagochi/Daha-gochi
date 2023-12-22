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
                backgroundColor: Colors.amberAccent,
                title: Text(
                  "Dev info",
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
                content: Text(
                  "manual content",
                  style: TextStyle(
                    color: Colors.white,
                  ),
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
          backgroundColor: Colors.amber,
          foregroundColor: Colors.white,
        ),
        child: Text("Dev. info"),
      ),
    );
  }
}
