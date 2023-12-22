import 'package:flutter/material.dart';

const List<Map<String, dynamic>> CharacterList = [
  {"image": "images/0040060001972.jpg", "name": "fox1", "period": "null", "love": "null"},
  {"image": "images/0040060001982.jpg", "name": "lion1", "period": "null", "love": "null"},
  {"image": "images/0040060001972.jpg", "name": "fox1", "period": "null", "love": "null"},
  {"image": "images/0040060001972.jpg", "name": "fox1", "period": "null", "love": "null"},
  {"image": "images/0040060001972.jpg", "name": "fox1", "period": "null", "love": "null"},
  {"image": "images/0040060001972.jpg", "name": "fox1", "period": "null", "love": "null"},
  {"image": "images/0040060001972.jpg", "name": "fox1", "period": "null", "love": "null"},
  {"image": "images/0040060001982.jpg", "name": "lion1", "period": "null", "love": "null"},
];
//캐릭터 이미지들을 담은 딕셔너리 리스트, period는 키운 기간, love는 최종호감도를 의미

class HallOfFame extends StatefulWidget {
  @override
  _HallOfFameState createState()=> _HallOfFameState();
}
class _HallOfFameState extends State<HallOfFame> {
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.amber[100],
      body: GridView.builder(
        physics: ScrollPhysics(),
        scrollDirection: Axis.vertical,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2, //1개 행 당 item 개수 

          mainAxisSpacing: 10.0, //수평 패딩
          crossAxisSpacing: 10.0, //수직 패딩
          
          childAspectRatio: 1.0, //item의 가로세로 비율
          ), 
          itemCount: CharacterList.length,
        itemBuilder: (BuildContext context, int index){
          return Container(
            child: Column(
              children: [
                ElevatedButton(
                  style: ButtonStyle(
                    
                  ),
                  onPressed: (){
                    showDialog(
                      context: context, 
                      builder: (BuildContext context){
                        //widget
                        return AlertDialog(
                          backgroundColor: Colors.amberAccent,
                          title: Text(
                            "Character Info",
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          ),
                          content: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text(
                                "Name: "+CharacterList[index]["name"],
                                style: TextStyle(
                                  color: Colors.white,
                                ),
                              ),
                              Text(
                                "Period: "+CharacterList[index]["period"],
                                style: TextStyle(
                                  color: Colors.white,
                                ),
                              ),
                              Text(
                                "Final Friendship: "+CharacterList[index]["love"],
                                style: TextStyle(
                                  color: Colors.white,
                                ),
                              ),
                              Container(
                                height: 300,
                                width: 300,
                                child: 
                                  Image.asset(
                                    CharacterList[index]["image"],  
                                ),
                              ),
                            ],
                          ),
                          actions: [
                            TextButton(
                              onPressed: (){
                                Navigator.of(context).pop();
                              }, 
                              child: Text(
                                "close",
                                style: TextStyle(
                                  color: Colors.white,
                                ),
                                ),
                            )
                          ],
                        );
                      },
                    );
                  }, 
                  child: Image.asset(CharacterList[index]["image"]),
                ),
                SizedBox(
                  height: 2,
                ),
                Container(
                    height: 30,
                    width: 300,
                    decoration: BoxDecoration(
                      color: Colors.amberAccent,
                      borderRadius: BorderRadius.vertical(bottom: Radius.circular(10)),
                    ),
                    child: Center(
                      child: Text(
                        CharacterList[index]["name"],
                      ),
                    ),
                ),
              ],
            ),
          );
        }
        ),
    );
  }
}
