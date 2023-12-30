import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dahagochi/myCharacter.dart';
import 'package:flutter/material.dart';
import 'auth_service.dart';
import 'bottomNav.dart';
import 'package:provider/provider.dart';

class HallOfFame extends StatefulWidget {
  @override
  _HallOfFameState createState() => _HallOfFameState();
}

class _HallOfFameState extends State<HallOfFame> {
  FirebaseFirestore db = FirebaseFirestore.instance;

  Widget build(BuildContext context) {
    final authService = context.read<AuthService>();
    final user = authService.currentUser()!;

    return Consumer<MyCharacter>(
      builder: (context, myCharacter, child) {
        return FutureBuilder<QuerySnapshot>(
            future: myCharacter.readAll(user.uid),
            builder: (context, snapshot) {
              final documents = snapshot.data?.docs ?? []; // 문서들 가져오기
              if (documents.isEmpty) {
                return Center(
                    child: Container(child: Text("아직 함께한 친구들이 없네요!")));
              } else {
                return Scaffold(
                  backgroundColor: Colors.lightGreen[100],
                  body: Container(
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
                                gridDelegate:
                                    SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2, //1개 행 당 item 개수
                                  mainAxisSpacing: 10.0, //수평 패딩
                                  crossAxisSpacing: 10.0, //수직 패딩
                                ),
                                itemCount: documents.length,
                                itemBuilder: (BuildContext context, int index) {
                                  final doc = documents[index];
                                  return Container(
                                    child: Column(
                                      children: [
                                        ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                              shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.vertical(
                                                    top: Radius.circular(10)), // 0으로 설정하면 네모로 만들어집니다
                                              ),
                                              backgroundColor: Colors.white),
                                          onPressed: () {
                                            showDialog(
                                              context: context,
                                              builder: (BuildContext context) {
                                                //widget
                                                return AboutCharacter(doc: doc);
                                              },
                                            );
                                          },
                                          child: Container(
                                            height: 130,
                                            child:ClipRRect(
                                              borderRadius: BorderRadius.zero,
                                              child:Image.network(doc.get('image'),fit: BoxFit.fitHeight)),
                                          ),
                                        ),
                                        Container(
                                          height: 30,
                                          width:double.infinity,
                                          decoration: BoxDecoration(
                                            color: Colors.lightGreen,
                                            borderRadius: BorderRadius.vertical(
                                                bottom: Radius.circular(10)),
                                          ),
                                          child: Center(
                                            child: Text(
                                             doc.get('name'),
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.bold),
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
                  ),
                );
              }
            });
      },
    );
  }
}

class AboutCharacter extends StatelessWidget {
  const AboutCharacter({
    super.key,
    required this.doc,
  });

  final dynamic doc; //형식 잘 모르겠어서ㅠㅠ

  @override
  Widget build(BuildContext context) {
    return Container(
      child: AlertDialog(
        content: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              padding: EdgeInsets.symmetric(vertical: 20),
              width: 120,
              child: Image.network(
                doc.get('image'),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(right: 40),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    padding: EdgeInsets.only(bottom: 30),
                    child: Text(
                      doc.get('name'),
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ),
                  // Text(
                  //   "태어난 날" + doc.get('birth').toDate().toString(),
                  //   style: TextStyle(fontSize: 15, color: Colors.grey),
                  // ),
                  Text(
                    "성장도:" + doc.get('progress').toString(),
                    style: TextStyle(fontSize: 15, color: Colors.grey),
                  ),
                ],
              ),
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
