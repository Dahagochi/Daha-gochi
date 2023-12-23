//// 코드 편집자 : 정승원

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'bucketService.dart';
import 'dart:async';
import 'dart:io';
import 'dart:convert';
import 'package:flutter/material.dart';

class MyCharacter extends ChangeNotifier{

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
  int progress = 0;   // 계획을 하나 완료할 때마다 1씩 늘어나는 성장도
  int level = 0;
  bool progressIng = true;
  late String uid;

  MyCharacter(){
    DateTime now = DateTime.now();
    this.birth = DateFormat('yyyy-MM').format(now);
    this.maxProgress = 5*daysInMonth(now);  // 5*해당 달의 일수

    File fileContent = File('assets/text/0.txt');
    this.comments = [
      '한달동안 열심히 해보자!',
      '난 계획을 실천한 만큼 성장해',
      '내 이름은 삐요!'
    ];
  }

  void updateProgressAndLevel(MyCharacter character, int completedPlan){
    int currentLevel = character.level;
    character.progress = completedPlan;

    if((progress>=0) & (progress<10)) {
      character.level=0;

    } else if((progress >= 10) & (progress < 30)) {
      character.level=1;
      if(character.level != currentLevel) {
        character.comments = [
          '계획은 지킬 수 있는 만큼만!',
          '조금만 힘내~'
        ];

        updateMyCharacter(character.uid, character.level, character.progress, character.progressIng, character.comments);
      }
    }else if((progress >= 30) & (progress < 70)) {
      character.level=2;

      if(character.level != currentLevel) {
        character.comments = [
          '오늘도 파이팅!',
          '좋아 잘하고 있어!!'
        ];

        updateMyCharacter(character.uid, character.level, character.progress, character.progressIng, character.comments);
      }
    }else if(progress >= 70) {
      character.level=3;

      if(character.level != currentLevel) {
        character.comments = [
          '넌 정말 대단해!',
          '노력은 배신하지 않아!'
        ];

        updateMyCharacter(character.uid, character.level, character.progress, character.progressIng, character.comments);
      }
    }
  }

  FirebaseFirestore db = FirebaseFirestore.instance;


  void createMyCharacter(MyCharacter character, String uid) async {
    CollectionReference myCharacterRef = db.collection('character');
    DocumentReference documentRef = await myCharacterRef.add({
      "name" : name,
      "birth" : birth,
      "maxProgress" : maxProgress,
      "image" : images,
      "comments": comments,
      "progress": progress,
      "level" : level,
      "uid" : uid,
      "progressIng" : progressIng
    });
    notifyListeners();
  }

  // Future<QuerySnapshot> read(String uid, bool progressIng) async {
  //   CollectionReference myCharacterRef = db.collection('users');
  //   DocumentReference documentRef = myCharacterRef.doc('uid');
  //
  //   if (progressIng) {            // 메인페이지에서 표시할 캐릭터 읽기
  //     return  myCharacterRef
  //         .where('uid', isEqualTo: uid)
  //         .where('progressIng', isEqualTo: progressIng)
  //         .get();
  //   } else {                   // 명예의전당에서 표시할 캐릭터 읽기
  //     return myCharacterRef
  //         .where('uid', isEqualTo: uid)
  //         .where('progressIng', isEqualTo: progressIng)
  //         .get()
  //         .then((QuerySnapshot value) {
  //           List<QueryDocumentSnapshot> list = value.docs;
  //           list.forEach((QueryDocumentSnapshot element){
  //             String name = element.get("name");
  //             String birth = element.get('birth');
  //             int progress = element.get('progress');
  //           });
  //         })
  //         .catchError((onError) => print('Error Occured'));
  //   }
  // }

  void updateMyCharacter(String uid, int level, int progress, bool progressIng, List<String> comments) async {
    CollectionReference myCharacterRef = db.collection('character');
    DocumentReference docRef = await myCharacterRef.doc(uid);
    docRef.update({"level" : level});
    docRef.update({"progress" : progress});
    docRef.update({"comments" : comments});
    docRef.update({"progressIng" : progressIng});

    notifyListeners();
  }

  void deleteMyCharacter(String uid) async {
    CollectionReference myCharacterRef = db.collection('character');
    DocumentReference docRef = await myCharacterRef.doc(uid);
    docRef.delete();

    notifyListeners();
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