import 'package:intl/intl.dart';
import 'bucketService.dart';
import 'package:provider/provider.dart';

class MyCharacter{
  ///todo 속성 : 이름, 성장도, 레벨, 이미지, 대사(?), 캐릭터생성날짜(달마다 캐릭터 바꿔야해서)
  ///     기능 : 말일자정에 명예의전당으로 보내기 / 월초에 새로운 캐릭터로 초기화하기

  String name;
  String birth;
  int progress = 0;   // 계획을 하나 완료할 때마다 1씩 늘어나는 성장도
  late int max_progress;
  int level = 0;
  List<String> images = [];
  List<String> comment = [];

  MyCharacter({required this.name, required this.birth}){
    this.progress = calculateCompletedPlan(this.birth);
    this.max_progress = 5*daysInMonthFromString(birth);   // 5*해당 달의 일수
  }
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