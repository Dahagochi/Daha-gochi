import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'alertDialog.dart';

class BucketService extends ChangeNotifier {
  /// Diary 목록
  final bucketCollection = FirebaseFirestore.instance.collection('bucket');
  //이제부터 현재 접속된 이 유저의 할 일들은 bucketCollection에 모두 저장된다

  //List<Bucket> bucketList = [Bucket(text: "밥먹기", createdAt: DateTime.now(), isDone: false)];

  /// 특정 날짜의 diary 조회
  Future<QuerySnapshot> read(String uid, DateTime date) async {
    return bucketCollection
        .where('uid', isEqualTo: uid)
        .where('selectedDate', isEqualTo: Timestamp.fromDate(date))
        .get();}
    /// Diary 작성
  void create(String text, String uid,DateTime selectedDate) async {
    // bucket 만들기
    Timestamp timestamp = Timestamp.fromDate(selectedDate);
    await bucketCollection.add({
      'uid': uid, // 유저 식별자
      'text': text, // 하고싶은 일
      'isDone': false, // 완료 여부
      'selectedDate':timestamp //목표 날짜
    });
    notifyListeners(); // 화면 갱신
  }

  /// Bucket 할 일 여부 수정
  void update(String docId, bool isDone) async{
    // createdAt은 중복될 일이 없기 때문에 createdAt을 고유 식별자로 사용
    // createdAt이 일치하는 diary 조회
    await bucketCollection.doc(docId).update({'isDone':isDone});
    notifyListeners();
  }
  /// Bucket 삭제
  void delete(String docId) async{
    await bucketCollection.doc(docId).delete();
    notifyListeners(); // 화면 갱신
  }



  // int calculateCompletedPlan(String date){               // 계획 체크버튼 갱신할때마다 계산해서 성장도에 반영
  //   int i, j;
  //   int lastday = daysInMonthFromString(date);
  //   int completedPlan = 0;
  //   List<Bucket> bucketList = [];
  //
  //   for (i=1; i<= lastday; i++){
  //     if(i<=9) bucketList = getByDate(DateTime.parse('date-0${i}'));
  //     if(i>10) bucketList = getByDate(DateTime.parse('date-${i}'));
  //     for (j = 0; j<=bucketList.length; j++){
  //       if(bucketList[j].isDone == true) completedPlan++;
  //     }
  //   }
  //   return completedPlan;
  // }
}

int daysInMonth(DateTime date) {
  // DateTime 객체를 이용하여 해당 월의 다음 월의 첫 날을 구합니다.
  DateTime nextMonth = DateTime(date.year, date.month + 1, 1);

  // 해당 월의 마지막 날짜는 다음 월의 첫 날의 하루 전입니다.
  DateTime lastDayOfMonth = nextMonth.subtract(Duration(days: 1));

  // 해당 월의 일수를 반환합니다.
  return lastDayOfMonth.day;
}
// int daysInMonthFromString(String birth) {
//   // 'yyyy-mm' 형식의 문자열을 '-'를 기준으로 나누어 List로 만듭니다.
//   List<String> dateParts = birth.split('-');
//
//   // 년도와 월을 추출하여 정수로 변환합니다.
//   int year = int.parse(dateParts[0]);
//   int month = int.parse(dateParts[1]);
//
//   // daysInMonth 함수에 전달하여 해당 월의 일수를 얻습니다.
//   return daysInMonth(year, month);
// }