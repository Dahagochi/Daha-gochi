import 'package:flutter/material.dart';

// 위젯 임시위치 다시 정렬하기 (화면 크기에 따라 자동으로 정렬하는 위젯??)
// 캐릭터 대사 txt asset 작성하기
// 게이지 표시 위젯 찾아보기
// 캐릭터 임시 이미지 가져오기
// 계획리스트 표시하는 컨테이너 리스트화

class MainPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.amber[100],
      body: Column(
        children: [
          Expanded(                     // 계획 리스트를 나열할 임시 컨테이너 (화면 상단에 정렬)
            child : Container(
              height: 150,
              width: double.infinity,
              padding: EdgeInsets.all(10),
              margin: EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: Colors.black),
              ),
            ),
            flex: 4,
          ),
          Expanded(                   // 현재 키우고있는 캐릭터와 캐릭터의 정보를 표시할 컨테이너 (화면 하단에 정렬)
            flex: 1,
              child: Container(
                height: 150,
                width: double.infinity,
                padding: EdgeInsets.all(10),
                margin: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: Colors.black),
                ),
                child: Row(
                  children: [
                    Container(           // 캐릭터 이미지 표시  (중앙 정렬)
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.black,
                        border: Border.all(color: Colors.black),
                      ),
                      margin: EdgeInsets.symmetric(horizontal: 15),
                      width: 100,
                      height: 100,
                    ),
                    Expanded(
                      child: Container(          // 대사, 성장도 게이지 표시  (중앙 정렬)
                        child: Column(
                          children: [
                            Expanded(
                              child:Container(        // 캐릭터 대사 컨테이너(Text위젯으로 변경예정)
                                height: 30,
                                width: double.infinity,
                                padding: EdgeInsets.all(5),
                                margin: EdgeInsets.all(5),
                                decoration: BoxDecoration(
                                  color: Colors.blue,
                                  border: Border.all(color: Colors.black),
                                ),
                              ),
                            ),
                            Expanded(
                              child: Container(         // 성장도 게이지 컨테이너(gauge 구현 )
                                height: 30,
                                width: double.infinity,
                                padding: EdgeInsets.all(5),
                                margin: EdgeInsets.all(5),
                                decoration: BoxDecoration(
                                  color: Colors.blue,
                                  border: Border.all(color: Colors.black),
                                ),
                              ),
                            ),

                          ],
                        ),
                      ),
                    ),

                  ],
                ),
              )
          ),

        ],
      ),
    );
  }
}