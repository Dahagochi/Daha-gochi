//// 코드 편집자 : 정승원

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'bucketService.dart';
import 'dart:async';
import 'dart:io';
import 'dart:convert';
import 'package:flutter/material.dart';

class MyCharacter{

  String name;
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

  MyCharacter({required this.name}){
    DateTime now = DateTime.now();
    this.birth = DateFormat('yyyy-MM').format(now);
    this.maxProgress = 5*daysInMonth(now);  // 5*해당 달의 일수

    File fileContent = File('assets/text/0.txt');
    this.comments = fileContent.readAsLinesSync(encoding: utf8,);
  }

  void updateProgressAndLevel(MyCharacter character, int completedPlan){
    int currentLevel = character.level;
    character.progress = completedPlan;

    if((progress>=0) & (progress<10)) {
      character.level=0;

    } else if((progress >= 10) & (progress < 30)) {
      character.level=1;
      if(character.level != currentLevel) {
        File fileContent = File('assets/text/1.txt');
        var fileContentList = fileContent.readAsLinesSync(encoding: utf8,);
        character.comments = List.from(fileContentList)..addAll(comments);

        updateMyCharacter(character.uid, character.level, character.progress, character.comments);
      }
    }else if((progress >= 30) & (progress < 70)) {
      character.level=2;

      if(character.level != currentLevel) {
        File fileContent = File('assets/text/2.txt');
        var fileContentList = fileContent.readAsLinesSync(encoding: utf8,);
        character.comments = List.from(fileContentList)..addAll(comments);

        updateMyCharacter(character.uid, character.level, character.progress, character.comments);
      }
    }else if(progress >= 70) {
      character.level=3;

      if(character.level != currentLevel) {
        File fileContent = File('assets/text/3.txt');
        var fileContentList = fileContent.readAsLinesSync(encoding: utf8,);
        character.comments = List.from(fileContentList)..addAll(comments);

        updateMyCharacter(character.uid, character.level, character.progress, character.comments);
      }
    }
  }

  CollectionReference myCharacterRef = FirebaseFirestore.instance.collection('character');

  void createMyCharacter(MyCharacter character, String uid) async {
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
  }

  Future<QuerySnapshot> read(String uid, bool progressIng) async {
    if (progressIng) {            // 메인페이지에서 표시할 캐릭터 읽기
      return myCharacterRef
          .where('uid', isEqualTo: uid)
          .where('progressIng', isEqualTo: progressIng)
          .get();
    } else {
      return myCharacterRef          // 명예의전당에서 표시할 캐릭터 읽기
          .where('uid', isEqualTo: uid)
          .where('progressIng', isEqualTo: progressIng)
          .get()
          .then((QuerySnapshot value) {
            List<QueryDocumentSnapshot> list = value.docs;
            list.forEach((QueryDocumentSnapshot element){
              String name = element.get("name");            // null인 경우
            });
          });
    }
  }

  void updateMyCharacter(String uid, int level, int progress, List<String> comments) async {
    DocumentReference docRef = await myCharacterRef.doc(uid);
    docRef.update({"level" : level});
    docRef.update({"progress" : progress});
    docRef.update({"comments" : comments});
    
  }

  void deleteMyCharacter(String uid) async {
    DocumentReference docRef = await myCharacterRef.doc(uid);
    docRef.delete();
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