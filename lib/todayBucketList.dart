
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'auth_service.dart';
import 'bucketService.dart';

class TodayBucketList extends StatefulWidget {
  const TodayBucketList({
    Key? key,
    required this.selectedDate,
  }) : super(key: key);

  final DateTime selectedDate;

  @override
  State<TodayBucketList> createState() => _TodayBucketListState();
}

class _TodayBucketListState extends State<TodayBucketList> {
  @override
  Widget build(BuildContext context) {
    final authService = context.read<AuthService>();
    final user = authService.currentUser()!;
    return Consumer<BucketService>(
      builder: (context, bucketService, child) {
        return FutureBuilder<QuerySnapshot>(
          future: bucketService.read(user.uid, widget.selectedDate),
          builder: (context, snapshot) {
            final documents =
                snapshot.data?.docs ?? []; // 문서들 가져오기
            if (documents.isEmpty) {
              return Center(child: Text("버킷 리스트를 작성해주세요."));
            }
            return ListView.builder(
              itemCount: documents.length,
              itemBuilder: (context, index) {
                final doc = documents[index];
                String text = doc.get('text');
                bool isDone = doc.get('isDone');
                return Container(
                  margin: EdgeInsets.only(top: 10),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.white),
                  child: ListTile(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5)),
                    title: Container(
                      margin:
                      EdgeInsets.symmetric(horizontal: 15),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            text,
                            style: TextStyle(
                              fontSize: 24,
                              color: isDone
                                  ? Colors.grey
                                  : Colors.black,
                              decoration: isDone
                                  ? TextDecoration.lineThrough
                                  : TextDecoration.none,
                            ),
                          ),
                          Checkbox (
                              activeColor: Colors.lightGreen,
                              value: isDone,
                              onChanged: (value) {
                                bucketService.update(doc.id, !isDone);
                              })
                        ],
                      ),
                    ),
                    // 삭제 아이콘 버튼
                    trailing: IconButton(
                      icon: Icon(CupertinoIcons.delete),
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              title: const Text("할 일 삭제"),
                              content: Text('할 일을 삭제할까요?'),
                              actions: [
                                TextButton(
                                  child: const Text(
                                    "취소",
                                    style: TextStyle(
                                      fontSize: 18,
                                      color: Colors.lightGreen,
                                    ),
                                  ),
                                  onPressed: () =>
                                      Navigator.pop(context),
                                ),
                                TextButton(
                                  child: const Text(
                                    "삭제",
                                    style: TextStyle(
                                      fontSize: 18,
                                      color: Colors.lightGreen,
                                    ),
                                  ),
                                  onPressed: () {
                                    bucketService.delete(doc.id);
                                    Navigator.pop(context);
                                  },
                                )
                              ],
                            );
                          },
                        );
                      },
                    ),
                    onTap: () {
                      // 아이템 클릭하여 isDone 업데이트
                      bucketService.update(doc.id, !isDone);
                    },
                  ),
                );
              },
            );
          },
        );
      }
    );
  }
}