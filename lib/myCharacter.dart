//// 코드 편집자 : 정승원

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'dart:async';
import 'package:flutter/material.dart';

class MyCharacter extends ChangeNotifier {
  late String name;
  String? birth;
  late int maxProgress;
  List<String> images = [
    'assets/images/0.png',
    'assets/images/1.png',
    'assets/images/2.png',
    'assets/images/3.png',
  ];
  List<String> comments = [];
  int progress = 0; // 계획을 하나 완료할 때마다 1씩 늘어나는 성장도
  int level = 0;
  bool progressIng = true;
  late String uid;

  final characterCollection =
      FirebaseFirestore.instance.collection('myCharacterRef');

  //코드 편집자: 김지혜 + 정승원

  //인자로 받은 level로 캐릭터 레벨 + 이미지 + 코멘트 변경
  void updateLevel(String uid, int level) async {

    QuerySnapshot result = await read(uid);
    final userData = result.docs[0];
    DocumentReference<Map<String, dynamic>> documentReference =
    characterCollection.doc(userData.id);
    Map<String, dynamic> data = userData.data() as Map<String, dynamic>;

    await documentReference.update({'level': level});
    if (level == 0) {
      //TODO 레벨1
      await documentReference.update({
        'image':
            "https://github.com/Dahagochi/Daha-gochi/blob/feature/JSW/assets/images/0.png?raw=true",
        'comments': "내 이름은 삐요!\n열심히 키워줘~"
      });
    } else if (level == 1) {
      //TODO 레벨2
      await documentReference.update({
        'image':
            "https://github.com/Dahagochi/Daha-gochi/blob/feature/JSW/assets/images/1.png?raw=true",
        'comments': "계획은 지킬 수 있을 만큼만~!"
      });
    } else if (level == 2) {
      //TODO 레벨3
      await documentReference.update({
        'image':
            "https://github.com/Dahagochi/Daha-gochi/blob/feature/JSW/assets/images/2.png?raw=true",
        'comments': "좋아 잘하고 있어!!\n이 기세 그대로!"
      });
    } else if (level == 3) {
      //TODO 레벨4
      await documentReference.update({
        'image':
            "https://github.com/Dahagochi/Daha-gochi/blob/feature/JSW/assets/images/3.png?raw=true",
        'comments': "넌 정말 대단해!\n노력은 배신 안 할거야"
      });
    }
    notifyListeners();
  }

//일정 완료,취소 시 실시간으로 펫의 성장도 수정
  Future<void> updateProgress(String uid, int completedPlan) async {
    QuerySnapshot result = await read(uid);
    final userData = result.docs[0];
    DocumentReference<Map<String, dynamic>> documentReference =
        characterCollection.doc(userData.id);
    Map<String, dynamic> data = userData.data() as Map<String, dynamic>;
    int currentProgress = data['progress'] as int;

    // 1을 더하고 업데이트
    int updatedValue = currentProgress + completedPlan;
    await documentReference.update({'progress': updatedValue});
    //레벨처리
    if (updatedValue < 10) {
      updateLevel(uid, 0);
    } else if (updatedValue < 30) {
      updateLevel(uid, 1);
    } else if (updatedValue < 70) {
      updateLevel(uid, 2);
    } else {
      updateLevel(uid, 3);
    }
    notifyListeners();
  }

  void createMyCharacter(String uid) async {
    await characterCollection.add({
      "name": "삐요",
      "birth": Timestamp.fromDate(DateTime.now()),
      "maxProgress": 300,
      "image":
          "https://github.com/Dahagochi/Daha-gochi/blob/feature/JSW/assets/images/0.png?raw=true",
      "comments": "응애! 열심히 키워죠",
      "progress": 0,
      "level": 0,
      "uid": uid,
      "progressIng": true
    });
    notifyListeners();
  }

  //현재 키우고 있는 얘 가져오기
  Future<QuerySnapshot> read(String uid) async {
    return characterCollection
        .where('uid', isEqualTo: uid)
        .where('progressIng', isEqualTo: true)
        .get();
  }

  //모든 캐릭터 가져오기
  Future<QuerySnapshot> readAll(String uid) async {
    return characterCollection.where('uid', isEqualTo: uid).get();
  }

//키우는 상태 false로 변경
//   void deleteMyCharacter(String uid) async {
//     CollectionReference myCharacterRef = db.collection('character');
//     DocumentReference docRef = await myCharacterRef.doc(uid);
//     docRef.delete();
//
//     notifyListeners();
//   }

  int daysInMonth(DateTime date) {
    // DateTime 객체를 이용하여 해당 월의 다음 월의 첫 날을 구합니다.
    DateTime nextMonth = DateTime(date.year, date.month + 1, 1);

    // 해당 월의 마지막 날짜는 다음 월의 첫 날의 하루 전입니다.
    DateTime lastDayOfMonth = nextMonth.subtract(Duration(days: 1));

    // 해당 월의 일수를 반환합니다.
    return lastDayOfMonth.day;
  }
}

//
//
//
// class MatureCharacter{
//   late List<MyCharacter> matureCharacters;
//
//   MatureCharacter() {
//     matureCharacters = [];
//   }
//
//   void addCharacter(MyCharacter character) {
//     matureCharacters.add(character);
//   }
//
//   Character getCharacterByName(String name) {
//     return characters.firstWhere((character) => character.name == name);
//   }
//
//   void updateCharacter(Character updatedCharacter) {
//     characters.removeWhere((character) => character.name == updatedCharacter.name);
//     characters.add(updatedCharacter);
//   }
//
//   void deleteCharacter(String name) {
//     characters.removeWhere((character) => character.name == name);
//   }
//
//   List<Character> getAllCharacters() {
//     return characters;
//   }
// }
