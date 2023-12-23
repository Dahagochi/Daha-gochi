import 'package:flutter/material.dart';

const List<Map<String, dynamic>> CharacterList = [
  {
    "image": "images/0040060001972.jpg",
    "name": "fox1",
    "period": "null",
    "love": "null"
  },
  {
    "image": "images/0040060001982.jpg",
    "name": "lion1",
    "period": "null",
    "love": "null"
  },
  {
    "image": "images/0040060001972.jpg",
    "name": "fox1",
    "period": "null",
    "love": "null"
  },
  {
    "image": "images/0040060001972.jpg",
    "name": "fox1",
    "period": "null",
    "love": "null"
  },
  {
    "image": "images/0040060001972.jpg",
    "name": "fox1",
    "period": "null",
    "love": "null"
  },
  {
    "image": "images/0040060001972.jpg",
    "name": "fox1",
    "period": "null",
    "love": "null"
  },
  {
    "image": "images/0040060001972.jpg",
    "name": "fox1",
    "period": "null",
    "love": "null"
  },
  {
    "image": "images/0040060001982.jpg",
    "name": "lion1",
    "period": "null",
    "love": "null"
  },
];
//캐릭터 이미지들을 담은 딕셔너리 리스트, period는 키운 기간, love는 최종호감도를 의미

class HallOfFame extends StatefulWidget {
  @override
  _HallOfFameState createState() => _HallOfFameState();
}

class _HallOfFameState extends State<HallOfFame> {
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.lightGreen[100],
        body: Container(
          color: Colors.grey[100],
          child: Container(
            margin: EdgeInsets.symmetric(horizontal: 25),
            child: Column(
              children: [
                Container(
                  alignment: Alignment.centerLeft,
                  padding: EdgeInsets.only(top: 65),
                  child: const Text(
                    "명예의 전당",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Expanded(
                  child: GridView.builder(
                      physics: ScrollPhysics(),
                      scrollDirection: Axis.vertical,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2, //1개 행 당 item 개수
                        mainAxisSpacing: 10.0, //수평 패딩
                        crossAxisSpacing: 10.0, //수직 패딩
                        childAspectRatio: 1.0, //item의 가로세로 비율
                      ),
                      itemCount: CharacterList.length,
                      itemBuilder: (BuildContext context, int index) {
                        return Container(
                          child: Column(
                            children: [
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.white),
                                onPressed: () {
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      //widget
                                      return AboutCharacter(index: index);
                                    },
                                  );
                                },
                                child: Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.vertical(
                                          top: Radius.circular(10)),
                                    ),
                                    width: 300,
                                    child: Image.asset(
                                        CharacterList[index]["image"])),
                              ),
                              Container(
                                height: 30,
                                width: 300,
                                decoration: BoxDecoration(
                                  color: Colors.lightGreen,
                                  borderRadius: BorderRadius.vertical(
                                      bottom: Radius.circular(10)),
                                ),
                                child: Center(
                                  child: Text(
                                    CharacterList[index]["name"],
                                    style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      }),
                ),
              ],
            ),
          ),
        ));
  }
}

class AboutCharacter extends StatelessWidget {
  const AboutCharacter({
    super.key,
    required this.index,
  });

  final int index;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(20)),
      child: AlertDialog(
        content: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              padding: EdgeInsets.symmetric(vertical: 20),
              width: 120,
              child: Image.asset(
                CharacterList[index]["image"],
              ),
            ),
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: EdgeInsets.only(bottom: 30),
                  child: Text(
                    CharacterList[index]["name"],
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
                Text(
                  "함께 한 기간: " + CharacterList[index]["period"],
                  style: TextStyle(fontSize: 15, color: Colors.grey),
                ),
                Text(
                  "성장도:" + CharacterList[index]["love"],
                  style: TextStyle(fontSize: 15, color: Colors.grey),
                ),
              ],
            ),
          ],
        ),
        actionsAlignment: MainAxisAlignment.center,
        actions: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: 10),
            margin: EdgeInsets.only(bottom: 10),
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(10)),
            width: 280,
            height: 50,
            child: TextButton(
              style: TextButton.styleFrom(backgroundColor: Colors.lightGreen),
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text(
                "닫기",
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.white,
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
