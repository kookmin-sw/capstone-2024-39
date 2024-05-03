// import 'package:flutter/material.dart';
// import 'package:frontend/http.dart';
// 일단은 폐기
// final List<String> Thema = ['역사', '경제', '종교', '사회', '시집'];


// class GroupListProvider with ChangeNotifier {
//   List<List<dynamic>> GroupList = [[], [], [], [], []];

//   void makeGroupList() async {
//     for (int i = 0; i < Thema.length; i++) {
//       GroupList[i] = await groupSerachforTopic(Thema[i]);
//       // print(GroupList[i].length);
//     }
//     notifyListeners();
//   }

//   void updateGroupList() {
//     makeGroupList();
//   }
// }

// class Group {
//   final int id;
//   var bookId;
//   final String topic;
//   final String name;
//   final int maximum;
//   final String publication;

//   Group({
//     required this.id,
//     required this.bookId,
//     required this.topic,
//     required this.name,
//     required this.maximum,
//     required this.publication,
//   });
// }
