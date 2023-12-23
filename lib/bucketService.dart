import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

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
        .get();
  }

  /// Diary 작성
  void create(String text, String uid, DateTime selectedDate) async {
    // bucket 만들기
    Timestamp timestamp = Timestamp.fromDate(selectedDate);
    await bucketCollection.add({
      'uid': uid, // 유저 식별자
      'text': text, // 하고싶은 일
      'isDone': false, // 완료 여부
      'selectedDate': timestamp //목표 날짜
    });
    notifyListeners(); // 화면 갱신
  }

  /// Bucket 할 일 여부 수정
  void update(String docId, bool isDone) async {
    // createdAt은 중복될 일이 없기 때문에 createdAt을 고유 식별자로 사용
    // createdAt이 일치하는 diary 조회
    await bucketCollection.doc(docId).update({'isDone': isDone});
    notifyListeners();
  }

  /// Bucket 삭제
  void delete(String docId) async {
    await bucketCollection.doc(docId).delete();
    notifyListeners(); // 화면 갱신
  }
}