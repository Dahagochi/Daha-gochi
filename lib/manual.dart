import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import '../manual.dart';

class Manual extends StatefulWidget {
  Manual({super.key});

  @override
  State<Manual> createState() => _ManualState();
}

class _ManualState extends State<Manual> {
  String AppManualButtonText1 = 'close';
  String AppManualButtonText2 = 'next';
  //앱 메뉴얼 버튼 텍스트

  final ManuImages = [
    'assets/images/calendarManual.png',
    'assets/images/mainPageManual.png',
    'assets/images/hallOfFameManual.png'
  ];
  //App Manual에 들어갈 설명 이미지

  int _ManuIndex = 0;
  //App Manual에서 사진 넘길때 쓰이는 인덱스



  @override
  Widget build(BuildContext context) {
    return Container(
      height: 70,
      width: 400,
      child: ElevatedButton(
        onPressed: () {
          _ManuIndex = 0;
          AppManualButtonText1 = 'close';
          AppManualButtonText2 = 'next';
          showDialog(
            //팝업창을 띄우는 위젯
            barrierDismissible: false, //다른데 클릭해도 위젯 안 사라짐
            context: context,
            builder: (BuildContext cxt) {
              //dialog widget
              return StatefulBuilder(
                  builder: (BuildContext context, StateSetter setState) {
                    // 이거 없으면 alertDialogue에서 갱신이 닫을때만 적용
                    return AlertDialog(
                      backgroundColor: Colors.amberAccent,
                      title: Text(
                        "App Manual",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                        ),
                      ),
                      content: Column(
                        children: [
                          Image.asset(ManuImages[_ManuIndex]),
                          SizedBox(
                            height: 10,
                          ),
                          AnimatedSmoothIndicator(
                            activeIndex: _ManuIndex,
                            count: ManuImages.length,
                            effect: WormEffect(
                              dotColor: Colors.amber,
                              activeDotColor: Colors.white,
                            ),
                          ),
                        ],
                      ),
                      actions: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            TextButton(
                              onPressed: () {
                                if (_ManuIndex == 0) {
                                  Navigator.of(context).pop();
                                } else {
                                  _ManuIndex -= 1;
                                  setState(() {
                                    if (_ManuIndex == 0) {
                                      AppManualButtonText1 = 'close';
                                    } else {
                                      AppManualButtonText1 = 'prev';
                                      if (_ManuIndex == ManuImages.length - 2) {
                                        AppManualButtonText2 = 'next';
                                      }
                                    }
                                  });
                                }
                              },
                              child: Text(
                                AppManualButtonText1,
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                            TextButton(
                              onPressed: () {
                                if (_ManuIndex == ManuImages.length - 1) {
                                  Navigator.of(context).pop();
                                } else {
                                  _ManuIndex += 1;
                                  setState(() {
                                    if (_ManuIndex == ManuImages.length - 1) {
                                      AppManualButtonText2 = 'close';
                                    } else {
                                      AppManualButtonText2 = 'next';
                                      if (_ManuIndex == 1) {
                                        AppManualButtonText1 = 'prev';
                                      }
                                    }
                                  });
                                }
                              },
                              child: Text(
                                AppManualButtonText2,
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          ],
                        ),
                      ],
                    );
                  });
            },
          );
        },
        style: ElevatedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
          backgroundColor: Colors.amber,
          foregroundColor: Colors.white,
        ),
        child: Text("App Manual"),
      ),
    );
  }
}