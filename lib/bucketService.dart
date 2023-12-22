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

class BucketService with ChangeNotifier {
  /// Diary 목록
  List<Bucket> bucketList = [];

  /// 특정 날짜의 diary 조회
  List<Bucket> getByDate(DateTime date) {
    return bucketList
        .where((bucket) => isSameDay(date, bucket.createdAt))
        .toList();
  }

  /// Diary 작성
  void create(String text, DateTime selectedDate) {
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

    Bucket diary = Bucket(
      text: text,
      createdAt: createdAt,
      isDone: false, //초기에 생성 시 완수하지 않음
    );
    bucketList.add(diary);
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

  /// Diary 삭제
  void delete(DateTime createdAt) {
    // createdAt은 중복될 일이 없기 때문에 createdAt을 고유 식별자로 사용
    // createdAt이 일치하는 diary 삭제
    bucketList.removeWhere((bucket) => bucket.createdAt == createdAt);
    notifyListeners();
  }

  int calculateCompletedPlan(String date){               // 계획 체크버튼 갱신할때마다 계산해서 성장도에 반영
    int i, j;
    int lastday = daysInMonthFromString(date);
    int completedPlan = 0;
    List<Bucket> bucketList = [];

    for (i=1; i<= lastday; i++){
      if(i<=9) bucketList = getByDate(DateTime.parse('date-0${i}'));
      if(i>10) bucketList = getByDate(DateTime.parse('date-${i}'));
      for (j = 0; j<=bucketList.length; j++){
        if(bucketList[j].isDone == true) completedPlan++;
      }
    }
    return completedPlan;
  }
}

int daysInMonth(int year, int month) {
  // DateTime 객체를 이용하여 해당 월의 다음 월의 첫 날을 구합니다.
  DateTime nextMonth = DateTime(year, month + 1, 1);

  // 해당 월의 마지막 날짜는 다음 월의 첫 날의 하루 전입니다.
  DateTime lastDayOfMonth = nextMonth.subtract(Duration(days: 1));

  // 해당 월의 일수를 반환합니다.
  return lastDayOfMonth.day;
}
int daysInMonthFromString(String birth) {
  // 'yyyy-mm' 형식의 문자열을 '-'를 기준으로 나누어 List로 만듭니다.
  List<String> dateParts = birth.split('-');

  // 년도와 월을 추출하여 정수로 변환합니다.
  int year = int.parse(dateParts[0]);
  int month = int.parse(dateParts[1]);

  // daysInMonth 함수에 전달하여 해당 월의 일수를 얻습니다.
  return daysInMonth(year, month);
}