import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/intl.dart';

import 'bucketService.dart';

class Calender extends StatefulWidget {
  @override
  State<Calender> createState() => _CalenderState();
}

class _CalenderState extends State<Calender> {
  CalendarFormat calendarFormat = CalendarFormat.month;
  // 선택된 날짜
  DateTime selectedDate = DateTime.now();

  // create text controller
  TextEditingController createTextController = TextEditingController();

  // update text controller
  TextEditingController updateTextController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Consumer<BucketService>(
      builder: (context, bucketService, child) {
        List<Bucket> bucketList = bucketService.getByDate(selectedDate);
        return Scaffold(
          // 키보드가 올라올 때 화면 밀지 않도록 만들기(overflow 방지)
          resizeToAvoidBottomInset: false,
          body: SafeArea(
            child: Column(
              children: [
                /// 달력
                TableCalendar(
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
                  eventLoader: (date) {
                    // 각 날짜에 해당하는 bucketList 보여주기
                    return bucketService.getByDate(date);
                  },
                  calendarStyle: CalendarStyle(
                    // today 색상 제거
                    selectedDecoration: BoxDecoration(
                      color:Colors.amber[400],
                      shape:BoxShape.circle,
                    ),
                    todayTextStyle: TextStyle(color: Colors.black),
                    todayDecoration: BoxDecoration(
                      color: Colors.amber[100],
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
                Divider(height: 1),

                /// 선택한 날짜의 일기 목록
                Expanded(
                  child: bucketList.isEmpty
                      ? Center(
                    child: Text(
                      "이 날의 할 일이 없어요!",
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 18,
                      ),
                    ),
                  )
                      : ListView.separated(
                    itemCount: bucketList.length,
                    itemBuilder: (context, index) {
                      // 역순으로 보여주기
                      int i = bucketList.length - index - 1;
                      Bucket bucket = bucketList[i];
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
                                  setState(() {
                                  });
                                }
                            ),
                            Text(
                              DateFormat('kk:mm').format(bucket.createdAt),
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),

                        /// 클릭하여 update
                        onTap: () {
                          showUpdateDialog(bucketService, bucket);
                        },

                        /// 꾹 누르면 delete
                        onLongPress: () {
                          showDeleteDialog(bucketService, bucket);
                        },
                      );
                    },
                    separatorBuilder: (BuildContext context, int index) {
                      // item 사이에 Divider 추가
                      return Divider(height: 1);
                    },
                  ),
                ),
              ],
            ),
          ),

          /// Floating Action Button
          floatingActionButton: FloatingActionButton(
            child: Icon(Icons.create),
            backgroundColor: Colors.amber,
            onPressed: () {
              showCreateDialog(bucketService);
            },
          ),
        );
      },
    );
  }

  /// 작성하기
  /// 엔터를 누르거나 작성 버튼을 누르는 경우 호출
  void createBucket(BucketService bucketService) {
    // 앞뒤 공백 삭제
    String newText = createTextController.text.trim();
    if (newText.isNotEmpty) {
      bucketService.create(newText, selectedDate);
      createTextController.text = "";
    }
  }

  /// 수정하기
  /// 엔터를 누르거나 수정 버튼을 누르는 경우 호출
  void updateBucket(BucketService bucketService, Bucket bucket) {
    // 앞뒤 공백 삭제
    String updatedText = updateTextController.text.trim();
    if (updatedText.isNotEmpty) {
      bucketService.update(
        bucket.createdAt,
        updatedText,
      );
    }
  }

  /// 작성 다이얼로그 보여주기
  void showCreateDialog(BucketService bucketService) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("일기 작성"),
          content: TextField(
            controller: createTextController,
            autofocus: true,
            // 커서 색상
            cursorColor: Colors.amber,
            decoration: InputDecoration(
              hintText: "한 줄 일기를 작성해주세요.",
              // 포커스 되었을 때 밑줄 색상
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.amber),
              ),
            ),
            onSubmitted: (_) {
              // 엔터 누를 때 작성하기
              createBucket(bucketService);
              Navigator.pop(context);
            },
          ),
          actions: [
            /// 취소 버튼
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(
                "취소",
                style: TextStyle(color: Colors.amber),
              ),
            ),

            /// 작성 버튼
            TextButton(
              onPressed: () {
                createBucket(bucketService);
                Navigator.pop(context);
              },
              child: Text(
                "작성",
                style: TextStyle(color: Colors.amber),
              ),
            ),
          ],
        );
      },
    );
  }

  /// 수정 다이얼로그 보여주기
  void showUpdateDialog(BucketService bucketService, Bucket bucket) {
    showDialog(
      context: context,
      builder: (context) {
        updateTextController.text = bucket.text;
        return AlertDialog(
          title: Text("일기 수정"),
          content: TextField(
            autofocus: true,
            controller: updateTextController,
            // 커서 색상
            cursorColor: Colors.amber,
            decoration: InputDecoration(
              hintText: "한 줄 일기를 작성해 주세요.",
              // 포커스 되었을 때 밑줄 색상
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.amber),
              ),
            ),
            onSubmitted: (v) {
              // 엔터 누를 때 수정하기
              updateBucket(bucketService, bucket);
              Navigator.pop(context);
            },
          ),
          actions: [
            /// 취소 버튼
            TextButton(
              child: Text(
                "취소",
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.amber,
                ),
              ),
              onPressed: () => Navigator.pop(context),
            ),

            /// 수정 버튼
            TextButton(
              child: Text(
                "수정",
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.amber,
                ),
              ),
              onPressed: () {
                // 수정하기
                updateBucket(bucketService, bucket);
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }

  /// 삭제 다이얼로그 보여주기
  void showDeleteDialog(BucketService bucketService, Bucket bucket) {
    showDialog(
      context: context,
      builder: (context) {
        updateTextController.text = bucket.text;
        return AlertDialog(
          title: Text("일기 삭제"),
          content: Text('"${bucket.text}"를 삭제하시겠습니까?'),
          actions: [
            TextButton(
              child: Text(
                "취소",
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.amber,
                ),
              ),
              onPressed: () => Navigator.pop(context),
            ),

            /// Delete
            TextButton(
              child: Text(
                "삭제",
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.amber,
                ),
              ),
              onPressed: () {
                bucketService.delete(bucket.createdAt);
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }
}

// import 'package:flutter/material.dart';
//
// class Calender extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.lightGreen[100],
//       body: Center(
//         child: Text("캘린더", textScaleFactor: 3.0),
//       ),
//     );
//   }
// }