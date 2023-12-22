import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

class Bucket {
  String text; // 내용
  DateTime createdAt; // 작성 시간
  bool isDone=false;

  Bucket({
    required this.text,
    required this.createdAt,
    required this.isDone,
  });
}

class BucketService extends ChangeNotifier {
  /// Diary 목록
  List<Bucket> bucketList = [Bucket(text: "밥먹기", createdAt: DateTime.now(), isDone: false)];

  /// 특정 날짜의 diary 조회
  List<Bucket> getByDate(DateTime date) {
    return bucketList
        .where((bucket) => isSameDay(date, bucket.createdAt))
        .toList();
  }

  /// Diary 작성
  void create(String text, DateTime selectedDate,BuildContext context) {
    DateTime now = DateTime.now();
    // 선택된 날짜(selectedDate)에 현재 시간으로 추가
    DateTime createdAt = DateTime(
      selectedDate.year,
      selectedDate.month,
      selectedDate.day,
      now.hour,
      now.minute,
      now.second,
    );

    Bucket bucket = Bucket(
      text: text,
      createdAt: createdAt,
      isDone: false, //초기에 생성 시 완수하지 않음
    );

    if (bucketList.length == 3) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.lightGreen[200],
          content: Text('하루 일정은 3개까지만 가능해요!'),
          showCloseIcon: true,
          closeIconColor: Colors.white,
          duration: Duration(seconds: 2),
        ),
      );
    } else {
      Bucket bucket = Bucket(
        text: text,
        createdAt: createdAt,
        isDone: false,
      );
      bucketList.add(bucket);
    }
    notifyListeners();
  }

  /// Diary 수정
  void update(DateTime createdAt, String newContent) {
    // createdAt은 중복될 일이 없기 때문에 createdAt을 고유 식별자로 사용
    // createdAt이 일치하는 diary 조회
    Bucket bucket = bucketList.firstWhere((bucket) => bucket.createdAt == createdAt);
    // text 수정
    bucket.text = newContent;
    notifyListeners();
  }

  void repeate(DateTime createdAt){}
  /// Diary 삭제
  void delete(DateTime createdAt) {
    // createdAt은 중복될 일이 없기 때문에 createdAt을 고유 식별자로 사용
    // createdAt이 일치하는 diary 삭제
    bucketList.removeWhere((bucket) => bucket.createdAt == createdAt);
    notifyListeners();
  }

  void updateRepeat(DateTime createdAt, String newContent, List<bool> selectedDays){
    //selectedDays를 통해 반복 일정
    Bucket bucket = bucketList.firstWhere((bucket) => bucket.createdAt == createdAt);
    bucket.text = newContent; // 계획명 수정

    notifyListeners();
  }

}