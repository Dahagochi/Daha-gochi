import 'package:dahagochi/bucketEditPage.dart';
import 'package:dahagochi/buecketService.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/intl.dart';

class CalenderPage extends StatefulWidget {
  @override
  State<CalenderPage> createState() => _CalenderPageState();
}

class _CalenderPageState extends State<CalenderPage> {
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
            child: Container(
              color: Colors.grey[100],
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: 25),
                child: Column(
                  children: [/// 달력
                    Container(
                      alignment: Alignment.centerLeft,
                      padding: EdgeInsets.only(top:40,bottom: 20),
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
                    SizedBox(height: 10,),
                    /// 선택한 날짜의 일기 목록
                    showBucketList(bucketList, bucketService),
                  ],
                ),
              ),
            ),
          ),

          /// Floating Action Button
          floatingActionButton: FloatingActionButton(
            backgroundColor: Colors.lightGreen,
            elevation: 0,
            child: Icon(Icons.create,color: Colors.white),
            //backgroundColor: Colors.amber,
            onPressed: () {
              int bucketLength = bucketService
                  .getByDate(selectedDate)
                  .length;
              if (bucketLength == 3) {
                ScaffoldMessenger.of(context).showSnackBar(
                  //SnackBar 구현하는법 context는 위에 BuildContext에 있는 객체를 그대로 가져오면 됨.
                    SnackBar(
                      backgroundColor: Colors.lightGreen[200],
                      content: Text('하루 일정은 3개까지만 가능해요!'),
                      showCloseIcon: true,
                      closeIconColor: Colors.white,
                      //snack bar의 내용. icon, button같은것도 가능하다.
                      duration: Duration(seconds: 2), //올라와있는 시간
                    )
                );
              }
              else{showCreateDialog(bucketService);}
            },
          ),
        );
      },
    );
  }

  Expanded showCalender(BucketService bucketService) {
    return Expanded(
                  child: Container(
                    padding: EdgeInsets.only(top: 0,left: 20,right: 20,bottom: 20),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.white
                    ),
                      height: MediaQuery.of(context).size.height * 0.45,
                      child: TableCalendar(
                        shouldFillViewport: true,
                          headerStyle:const HeaderStyle(
                            headerMargin: EdgeInsets.symmetric(horizontal:20),
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
                          eventLoader: (date) {
                            // 각 날짜에 해당하는 bucketList 보여주기
                            return bucketService.getByDate(date);
                          },
                          calendarStyle: CalendarStyle(
                            // today 색상 연하게, selectedDay는 진하게
                            selectedDecoration: BoxDecoration(
                              color:Colors.lightGreen[400],
                              shape:BoxShape.circle,
                            ),
                            todayTextStyle: const TextStyle(color: Colors.lightGreen),
                            todayDecoration: BoxDecoration(
                              color: Colors.lightGreen[100],
                              shape: BoxShape.circle,
                            ),
                            cellMargin: const EdgeInsets.all(3),
                            //cellPadding: const EdgeInsets.all(2),
                            //tablePadding: const EdgeInsets.symmetric(horizontal: 20)
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
                );
  }

  Expanded showBucketList(List<Bucket> bucketList, BucketService bucketService) {
    return Expanded(
                  child: bucketList.isEmpty
                      ? const Center(
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
                      Bucket bucket = bucketList[index];
                      return Material(
                        child: Container(
                          child: ListTile(
                            /// text
                            hoverColor: Colors.lightGreen[100],
                            tileColor: Colors.white,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5)),
                            title: Container(
                              margin: EdgeInsets.symmetric(horizontal: 15),
                              child: Text(
                                bucket.text,
                                style: const TextStyle(
                                  fontSize: 14,
                                  color: Colors.black,
                                ),
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
                                IconButton(
                                    onPressed:() {
                                      showDeleteDialog(bucketService, bucket);
                                    },
                                    icon: Icon(Icons.delete),
                                )
                              ],
                            ),

                            /// 클릭하여 update
                            onTap: () {
                              showUpdateDialog(bucketService, bucket);
                            },

                            /// 꾹 누르면 delete
                            onLongPress: () async{
                             await Navigator.of(context).push(MaterialPageRoute(
                                 builder: (BuildContext context)=> BucketEditPage(bucket: bucket)));
                            },
                          ),
                        ),
                      );
                    },
                    separatorBuilder: (BuildContext context, int index) {
                      // 여기서 간격을 조절
                      return SizedBox(height: 10); // 타일 간의 간격을 조절하기 위한 SizedBox
                    },
                  ),
                );
  }

  /// 작성하기
  /// 엔터를 누르거나 작성 버튼을 누르는 경우 호출
  void createBucket(BucketService bucketService) {
    // 앞뒤 공백 삭제
    String newText = createTextController.text.trim();
    if (newText.isNotEmpty) {
      bucketService.create(newText, selectedDate, context);
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
          title: Text("할 일 작성"),
          content: TextField(
            controller: createTextController,
            autofocus: true,
            // 커서 색상
            //cursorColor: Colors.amber,
            decoration: InputDecoration(
              hintText: "이 날 꼭 해야 할 일이 있나요?",
              // 포커스 되었을 때 밑줄 색상
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.lightGreen),
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
                style: TextStyle(color: Colors.lightGreen),
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
                style: TextStyle(color: Colors.lightGreen),
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
            //cursorColor: Colors.amber,
            decoration: InputDecoration(
              hintText: "한 줄 일기를 작성해 주세요.",
              // 포커스 되었을 때 밑줄 색상
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.lightGreen),
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
                  color: Colors.lightGreen,
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
                  color: Colors.lightGreen,
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
          title: const Text("할 일 삭제"),
          content: Text('"${bucket.text}"를 삭제하시겠습니까?'),
          actions: [
            TextButton(
              child: const Text(
                "취소",
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.lightGreen,
                ),
              ),
              onPressed: () => Navigator.pop(context),
            ),

            /// Delete
            TextButton(
              child: const Text(
                "삭제",
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.lightGreen,
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