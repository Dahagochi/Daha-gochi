import 'package:flutter/material.dart';
import 'mainPage.dart';
import 'calenderPage.dart';
import 'hallOfFame.dart';
import 'myPage.dart';

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIdx = 0;

  @override
  Widget build(BuildContext context) {
    List<Widget> screens = [MainPage(), CalenderPage(), HallOfFame(), MyPage()];
    return Scaffold(
      body: IndexedStack(
        index: _selectedIdx,
        children: screens,
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        iconSize: 30,
        selectedFontSize: 8,
        unselectedFontSize: 8,
        backgroundColor: Colors.white,
        selectedItemColor: Colors.lightGreen,
        unselectedItemColor: Colors.black12,
        showUnselectedLabels: true,
        currentIndex: _selectedIdx,
        onTap: (idx) {
          setState(() {
            _selectedIdx = idx;
          });
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
    );
  }
}
