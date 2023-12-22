import 'package:intl/intl.dart';
import 'bucketService.dart';
import 'package:provider/provider.dart';
import 'dart:async';
import 'dart:io';
import 'dart:convert';

class MyCharacter{

  String name;
  String birth;
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


  MyCharacter({required this.name, required this.birth}){
    this.maxProgress = 5*daysInMonthFromString(birth);   // 5*해당 달의 일수

    File fileContent = File('assets/text/0.txt');
    this.comments = fileContent.readAsLinesSync(encoding: utf8,);
  }

  void updateProgressAndLevel(MyCharacter character, int completedPlan){
    character.progress = completedPlan;

    if((progress>=0) & (progress<10)) {
      character.level=0;
    } else if((progress >= 10) & (progress < 30)) {
      character.level=1;

      File fileContent = File('assets/text/1.txt');                       //txt의 내용을 리스트화하여 character의 comment list에 추가
      var fileContentList = fileContent.readAsLinesSync(encoding: utf8,);
      character.comments = List.from(fileContentList)..addAll(comments);

    }else if((progress >= 30) & (progress < 70)) {
      character.level=2;

      File fileContent = File('assets/text/2.txt');
      var fileContentList = fileContent.readAsLinesSync(encoding: utf8,);
      character.comments = List.from(fileContentList)..addAll(comments);

    }else if(progress >= 70) {
      character.level=3;

      File fileContent = File('assets/text/3.txt');
      var fileContentList = fileContent.readAsLinesSync(encoding: utf8,);
      character.comments = List.from(fileContentList)..addAll(comments);

    }
  }

  //// c ////

  //// r ////

  //// u ////

  //// d ////

}



class MatureCharacter{
  late List<MyCharacter> matureCharacters;

  MatureCharacter() {
    matureCharacters = [];
  }

  void addCharacter(MyCharacter character) {
    matureCharacters.add(character);
  }
  //
  // Character getCharacterByName(String name) {
  //   return characters.firstWhere((character) => character.name == name);
  // }
  //
  // void updateCharacter(Character updatedCharacter) {
  //   characters.removeWhere((character) => character.name == updatedCharacter.name);
  //   characters.add(updatedCharacter);
  // }
  //
  // void deleteCharacter(String name) {
  //   characters.removeWhere((character) => character.name == name);
  // }
  //
  // List<Character> getAllCharacters() {
  //   return characters;
  // }
}