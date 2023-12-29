// 코드 편집자 : 정승원

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';
import 'myCharacter.dart';
import 'package:primer_progress_bar/primer_progress_bar.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';
import 'bucketService.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'auth_service.dart';
import 'todayBucketList.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State createState() => MainPageState();
}

class MainPageState extends State<MainPage> {
  FirebaseFirestore db = FirebaseFirestore.instance;
  SharedPreferences? prefs;
  //
  // DateTime selectedDate = DateTime.now();

  //List<Segment> segments = [Segment(value: 80, color: Colors.green, label: Text("Progress"), valueLabel: Text('123 / 150'))];   //temp value
  // MyCharacter character;

  void _checkFirstOpen() async {
    // 앱 설치 후 첫 접속 or 이번 달 첫 접속인 경우 dialog표시, 아닌 경우 서버에서 캐릭터 불러오기
    final authService = context.read<AuthService>();
    final user = authService.currentUser()!;
    prefs = await SharedPreferences.getInstance();

    // Get the current month and year
    DateTime now = DateTime.now();
    String currentMonthYear = DateFormat('yyyy-MM').format(now);

    // Get the stored month and year
    String? storedMonthYear = prefs!.getString('lastOpenMonthYear');

    // If it's the first open or a new month, show an alert

    // if (storedMonthYear == null) {
    if (storedMonthYear == null) {
      // temp line for debug
      _showManual();
    }

    MyCharacter character = MyCharacter();
    // if (storedMonthYear != currentMonthYear){
    if (storedMonthYear != currentMonthYear) {
      // temp line for debug
      _showAlert(character);
      prefs!.setString('lastOpenMonthYear', currentMonthYear); // 저장된 날짜 최신화

      character.createMyCharacter(user.uid);
    } else {
      character.read(user.uid);
    }
  }

