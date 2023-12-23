//// 코드 편집자 : 정승원

import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:async';
import 'dart:io';
import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

//이후 코드 작성자: 김지혜
class Character extends ChangeNotifier {
  final characterCollection = FirebaseFirestore.instance.collection(
      'myCharacterRef'); // 스토리지에 존재하는 캐릭터 리스트를 불러옴
  final DateTime date = DateTime.now();

  Future<QuerySnapshot> getNowCharacter(String uid) async {
    DateTime startOfMonth = DateTime(date.year, date.month, 1);
    return characterCollection
        .where('uid', isEqualTo: uid)
        .where('birth', isEqualTo: Timestamp.fromDate(
        startOfMonth)) //실행 당시 date의 생년월과 동일한 캐릭터 검색 => TODO- mainScreen.dart에 띄울 것
        .where('progressIng',isEqualTo: true)
        .get();
  }

  void updateProgress(String docId, int completedPlan) async {
    try {
      // upateProgressAndLeve(docId,-1)같은 식으로 활용
      DocumentSnapshot documentSnapshot = await characterCollection.doc(docId).get();
      if (documentSnapshot.exists) {
        Map<String, dynamic> characterData = documentSnapshot.data() as Map<String, dynamic>;
        //progress 증감
        int resultProgress = characterData['progress']+completedPlan;
        // 진행률 파베에 반영
        await characterCollection.doc(docId).update({'progress': resultProgress});

        if(resultProgress==10 || resultProgress==29){
          await characterCollection.doc(docId).update({'level': 1});//TODO imageurl 변경 반영
        }
        else if(resultProgress==9){
          await characterCollection.doc(docId).update({'level':0});
        }
        else if (resultProgress==30 || resultProgress==69){
          await characterCollection.doc(docId).update({'level': 2});
        }
        else if (resultProgress==70){
          await characterCollection.doc(docId).update({'level': 3});
        }
        notifyListeners();
      } else {
        print('Document does not exist');
      }
    } catch (e) {
      print('Error updating progress and level: $e');
    }
  }

  void createMyCharacter(String name, String uid, String imageUrl,
        String comments) async
    {
      QuerySnapshot<Map<String, dynamic>> querySnapshot = await characterCollection
          .where('uid', isEqualTo: uid)
          .where('birth', isEqualTo: Timestamp.fromDate(date)) //TODO date의 첫 날과 같은지
          .get();

      int maxprogress = (5 * daysInMonth(date));
      DocumentReference documentRef = await characterCollection.add({
        "name": name,
        "birth": date,
        "maxProgress": maxprogress,
        "image": imageUrl,
        "comments": comments,
        "progress": 0,
        "level": 0,
        "uid": uid,
        "progressIng": true
      });
    }

    void updateMyCharacter(String uid, int level, int progress,
        List<String> comments) async {
      DocumentReference docRef = await characterCollection.doc(uid);
      docRef.update({"level": level});
      docRef.update({"progress": progress});
      docRef.update({"comments": comments});
    }


    int daysInMonth(DateTime date) {
      // DateTime 객체를 이용하여 해당 월의 다음 월의 첫 날을 구합니다.
      DateTime nextMonth = DateTime(date.year, date.month + 1, 1);

      // 해당 월의 마지막 날짜는 다음 월의 첫 날의 하루 전입니다.
      DateTime lastDayOfMonth = nextMonth.subtract(Duration(days: 1));

      // 해당 월의 일수를 반환합니다.
      return lastDayOfMonth.day;
    }
  }