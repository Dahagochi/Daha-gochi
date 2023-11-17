import 'package:dahagochi/hallOfFame.dart';
import 'package:dahagochi/mainPage.dart';
import 'package:dahagochi/myPage.dart';
import 'package:flutter/material.dart';

import 'calenderPage.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  int _selectedIdx=0; // _는 private의 역할

  @override
  Widget build(BuildContext context) {
    List<Widget> screens = [MainPage(),Calender(),HallOfFame(),MyPage()];
    return MaterialApp(
      home:Scaffold(
        body:IndexedStack(
          index: _selectedIdx,
          children:screens,
        ),
        bottomNavigationBar: BottomNavigationBar(
          type: BottomNavigationBarType.fixed, //눌러도 애니메이션 효과 없음
          iconSize: 30,
          selectedFontSize: 8,
          unselectedFontSize: 8,
          backgroundColor: Colors.white,
          selectedItemColor: Colors.amber,
          unselectedItemColor: Colors.black12,
          showUnselectedLabels: true,
          currentIndex: _selectedIdx,
            onTap: (idx){ //네비게이션 바의 아이콘을 클릭했을 때
              setState(() {
                _selectedIdx=idx; //아이콘의 index를 받아와서 selectedIdx에 대입
              });//그렇게되면 setState()가 state가 바뀜 전달 => 화면 다시 렌더링
            },
          items: const [
            BottomNavigationBarItem(
                icon: Icon(Icons.home_filled),
                label: "오늘일정",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.calendar_today),
              label: "캘린더",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.emoji_events_outlined),
              label: "명예의전당",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.more_horiz),
              label: "마이페이지",
            )

          ],
        ),
      )
    );
  }
} 