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
      backgroundColor: Colors.white,
      body: GridView.builder(
        physics: ScrollPhysics(),
        scrollDirection: Axis.vertical,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2, //1개 행 당 item 개수 

          mainAxisSpacing: 0.0,
          crossAxisSpacing: 10.0, 
          
          childAspectRatio: 1.0, //item의 가로세로 비율
          ), 
          itemCount: CharacterList.length,
        itemBuilder: (BuildContext context, int index){
          return Container(
            child: Column(
              children: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.zero,
                    )
                  ),
                  onPressed: (){
                    showDialog(
                      context: context, 
                      builder: (BuildContext context){
                        //widget
                        return AlertDialog(
                          backgroundColor: Color.fromARGB(255, 154, 198, 104),
                          title: Text(
                            "Character Info",
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          ),
                          content: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
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
                child: Container(
                  constraints: BoxConstraints(
                    maxHeight: 200, 
                    maxWidth: 200,),
                  child: Image.asset(CharacterList[index]["image"],
                    fit: BoxFit.fill,
                  ),
                ),
                  
                ),
                SizedBox(
                  height: 2,
                ),
                Container(
                    height: 30,
                    width: 300,
                    decoration: BoxDecoration(
                      color: Colors.lightGreen,
                      borderRadius: BorderRadius.vertical(bottom: Radius.circular(10)),
                    ),
                    child: Center(
                      child: Text(
                        CharacterList[index]["name"],
                        style: TextStyle(
                          color: Colors.white,
                          ),
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
