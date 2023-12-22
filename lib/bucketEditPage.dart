// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';
// import 'package:provider/provider.dart';
// import 'bucketService.dart';
//
// class BucketEditPage extends StatefulWidget {
//
//
//   const BucketEditPage({
//     Key? key,
//   }) : super(key: key);
//   @override
//   State<BucketEditPage> createState() => _BucketEditPageState();
// }
//
// class _BucketEditPageState extends State<BucketEditPage> {
//   final TextEditingController _editingController = TextEditingController();
//   final TextEditingController _controller = TextEditingController();
//   final TextEditingController _cycleController = TextEditingController(); //주기 입력
//
//   late List<String> listOfDays = ["월", "화", "수", "목", "금", "토", "일"];
//   late List<bool> selectedDays = List.generate(7, (index) => false);
//
//
//
//   @override
//   void initState() {
//     super.initState();
//     _editingController.text = widget.bucket.text;
//     String bucketDay = DateFormat('E', 'ko_KR').format(widget.bucket.createdAt);//TODO 요일로 변환
//     int indexOfBucketDay = listOfDays.indexOf(bucketDay);
//     // indexOfBucketDay가 -1이 아닌 경우(selectedDays 리스트에 포함된 경우)
//     if (indexOfBucketDay != -1) {
//       // 해당 위치에 대응하는 selectedDays 값을 true로 설정
//         selectedDays[indexOfBucketDay] = true;
//     }
//   }
//
//
//   @override
//   Widget build(BuildContext context) {
//     return Consumer<BucketService>(
//       builder: (context, bucketService, child) {
//         return GestureDetector(
//           onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
//           child: Scaffold(
//             // 키보드가 올라올 때 화면 밀지 않도록 만들기(overflow 방지)
//             resizeToAvoidBottomInset: false,
//             body: SafeArea(
//               child: Container(
//                 color: Colors.grey[100],
//                 child: Container(
//                   margin: EdgeInsets.symmetric(horizontal: 25),
//                   child: Column(
//                     children: [
//                       Container(
//                         child: Expanded(
//                           child: SingleChildScrollView(
//                             child: Column(
//                               children: [
//                                 /// 달력
//                                 Container(
//                                   padding: EdgeInsets.only(top: 40, bottom: 20),
//                                   alignment: Alignment.centerLeft,
//                                   child: const Text(
//                                     "할 일 수정",
//                                     style: TextStyle(
//                                       color: Colors.black,
//                                       fontSize: 22,
//                                       fontWeight: FontWeight.bold,
//                                     ),
//                                   ),
//                                 ),
//                                 Container(
//                                   padding: EdgeInsets.all(5),
//                                   alignment: Alignment.centerLeft,
//                                   child: const Text(
//                                     "내용 수정",
//                                     style: TextStyle(
//                                       color: Colors.grey,
//                                       fontSize: 18,
//                                       fontWeight: FontWeight.bold,
//                                     ),
//                                   ),
//                                 ),
//                                 SizedBox(height: 10,),
//                                 Container(
//                                   padding: EdgeInsets.symmetric(horizontal: 5),
//                                   decoration: BoxDecoration(
//                                       color: Colors.white,
//                                       borderRadius: BorderRadius.circular(10)),
//                                   child: TextField(
//                                     controller: _editingController,
//
//                                     //cursorColor: Colors.black,
//                                     decoration: InputDecoration(
//                                       border: InputBorder.none,
//                                       focusedBorder: InputBorder.none,
//                                       contentPadding: EdgeInsets.all(5),
//                                     ),
//                                   ),
//                                 ),
//                                 SizedBox(height: 15),
//                                 Container(
//                                   padding: EdgeInsets.all(5),
//                                   alignment: Alignment.centerLeft,
//                                   child: const Text(
//                                     "반복 주기",
//                                     style: TextStyle(
//                                       color: Colors.grey,
//                                       fontSize: 18,
//                                       fontWeight: FontWeight.bold,
//                                     ),
//                                   ),
//                                 ),
//                                 SizedBox(height: 10,),
//                                 Container(
//                                   padding: EdgeInsets.symmetric(horizontal: 5),
//                                   decoration: BoxDecoration(
//                                       color: Colors.white,
//                                       borderRadius: BorderRadius.circular(10)),
//                                   child: TextField(
//                                     controller: _controller,
//                                     //cursorColor: Colors.black,
//                                     decoration: InputDecoration(
//                                       hintText: '몇 주 동안 반복할까요?',
//                                       border: InputBorder.none,
//                                       focusedBorder: InputBorder.none,
//                                       contentPadding: EdgeInsets.all(5),
//                                     ),
//                                   ),
//                                 ),
//                                 Container(
//                                   padding: EdgeInsets.all(5),
//                                   alignment: Alignment.centerLeft,
//                                   child: const Text(
//                                     "반복 요일",
//                                     style: TextStyle(
//                                       color: Colors.grey,
//                                       fontSize: 18,
//                                       fontWeight: FontWeight.bold,
//                                     ),
//                                   ),
//                                 ),
//
//                                 SizedBox(height: 15),
//                                 Row(
//                                   mainAxisAlignment:
//                                   MainAxisAlignment.spaceAround,
//                                   children: [
//                                     for (int i = 0; i < 7; i++)
//                                       Container(
//                                         width: 45,
//                                         height: 45,
//                                         decoration: BoxDecoration(
//                                           borderRadius: BorderRadius.circular(
//                                               10),
//                                         ),
//                                         child: TextButton(
//                                           onPressed: () {
//                                             setState(() {
//                                               // 해당 버튼의 선택 상태를 토글합니다.
//                                               selectedDays[i] =
//                                               !selectedDays[i];
//                                             });
//                                           },
//                                           style: TextButton.styleFrom(
//                                             backgroundColor: selectedDays[i]
//                                                 ? Colors.lightGreen
//                                                 : Colors.grey[300],
//                                           ),
//                                           child: Text(
//                                             listOfDays[i],
//                                             style: TextStyle(
//                                               fontSize: 15,
//                                               color: selectedDays[i]
//                                                   ? Colors.white
//                                                   : Colors.grey,
//                                             ),
//                                           ),
//                                         ),
//                                       ),
//                                   ],
//                                 ),
//                                 SizedBox(height: 20),
//
//                               ],
//                             ),
//                           ),
//                         ),
//                       ),
//                       SizedBox(height: 10,),
//                       ElevatedButton(
//                         onPressed: () {
//                           updateBucket(context, bucketService, widget.bucket);//TODO
//                           Navigator.of(context).pop();
//                         },
//                         child: Text(
//                           "수정하기",
//                           style: TextStyle(color: Colors.white),
//                         ),
//                         style: ElevatedButton.styleFrom(
//                           backgroundColor: Colors.lightGreen,
//                           disabledBackgroundColor: Colors.lightGreen[100],
//                           minimumSize: const Size.fromHeight(50),
//                         ),
//                       ),
//                       SizedBox(height: 20,)
//                     ],
//                   ),
//                 ),
//               ),
//             ),
//           ),
//         );
//       },
//     );
//   }
//
//   void updateBucket(BuildContext context, BucketService bucketService, Bucket bucket) {
//     // 앞뒤 공백 삭제
//     String editedText = _editingController.text.trim();
//     if (editedText.isNotEmpty) {
//       bucketService.update(bucket.createdAt, editedText);
//     }
//   }
// }
