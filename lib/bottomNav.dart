import 'package:flutter/material.dart';

class BottomNav extends StatefulWidget {
  @override
  _BottomNavState createState() => _BottomNavState();
}

class _BottomNavState extends State<BottomNav> {
  int currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      iconSize: 30,
      selectedFontSize: 8,
      unselectedFontSize: 8,
      backgroundColor: Colors.white,
      selectedItemColor: Colors.amber,
      unselectedItemColor: Colors.black12,
      showUnselectedLabels: true,
      currentIndex: currentIndex,
      items: [
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
        ),
      ],
      onTap: (idx) {
        setState(() {
          currentIndex = idx;
        });
        if (idx == 0) {
          Navigator.pushNamed(context, '/');
        } else if (idx == 1) {
          Navigator.pushNamed(context, '/calendar');
        } else if (idx == 2) {
          Navigator.pushNamed(context, '/hallOfFame');
        } else if (idx == 3) {
          Navigator.pushNamed(context, '/myPage');
        }
      },
    );
  }
}