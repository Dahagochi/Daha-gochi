//작성자:김지혜
import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:dahagochi/bucketEditPage.dart';
import 'package:dahagochi/bucketService.dart';
import 'package:dahagochi/todayBucketList.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/intl.dart';

import 'alertDialog.dart';
import 'auth_service.dart';

class CalendarPage extends StatefulWidget {
  @override
  State<CalendarPage> createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  CalendarFormat calendarFormat = CalendarFormat.month;

  // 선택된 날짜
  DateTime selectedDate = DateTime.now();

  // create text controller
  TextEditingController createTextController = TextEditingController();

  // update text controller
  TextEditingController updateTextController = TextEditingController();
  TextEditingController cycleTextController = TextEditingController();

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
                    showCalender(bucketService),
                    SizedBox(height: 5,),
                    Expanded(
                        child: TodayBucketList(selectedDate: selectedDate)
                    ),
                  ],
                ),
              ),
            ),
          ),

          /// Floating Action Button
          floatingActionButton: FutureBuilder<QuerySnapshot>(
            future: bucketService.read(user.uid, selectedDate),
            builder: (context, snapshot) {
              final documents = snapshot.data?.docs ?? [];
              return FloatingActionButton(
                backgroundColor: Colors.lightGreen,
                elevation: 0,
                child: Icon(Icons.create, color: Colors.white),
                onPressed: () {
                  createTextController.text = '';
                  if (documents.length == 5) {
                    AlertDialogUtils.showFlutterDialog(context);
                  } else {
                    showCreateDialog(bucketService);
                  }
                },
              );
            },
          ),
        );
      },
    );
  }

  FutureBuilder<QuerySnapshot<Object?>> showCalender(
      BucketService bucketService) {
    final user = context.read<AuthService>().currentUser();
    return FutureBuilder<QuerySnapshot>(
      future: bucketService.read(user!.uid, selectedDate),
      builder: (context, snapshot) {
        return Container(
          child: Expanded(
            child: Container(
              padding: EdgeInsets.only(top: 0, left: 20, right: 20, bottom: 20),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10), color: Colors.white),
              height: MediaQuery.of(context).size.height * 0.47,
              child: TableCalendar(
                locale: 'ko-KR',
                shouldFillViewport: true,
                headerStyle: const HeaderStyle(
                  headerPadding: const EdgeInsets.symmetric(vertical: 4.0),
                  titleCentered: true,
                  formatButtonVisible: false,
                ),
                firstDay: DateTime.utc(2010, 10, 16),
                lastDay: DateTime.utc(2030, 3, 14),
                focusedDay: selectedDate,
                calendarFormat: calendarFormat,
                onFormatChanged: (format) {
                  // 달력 형식 변경
                  setState(() {
                    calendarFormat = format;
                  });
                },
                calendarStyle: CalendarStyle(
                  // today 색상 연하게, selectedDay는 진하게
                  selectedDecoration: BoxDecoration(
                    color: Colors.lightGreen[400],
                    shape: BoxShape.circle,
                  ),
                  todayTextStyle: const TextStyle(color: Colors.lightGreen),
                  todayDecoration: BoxDecoration(
                    color: Colors.lightGreen[100],
                    shape: BoxShape.circle,
                  ),
                ),
                selectedDayPredicate: (day) {
                  return isSameDay(selectedDate, day);
                },
                onDaySelected: (_, focusedDay) {
                  setState(() {
                    selectedDate = focusedDay;
                  });
                },
              ),
            ),
          ),
        );
      },
    );
  }

  /// 작성 다이얼로그 보여주기
  void showCreateDialog(BucketService bucketService) {
    final authService = context.read<AuthService>();
    final user = authService.currentUser()!;
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("할 일 작성"),
          content: TextField(
            controller: createTextController,
            autofocus: true,
            // 커서 색상
            //cursorColor: Colors.amber,
            decoration: InputDecoration(
              hintText: "이 날 꼭 해야 할 일이 있나요?",
              // 포커스 되었을 때 밑줄 색상F
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.lightGreen),
              ),
            ),
            onSubmitted: (_) {
              // 엔터 누를 때 작성하기
              if (createTextController.text.isNotEmpty) {
                bucketService.create(
                    createTextController.text, user.uid, selectedDate);
              }
              Navigator.pop(context);
            },
          ),
          actions: [
            /// 취소 버튼
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(
                "취소",
                style: TextStyle(color: Colors.lightGreen),
              ),
            ),

            /// 작성 버튼
            TextButton(
              onPressed: () {
                if (createTextController.text.isNotEmpty) {
                  bucketService.create(
                      createTextController.text, user.uid, selectedDate);
                }
                Navigator.pop(context);
              },
              child: Text(
                "작성",
                style: TextStyle(color: Colors.lightGreen),
              ),
            ),
          ],
        );
      },
    );
  }
}