  _showManual() {
    final ManuImages = [
      'assets/images/calendarManual.png',
      'assets/images/mainPageManual.png',
      'assets/images/hallOfFameManual.png'
    ];
    int _ManuIndex = 0;
    String AppManualButtonText1 = 'close';
    String AppManualButtonText2 = 'next';
    showDialog(
      //팝업창을 띄우는 위젯
      barrierDismissible: false, //다른데 클릭해도 위젯 안 사라짐
      context: context,
      builder: (BuildContext cxt) {
        //dialog widget
        return StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
          // 이거 없으면 alertDialogue에서 갱신이 닫을때만 적용
          return AlertDialog(
            backgroundColor: Colors.lightGreen,
            title: Text(
              "App Manual",
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
              ),
            ),
            content: Column(
              children: [
                Image.asset(ManuImages[_ManuIndex]),
                SizedBox(
                  height: 10,
                ),
                AnimatedSmoothIndicator(
                  activeIndex: _ManuIndex,
                  count: ManuImages.length,
                  effect: WormEffect(
                    dotColor: Colors.lightGreen,
                    activeDotColor: Colors.white,
                  ),
                ),
              ],
            ),
            actions: [
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () {
                      if (_ManuIndex == 0) {
                        Navigator.of(context).pop();
                      } else {
                        _ManuIndex -= 1;
                        setState(() {
                          if (_ManuIndex == 0) {
                            AppManualButtonText1 = 'close';
                          } else {
                            AppManualButtonText1 = 'prev';
                            if (_ManuIndex == ManuImages.length - 2) {
                              AppManualButtonText2 = 'next';
                            }
                          }
                        });
                      }
                    },
                    child: Text(
                      AppManualButtonText1,
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      if (_ManuIndex == ManuImages.length - 1) {
                        Navigator.of(context).pop();
                      } else {
                        _ManuIndex += 1;
                        setState(() {
                          if (_ManuIndex == ManuImages.length - 1) {
                            AppManualButtonText2 = 'close';
                          } else {
                            AppManualButtonText2 = 'next';
                            if (_ManuIndex == 1) {
                              AppManualButtonText1 = 'prev';
                            }
                          }
                        });
                      }
                    },
                    child: Text(
                      AppManualButtonText2,
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
  }

  _showAlert(dynamic document) {
    final doc = document[0]; //어차피 검색후 반환되는 게 1개밖에 안될테니
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("새로운 친구!"),
          content: Container(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Center(
                  child: Image.network(
                    doc.get('image'),
                    width: 200,
                    height: 200,
                  ),
                ),
                Text("이번 달도 계획을 실천하고"),
                Text("친구와 함께 성장해 보아요!"),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text("OK"),
            ),
          ],
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();
    _checkFirstOpen();
  }
  CalendarFormat calendarFormat = CalendarFormat.month;

  // 선택된 날짜
  DateTime selectedDate = DateTime.now();

  // create text controller
    @override
  Widget build(BuildContext context) {
    final authService = context.read<AuthService>();
    final user = authService.currentUser()!;
    return Consumer<BucketService>(
      builder: (context, bucketService, child) {
        return Scaffold(
          // 키보드가 올라올 때 화면 밀지 않도록 만들기(overflow 방지)
          resizeToAvoidBottomInset: false,
          body: SafeArea(
            child: Container(
              color: Colors.lightGreen[100],
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: 25),
                child: Column(
                  children: [
                    /// 달력
                    Container(
                      alignment: Alignment.centerLeft,
                      padding: EdgeInsets.only(top: 40, bottom: 20),
                      child: const Text(
                        "캘린더",
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    SizedBox(height: 5,),
                    Expanded(
                        child: TodayBucketList(selectedDate: selectedDate),
                    ),
                    CharacterState(user: user)
                  ],
                ),
              ),
            ),
          ),

          /// Floating Action Button
        );
      },
    );
  }
  }


class CharacterState extends StatelessWidget {
  const CharacterState({
    super.key,
    required this.user,
  });

  final User user;

  @override
  Widget build(BuildContext context) {
    return Consumer<MyCharacter>(
      builder: (context, character, child) {
        return FutureBuilder<QuerySnapshot>(
            future: character.read(user.uid),
            builder: (context, snapshot) {
              try{
                final documents = snapshot.data?.docs ?? [];
                print("ㅋㅋ");
                print(documents);
              final doc = documents[0];
              return Container(
                height: 150,
                width: double.infinity,
                margin: EdgeInsets.only(bottom: 10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  color: Colors.lightGreen[100],
                  border: Border.all(color: Colors.black),
                ),
                child: Row(
                  children: [
                    Container(
                      // 캐릭터 이미지 표시  (중앙 정렬)
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.lightGreen,
                        border: Border.all(color: Colors.black),
                      ),
                      margin: EdgeInsets.symmetric(horizontal: 10),
                      width: 120,
                      height: 120,
                      child: Image.network(doc.get('image')),
                    ),
                    Expanded(
                      child: Container(
                        // 대사, 성장도 게이지 표시  (중앙 정렬)
                        child: Column(
                          children: [
                            Expanded(
                              // flex: 2,
                              child: Container(
                                /// 캐릭터 대사 컨테이너(Text위젯으로 변경예정)
                                height: 30,
                                width: double.infinity,
                                padding: EdgeInsets.all(5),
                                margin: EdgeInsets.all(5),
                                decoration: BoxDecoration(
                                  // shape: ,
                                  color: Colors.lightGreen,
                                  border: Border.all(color: Colors.black),
                                ),
                                child: Center(
                                  // child: Text('${(doc.get("comments")..shuffle()).first}'),   //접속할 때마다 캐릭터 코멘트 랜덤 출력
                                  child: Text(
                                      doc.get('comments')), // temp for debug
                                ),
                              ),
                            ),
                            Expanded(
                              // flex: 3,
                              child: SizedBox(
                                /// 성장도 게이지 컨테이너(progress bar class구현)
                                height: 100,
                                width: double.infinity,
                                // padding: EdgeInsets.all(5),
                                // margin: EdgeInsets.all(5),
                                // decoration: BoxDecoration(
                                //   color: Colors.lightGreen,
                                //   border: Border.all(color: Colors.black),
                                // ),
                                child: Center(
                                  child: PrimerProgressBar(segments: [
                                    Segment(
                                        value: doc.get('progress'),
                                        color: Colors.green,
                                        label: Text("성장도"),
                                        valueLabel: Text(
                                            '${doc.get("progress")} / ${doc.get("maxProgress")}')

                                      /// todo : progress / maxProgress
                                    )
                                  ], maxTotalValue: doc.get('maxProgress')),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              );}
              catch(e){
                return Text("$e");
              }

            });
      },
    );
  }
}

// class growthRate{
//
//   List<Segment> segments = [
//     Segment(
//         valueLabel: Text("123"),
//         value: 80,
//         color: Colors.purple,
//         label: Text("Done"),
//     ),
//     // Segment(value: 14, color: Colors.deepOrange, label: Text("In progress")),
//     // Segment(value: 6, color: Colors.green, label: Text("Open")),
//   ];
//
//   Widget build(BuildContext context) {
//     final progressBar = PrimerProgressBar(segments: segments, maxTotalValue: 100);
//     return Scaffold(
//       body: Center(
//         child: Padding(
//           padding: EdgeInsets.all(5),
//           child: progressBar,
//         ),
//       ),
//     );
//   }
// }
