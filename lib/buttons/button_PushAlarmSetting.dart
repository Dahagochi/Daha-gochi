//작성자:장이건
import 'package:flutter/material.dart';
import 'package:dahagochi/Alarm_Time_Set.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
  String _AlarmHalf = alarmTime.hour >= 12 ? 'PM' : 'AM';
  //알람 세팅 요소(표시용 임시 변수)

  String PushAlarmStatusText = 'Push Alarm Unabled';
  String PushAlarmSoundStatusText = 'Alarm sound Unabled';
  String PushAlarmVibStatusText = 'Alarm Vib Unabled';
  String PushAlarmHourText = '0';
  String PushAlarmMinText = '0';
  String PushAlarmhalfText = 'AM';
  //알람 세팅 표시용 텍스트

  Map<String, dynamic> AlarmSetting = {}; //알람 세팅 요소(진)

  bool isInList(List<dynamic>myList, dynamic value){
    return myList.contains(value);
  }

  late SharedPreferences _prefs;

   Future<void> resetData(Map<String, dynamic> AlarmSetting) async {//알람 정보 초기화(최초 접속시 1회)
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('AlarmOn');
    await prefs.remove('AlarmSound');
    await prefs.remove('AlarmVib');
    await prefs.remove('AlarmHour');
    await prefs.remove('AlarmMin');
    await prefs.remove('AlarmtimeHalf');
  }


  Future<void> saveData(Map<String, dynamic> AlarmSetting) async {//알람 정보 modify
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('AlarmOn', AlarmSetting["AlarmOn"]);
    await prefs.setBool('AlarmSound', AlarmSetting["AlarmSound"]);
    await prefs.setBool('AlarmVib', AlarmSetting["AlarmVib"]);
    await prefs.setInt('AlarmHour', AlarmSetting["AlarmHour"]);
    await prefs.setInt('AlarmMin', AlarmSetting["AlarmMin"]);
    await prefs.setString('AlarmtimeHalf', AlarmSetting["AlarmtimeHalf"]);
  }

  Future<Map<String, dynamic>> readData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    Map<String, dynamic> alarmSettings = {
      'AlarmOn': prefs.getBool('AlarmOn') ?? false,
      'AlarmSound': prefs.getBool('AlarmSound') ?? false,
      'AlarmVib': prefs.getBool('AlarmVib') ?? false,
      'AlarmHour': prefs.getInt('AlarmHour') ?? 0,
      'AlarmMin': prefs.getInt('AlarmMin') ?? 0,
      'AlarmtimeHalf': prefs.getString('AlarmtimeHalf') ?? 'AM',
    };
    return alarmSettings;
  }

  void UpdateAlarmSettingText() {
    setState(() {
      PushAlarmStatusText = AlamOn ? 'Push Alarm abled' : 'Push Alarm Unabled';
      PushAlarmSoundStatusText =
          _AlarmSound ? 'Alarm sound abled' : 'Alarm sound Unabled';
      PushAlarmVibStatusText =
          _AlarmVib ? 'Alarm Vib abled' : 'Alarm Vib Unabled';
      _AlarmHour = alarmTime.hour;
      _AlarmMin = alarmTime.minute;
      _AlarmHalf = alarmTime.hour >= 12 ? 'PM' : 'AM';
      PushAlarmHourText = _AlarmHour >= 12
          ? (_AlarmHour - 12).toString()
          : _AlarmHour.toString();
      PushAlarmMinText =
          _AlarmMin >= 10 ? _AlarmMin.toString() : '0' + _AlarmMin.toString();
      PushAlarmhalfText = _AlarmHalf;
    });
  } //알람 세팅 텍스트 갱신

  void initState() {
    super.initState();
    // Load saved data when the widget initializes
    readData().then((alarmSettings) {
      setState(() {
        AlarmSetting = alarmSettings;
        alarmTime=DateTime(1999, 12, 29, AlarmSetting['AlarmHour'],AlarmSetting['AlarmMin']);
      });
      UpdateAlarmSettingText();
    });
  }

  @override
  Widget build(BuildContext context) {
    DialogState dialogState = Provider.of<DialogState>(context);

    if (dialogState.isDialogClosed) {
      UpdateAlarmSettingText();
    }

    return Container(
      height: 70,
      width: 400,
      child: ElevatedButton(
        onPressed: () {
          Provider.of<DialogState>(context, listen: false).setDialogClosed(false);

          setState(() {
            //initialize
            AlamOn = AlarmSetting["AlarmOn"];
            _AlarmSound = AlarmSetting["AlarmSound"];
            _AlarmVib = AlarmSetting["AlarmVib"];
          });

          UpdateAlarmSettingText();
          //readData();

          showDialog(
            //팝업창을 띄우는 위젯
            barrierDismissible: false,
            context: context,
            builder: (BuildContext cxt) {
              //dialog widget
              return StatefulBuilder(
                  builder: (BuildContext context, StateSetter setState) {
                return AlertDialog(
                  backgroundColor: Colors.lightGreen,
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
                              activeColor: Colors.lightGreen,
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
                              color: AlamOn ? Colors.white : Colors.lightGreen,
                              fontSize: 15,
                            ),
                          ),
                          const Spacer(),
                          Visibility(
                            visible: AlamOn,
                            child: Switch(
                                inactiveThumbColor:
                                    AlamOn ? Colors.white : Colors.lightGreen,
                                inactiveTrackColor: AlamOn
                                    ? Color.fromARGB(255, 61, 55, 36)
                                    : Colors.lightGreen,
                                activeTrackColor: Colors.white,
                                activeColor: Colors.lightGreen,
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
                              color: AlamOn ? Colors.white : Colors.lightGreen,
                              fontSize: 15,
                            ),
                          ),
                          const Spacer(),
                          Visibility(
                            visible: AlamOn,
                            child: Switch(
                                inactiveThumbColor:
                                    AlamOn ? Colors.white : Colors.lightGreen,
                                inactiveTrackColor: AlamOn
                                    ? Color.fromARGB(255, 61, 55, 36)
                                    : Colors.lightGreen,
                                activeTrackColor: Colors.white,
                                activeColor: Colors.lightGreen,
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
                              color: AlamOn ? Colors.white : Colors.lightGreen,
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
                              color: AlamOn ? Colors.white : Colors.lightGreen,
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
                                  backgroundColor: Colors.lightGreen,
                                  foregroundColor: Colors.white,
                                ),
                                onPressed: () {
                                  showDialog(
                                      barrierDismissible: false,
                                      context: context,
                                      builder: (BuildContext Context) {
                                        return AlarmTimeSet();
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
                            AlarmSetting["AlarmtimeHalf"] = _AlarmHalf;
                            saveData(AlarmSetting);
                            Navigator.of(context).pop();
                            int minu= AlarmSetting['AlarmMin'];
                            print(minu);
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
          backgroundColor: Colors.lightGreen,
          foregroundColor: Colors.white,
        ),
        child: Text("Push Alarm Setting"),
      ),
    );
  }
}
