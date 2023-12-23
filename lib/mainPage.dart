// 코드 편집자 : 정승원

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'character.dart';
import 'package:primer_progress_bar/primer_progress_bar.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';
import 'bucketService.dart';
import "dart:math";
import 'package:firebase_auth/firebase_auth.dart';
import 'auth_service.dart';
import 'package:dahagochi/buttons/button_AppManual.dart';
import 'todayBucketList.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';


class MainPage extends StatefulWidget{

  @override
  State createState() => MainPageState();
}

class MainPageState extends State<MainPage> {

  FirebaseFirestore db = FirebaseFirestore.instance;
  SharedPreferences? prefs;
  //List<Segment> segments = [Segment(value: 80, color: Colors.green, label: Text("Progress"), valueLabel: Text('123 / 150'))];   //temp value

  void _checkFirstOpen() async {         // 앱 설치 후 첫 접속 or 이번 달 첫 접속인 경우 dialog표시, 아닌 경우 서버에서 캐릭터 불러오기
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
    if (1==1){  // temp line for debug
      _showManual();
    }

    // if (storedMonthYear != currentMonthYear){
    if(1==1){ // temp line for debug
      _showAlert();
      prefs!.setString('lastOpenMonthYear', currentMonthYear);  // 저장된 날짜 최신화
      MyCharacter character = MyCharacter();
      character.createMyCharacter(character, user.uid);

    } else{
      ///todo : load character from server
    }
  }

  _showManual(){

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
                backgroundColor: Colors.amberAccent,
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
                        dotColor: Colors.amber,
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

  _showAlert() {
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
                  child: Image.asset('assets/images/0.png', width: 200, height: 200,),
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
  void initState() {           // 앱을 실행하여 mainPage에 접속할 때, 유저가 최근 접속했던 날짜 체크
    super.initState();
    _checkFirstOpen();
  }

  @override
  Widget build(BuildContext context) {
    final authService = context.read<AuthService>();
    final user = authService.currentUser()!;


    DateTime now = DateTime.now();
    return Scaffold(
            backgroundColor: Colors.lightGreen[100],
            body: Column(
              children: [
                Consumer<BucketService>(                         //// 계획 리스트 컨테이너 ///
                  builder: (context, bucketService, child) {
                  //todayList = bucketService.getByDate(now);
                  return FutureBuilder(
                      future: bucketService.read(user.uid, now),
                      builder: (context, snapshot) {
                        final documents =
                        snapshot.data?.docs ?? []; // 문서들 가져오기
                        if (documents.isEmpty) {
                        return Center(child: Text("버킷 리스트를 작성해주세요!"));
                        }
                        return Expanded(
                        flex: 3,
                        child: TodayBucketList(selectedDate: now),                         /// todo : mainPage에 표시 bugfix
                        );
                       );
                    }
                ),

                 //// 현재 키우고있는 캐릭터와 캐릭터의 정보를 표시할 컨테이너 (화면 하단에 정렬) ////
                Consumer<MyCharacter>(
                  builder: (context, character, child){
                    CollectionReference myCharacterRef = db.collection('myCharacterRef');
                    DocumentReference docRef = myCharacterRef.doc('uid');
                    return FutureBuilder<QuerySnapshot>(
                        future: myCharacterRef
                                .where('uid', isEqualTo: user.uid)
                                .where('progressIng', isEqualTo: character.progressIng)
                                .get(),
                        // future: docRef.get(''),
                        builder: (context, snapshot){
                          final documents = snapshot.data?.docs ?? [];
                          // print('ll${documents.length}');   // for debug
                          //final doc = documents[0];
                          // if (documents.isEmpty) {
                          //   return Center(child: Text("NULL"));
                          // }
                          return Expanded(
                              flex: 1,
                              child: Container(
                                height: 150,
                                width: double.infinity,
                                padding: EdgeInsets.all(10),
                                margin: EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5),
                                  color: Colors.lightGreen[100],
                                  border: Border.all(color: Colors.black),
                                ),
                                child: Row(
                                  children: [
                                    Container( // 캐릭터 이미지 표시  (중앙 정렬)
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: Colors.lightGreen,
                                        border: Border.all(color: Colors.black),
                                      ),
                                      margin: EdgeInsets.symmetric(horizontal: 10),
                                      width: 120,
                                      height: 120,
                                      child: Image.asset('assets/images/0.png'),         /// todo : level별 image
                                    ),
                                    Expanded(
                                      child: Container( // 대사, 성장도 게이지 표시  (중앙 정렬)
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
                                                  child: Text('오늘도 화이팅!'),        // temp for debug
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
                                                  child: PrimerProgressBar(
                                                      segments: [
                                                        Segment(
                                                            value: 80,
                                                            color: Colors.green,
                                                            label: Text("Progress"),
                                                            valueLabel: Text(
                                                                // '${doc.get("progress") / doc.get("maxProgress")}'
                                                                '123 / 150'
                                                            )    /// todo : progress / maxProgress
                                                        )
                                                      ],
                                                      maxTotalValue: 100
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              )
                          );
                        }
                    );

                  },
                ),

              ],
            ),
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