import 'package:flutter/material.dart';
import 'package:time_picker_spinner/time_picker_spinner.dart';
import 'package:dahagochi/buttons/button_PushAlarmSetting.dart';


DateTime alarmTime = DateTime(1999, 12, 31, 9, 0);
DateTime tmpTime = DateTime(1999, 12, 31, 9, 0);

class AlarmTimeSet extends StatefulWidget {
  final Function callback;

  const AlarmTimeSet({
    required this.callback,
    super.key
    });

  @override
  State<AlarmTimeSet> createState() => _AlarmTimeSetState();
}

class _AlarmTimeSetState extends State<AlarmTimeSet> {

  @override
  Widget build(context) {
    return AlertDialog(
      backgroundColor: Colors.amberAccent,
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            child: const Text(
              'Time Set',
              style: TextStyle(
                color: Colors.white,
              ),
            ),
          ),
          TimePickerSpinner(
            time: alarmTime,
            is24HourMode: false,
            itemHeight: 80,
            normalTextStyle: const TextStyle(
              color: Colors.white,
              fontSize: 24,
            ),
            highlightedTextStyle:
                const TextStyle(fontSize: 24, color: Colors.black),
            isForce2Digits: true,
            onTimeChange: (time) {
              setState(() {
                tmpTime = time;
              });
            },
          )
        ],
      ),
      actions: [
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text(
                'cancel',
                style: TextStyle(color: Colors.white),
              ),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  alarmTime=tmpTime;
                });
                widget.callback;
                Navigator.of(context).pop();
              },
              child: const Text(
                'apply',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        )
      ],
    );
  }
}
