//작성자:장이건
import 'package:flutter/material.dart';
import 'package:time_picker_spinner/time_picker_spinner.dart';
import 'package:provider/provider.dart';

DateTime alarmTime = DateTime(1999, 12, 31, 9, 0);
DateTime tmpTime = DateTime(1999, 12, 31, 9, 0);

class DialogState extends ChangeNotifier{
  bool _isDialogClosed = false;

  bool get isDialogClosed => _isDialogClosed;

  void setDialogClosed(bool value) {
    _isDialogClosed = value;
    notifyListeners();
  }
}

class AlarmTimeSet extends StatefulWidget {

  const AlarmTimeSet({super.key});

  @override
  State<AlarmTimeSet> createState() => _AlarmTimeSetState();
}

class _AlarmTimeSetState extends State<AlarmTimeSet> {

  @override
  Widget build(context) {
    return AlertDialog(
      backgroundColor: Colors.lightGreen,
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
                Navigator.of(context).pop();
                setState(() {
                  alarmTime=tmpTime;
                });

                Provider.of<DialogState>(context, listen: false).setDialogClosed(true);

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
