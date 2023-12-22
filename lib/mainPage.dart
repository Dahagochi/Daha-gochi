// 코드 편집자 : 정승원

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'character.dart';
import 'package:primer_progress_bar/primer_progress_bar.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';
import 'bucketService.dart';
import "dart:math";



class MainPage extends StatefulWidget{

  @override
  State createState() => MainPageState();
}

class MainPageState extends State<MainPage> {

  SharedPreferences? prefs;
  List<Segment> segments = [Segment(value: 80, color: Colors.green, label: Text("Done"), valueLabel: Text('123 / 150'))];   //temp value
  List<Bucket> todayList = [];
  // MyCharacter character;

  _checkFirstOpenOfMonth() async {
    prefs = await SharedPreferences.getInstance();

    // Get the current month and year
    DateTime now = DateTime.now();
    String currentMonthYear = DateFormat('yyyy-MM').format(now);

    // Get the stored month and year
    String? storedMonthYear = prefs!.getString('lastOpenMonthYear');

    // If it's the first open or a new month, show an alert

    //if (storedMonthYear == null || storedMonthYear != currentMonthYear) {
    if (1==1) {  // for debug
      // MatureCharacter c = MatureCharacter();
      // c.addCharacter(character);

      //MyCharacter character = MyCharacter(name:'tempname', birth:currentMonthYear);

      _showAlert();
      prefs!.setString('lastOpenMonthYear', currentMonthYear);  // 저장된 날짜 최신화

    }
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
  void initState() {
    super.initState();
    // _checkFirstOpen();     // 도움말 dialog 표시하기
    _checkFirstOpenOfMonth();      // _checkFirstOpen()함수의 기능 통합

    // MyCharacter character = ;    // character 불러오기
  }

  @override
  Widget build(BuildContext context) {
    DateTime now = DateTime.now();
    return Consumer<BucketService>(
        builder: (context, bucketService, child) {
          todayList = bucketService.getByDate(now);
          return Scaffold(
            backgroundColor: Colors.lightGreen[100],
            body: Column(
              children: [

                //// 계획 리스트 컨테이너 ////

                Expanded(
                  flex: 3,
                  child: Container(
                    height: 150,
                    width: double.infinity,
                    padding: EdgeInsets.all(10),
                    margin: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.lightGreen[100],
                      //border: Border.all(color: Colors.black),
                    ),


                    child: todayList.isEmpty
                      ? Center(
                        child: ElevatedButton(
                          child: Text('오늘의 계획을 세워보세요!'),
                          onPressed: () {Navigator.pushNamed(context, '/calendar');},         //캘린더 페이지로 이동,
                        ),
                      )
                        :ListView.separated( //// 계획리스트 및 체크박스 표시   /// 리스트길이==0일경우 캘린더이동버튼표시
                      padding: const EdgeInsets.all(8),
                      // itemCount: 4, // temp for debug
                      itemCount: todayList.length,
                      itemBuilder: (BuildContext context, int index) {
                        // 역순으로 보여주기
                        int i = todayList.length - index - 1;
                        Bucket bucket = todayList[i];
                        return ListTile(
                          /// text
                          title: Text(
                            bucket.text,
                            style: TextStyle(
                              fontSize: 24,
                              color: Colors.black,
                            ),
                          ),

                          /// createdAt
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Checkbox(
                                  value: bucket.isDone,
                                  onChanged: (value){
                                    bucket.isDone=!bucket.isDone;

                                    setState(() {});
                                  }
                              ),
                            ],
                          ),
                        );
                      },
                      separatorBuilder: (BuildContext context, int index) => const Divider(),
                    ),
                  ),
                ),

                //// 현재 키우고있는 캐릭터와 캐릭터의 정보를 표시할 컨테이너 (화면 하단에 정렬) ////

                Expanded(
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
                            child: Image.asset('assets/images/0.png'),
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
                                        // child: Text('${(character.comments..shuffle()).first;}'),
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
                                            segments: segments, maxTotalValue: 100),
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
                ),
              ],
            ),
          );
  },);}
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