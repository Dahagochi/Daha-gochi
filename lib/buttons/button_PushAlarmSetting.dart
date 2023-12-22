import 'package:flutter/material.dart';
import 'package:dahagochi/Alarm_Time_Set.dart';

class PushAlarmSetting extends StatefulWidget {
  const PushAlarmSetting({super.key});

  @override
  State<PushAlarmSetting> createState() => _PushAlarmSettingState();
}

class _PushAlarmSettingState extends State<PushAlarmSetting> {
  bool AlamOn = false;
  bool _AlarmSound = false;
  bool _AlarmVib = false;
  int _AlarmHour = alarmTime.hour;
  int _AlarmMin = alarmTime.minute;
  String _AlarmHalf = alarmTime.hour>=12
    ?'PM'
    :'AM';
  //알람 세팅 요소(표시용 임시 변수)

  String PushAlarmStatusText = 'Push Alarm Unabled';
  String PushAlarmSoundStatusText = 'Alarm sound Unabled';
  String PushAlarmVibStatusText = 'Alarm Vib Unabled';
  String PushAlarmHourText = '0';
  String PushAlarmMinText = '0';
  String PushAlarmhalfText = 'AM';
  //알람 세팅 표시용 텍스트

  Map<String, dynamic> AlarmSetting = {
    "AlarmOn": false,
    "AlarmSound": false,
    "AlarmVib": false,
    "AlarmHour": 0,
    "AlarmMin": 0,
    "AlarmtimeHalf": 'AM'
  }; //알람 세팅 요소(진)

  void UpdateAlarmSettingText() {
    setState(() {
      PushAlarmStatusText = AlamOn ? 'Push Alarm abled' : 'Push Alarm Unabled';
      PushAlarmSoundStatusText =
          _AlarmSound ? 'Alarm sound abled' : 'Alarm sound Unabled';
      PushAlarmVibStatusText =
          _AlarmVib ? 'Alarm Vib abled' : 'Alarm Vib Unabled';
      _AlarmHour = alarmTime.hour;
      _AlarmMin = alarmTime.minute;
      _AlarmHalf = alarmTime.hour>=12
        ?'PM'
        :'AM';
      PushAlarmHourText = _AlarmHour>=12
      ?(_AlarmHour-12).toString()
      :_AlarmHour.toString();
      PushAlarmMinText = _AlarmMin>=10
        ?_AlarmMin.toString()
        :'0'+_AlarmMin.toString();
      PushAlarmhalfText = _AlarmHalf;

      print('updated');
    });
  } //알람 세팅 텍스트 갱신

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 70,
      width: 400,
      child: ElevatedButton(
        onPressed: () {
          setState(() {
            //initialize
            AlamOn = AlarmSetting["AlarmOn"];
            _AlarmSound = AlarmSetting["AlarmSound"];
            _AlarmVib = AlarmSetting["AlarmVib"];
          });

          UpdateAlarmSettingText();

          showDialog(
            //팝업창을 띄우는 위젯
            barrierDismissible: false,
            context: context,
            builder: (BuildContext cxt) {
              //dialog widget
              return StatefulBuilder(
                  builder: (BuildContext context, StateSetter setState) {
                return AlertDialog(
                  backgroundColor: Colors.amberAccent,
                  title: const Text(
                    "Push Alarm Setting",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                    ),
                  ),
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        children: [
                          Text(
                            PushAlarmStatusText,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 15,
                            ),
                          ),
                          const Spacer(),
                          Switch(
                              activeTrackColor: Colors.white,
                              activeColor: Colors.amber,
                              value: AlamOn,
                              onChanged: (value) {
                                setState(() {
                                  AlamOn = value ?? false;
                                  if (!AlamOn) {
                                    _AlarmSound = false;
                                    _AlarmVib = false;
                                  }
                                  UpdateAlarmSettingText();
                                });
                              }),
                        ],
                      ),
                      Row(
                        children: [
                          Text(
                            PushAlarmSoundStatusText,
                            style: TextStyle(
                              color: AlamOn ? Colors.white : Colors.amberAccent,
                              fontSize: 15,
                            ),
                          ),
                          const Spacer(),
                          Visibility(
                            visible: AlamOn,
                            child: Switch(
                                inactiveThumbColor:
                                    AlamOn ? Colors.white : Colors.amberAccent,
                                inactiveTrackColor: AlamOn
                                    ? Color.fromARGB(255, 61, 55, 36)
                                    : Colors.amberAccent,
                                activeTrackColor: Colors.white,
                                activeColor: Colors.amber,
                                value: _AlarmSound,
                                onChanged: (value) {
                                  if (AlamOn) {
                                    setState(() {
                                      _AlarmSound = value ?? false;
                                      UpdateAlarmSettingText();
                                    });
                                  }
                                }),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Text(
                            PushAlarmVibStatusText,
                            style: TextStyle(
                              color: AlamOn ? Colors.white : Colors.amberAccent,
                              fontSize: 15,
                            ),
                          ),
                          const Spacer(),
                          Visibility(
                            visible: AlamOn,
                            child: Switch(
                                inactiveThumbColor:
                                    AlamOn ? Colors.white : Colors.amberAccent,
                                inactiveTrackColor: AlamOn
                                    ? Color.fromARGB(255, 61, 55, 36)
                                    : Colors.amberAccent,
                                activeTrackColor: Colors.white,
                                activeColor: Colors.amber,
                                value: _AlarmVib,
                                onChanged: (value) {
                                  if (AlamOn) {
                                    setState(() {
                                      _AlarmVib = value ?? false;
                                      UpdateAlarmSettingText();
                                    });
                                  }
                                }),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Row(
                        children: [
                          Text(
                            "Alarm Time:",
                            style: TextStyle(
                              color: AlamOn ? Colors.white : Colors.amberAccent,
                            ),
                          ),
                          const Spacer(),
                          Text(
                            PushAlarmHourText +
                            " : " +
                            PushAlarmMinText +
                            " " +
                            PushAlarmhalfText,
                            style: TextStyle(
                              color: AlamOn ? Colors.white : Colors.amberAccent,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Row(
                        children: [
                          Spacer(),
                          Visibility(
                            visible: AlamOn,
                            child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.amber,
                                  foregroundColor: Colors.white,
                                ),
                                onPressed: () {
                                  UpdateAlarmSettingText();
                                  showDialog(
                                      barrierDismissible: false,
                                      context: context,
                                      builder: (BuildContext Context) {
                                        return AlarmTimeSet(callback: UpdateAlarmSettingText);
                                      });
                                },
                                child: Text(
                                  "modify",
                                  style: TextStyle(
                                    color: Colors.white,
                                  ),
                                )),
                          ),
                        ],
                      ),
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
                          child: Text(
                            "cancel",
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            AlarmSetting["AlarmOn"] = AlamOn;
                            AlarmSetting["AlarmSound"] = _AlarmSound;
                            AlarmSetting["AlarmVib"] = _AlarmVib;
                            AlarmSetting["AlarmHour"] = _AlarmHour;
                            AlarmSetting["AlarmMin"] = _AlarmMin;
                            Navigator.of(context).pop();
                          },
                          child: Text(
                            "apply",
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ],
                    ),
                  ],
                );
              });
            },
          );
        },
        style: ElevatedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
          ),
          backgroundColor: Colors.amber,
          foregroundColor: Colors.white,
        ),
        child: Text("Push Alarm Setting"),
      ),
    );
  }
}
