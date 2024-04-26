import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

//과제 목록 페이지

List<String> Test_post = ['연습1', '연습2', '연습3'];
List<String> R_data = [];


Future<List<String>> fetchDataFromDatabase() async {
  return ['route1', 'route2', 'route3'];
}

List<Widget> _buildPostListView(BuildContext context, List<String> postTitles) {
  List<Widget> items = [];

  for (String postTitle in postTitles) {
    items.add(
      Column(
        children: [
          SizedBox(
            height: 58.h,
            width: double.infinity,
            child: Ink(
              child: InkWell(
                onTap: (){
                  context.push(
                    '/post',
                    extra: {
                      'title': postTitle,
                      'kindOf': '과제',
                      'body': postTitle,
                    }
                  );
                },
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    postTitle,
                    style: const TextStyle(
                      fontSize: 20,
                      fontFamily: 'Noto Sans KR',
                      fontWeight: FontWeight.bold,
                      letterSpacing: -0.17,
                    ),
                  ),
                ),
              ),
            ),
          ),
          Container(
            decoration: const BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: Colors.grey,
                  width: 0.5,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
  return items;
}


class HomeworkListScreen extends StatefulWidget {
  const HomeworkListScreen({super.key});

  @override
  State<HomeworkListScreen> createState() => _HomeworkListScreenState();
}

class _HomeworkListScreenState extends State<HomeworkListScreen> {
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(390, 675),
      builder: (context, child) => Scaffold(
        appBar: AppBar(
          scrolledUnderElevation: 0,
          backgroundColor: const Color(0xFF0E9913),
          title: const Text(
            '과제',
            style: TextStyle(
              color: Colors.white,
              fontSize: 25,
              fontFamily: 'Noto Sans KR',
              fontWeight: FontWeight.w700,
            ),
          ),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          child: Column(
            children: _buildPostListView(context,Test_post),
          ),
        ),
      ),
    );
  }
}